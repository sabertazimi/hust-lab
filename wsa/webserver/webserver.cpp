// webserver.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <stdio.h>
#include <winsock2.h>)
#include <list>
#include <algorithm>
#include <string.h>

#define MAXCONN 5
#define BUFLEN 255
#define SERVER_PORT 80

using namespace std;

typedef list<SOCKET> ListCONN;
typedef list<SOCKET> ListConErr;

int main(int argc, char **argv) {
	WSADATA wsaData;
	int nRC;

	sockaddr_in srvAddr;
	sockaddr_in clientAddr;
	SOCKET srvSock;

	int nAddrLen = sizeof(sockaddr);

	char sendBuf[BUFLEN];
	char recvBuf[BUFLEN];

	ListCONN conList;		// 保存所有有效的会话SOCKET
	ListCONN::iterator itor;
	ListConErr conErrList;	// 保存所有失效的会话SOCKET
	ListConErr::iterator itor1;

	FD_SET rfds;
	FD_SET wfds;
	u_long uNonBlock;

	// 初始化 winsock
	nRC = WSAStartup(0x0101, &wsaData);
	if (nRC) {
		printf("Server initialize winsock error!\n");
		return -1;
	}

	if (wsaData.wVersion != 0x0101) {
		printf("Server's winsock version error!\n");
		WSACleanup();
		return -1;
	}

	printf("Server's winsock initialized !\n");

	// 创建 TCP socket
	srvSock = socket(AF_INET, SOCK_STREAM, 0);
	if (srvSock == INVALID_SOCKET) {
		printf("Server create socket error!\n");
		WSACleanup();
		return -1;
	}

	printf("Server TCP socket create OK!\n");

	// 绑定 socket to Server's IP and port 80
	srvAddr.sin_family = AF_INET;
	srvAddr.sin_port = htons(SERVER_PORT);
	srvAddr.sin_addr.S_un.S_addr = INADDR_ANY;
	nRC = bind(srvSock, (LPSOCKADDR)&srvAddr, sizeof(srvAddr));
	if (nRC == SOCKET_ERROR) {
		printf("Server socket bind error!\n");
		closesocket(srvSock);
		WSACleanup();
		return -1;
	}
	printf("Server socket bind OK!\n");

	// 开始监听过程，等待客户的连接
	nRC = listen(srvSock, MAXCONN);
	if (nRC == SOCKET_ERROR) {
		printf("Server socket listen error!\n");
		closesocket(srvSock);
		WSACleanup();
		return -1;
	}

	printf("Start to listen for http request!\n");

	// 将srvSock设为非阻塞模式以监听客户连接请求
	uNonBlock = 1;
	ioctlsocket(srvSock, FIONBIO, &uNonBlock);

	while (true) {
		// 从conList中删除已经产生错误的会话SOCKET
		for (itor1 = conErrList.begin(); itor1 != conErrList.end(); itor1++) {
			itor = find(conList.begin(), conList.end(), *itor1);
			if (itor != conList.end()) conList.erase(itor);
		}

		// 清空read, write套接字集合
		FD_ZERO(&rfds);
		FD_ZERO(&wfds);

		// 设置等待客户连接请求
		FD_SET(srvSock, &rfds);

		for (itor = conList.begin(); itor != conList.end(); itor++) {
			// 把所有会话SOCKET设为非阻塞模式
			uNonBlock = 1;
			ioctlsocket(*itor, FIONBIO, &uNonBlock);
			// 设置等待会话SOKCET可接受数据或可发送数据
			FD_SET(*itor, &rfds);
			FD_SET(*itor, &wfds);
		}

		// 开始等待
		int nTotal = select(0, &rfds, &wfds, NULL, NULL);

		// 如果srvSock收到连接请求，接受客户连接请求
		if (FD_ISSET(srvSock, &rfds)) {
			nTotal--;
			// 产生会话SOCKET
			SOCKET connSock = accept(srvSock, (LPSOCKADDR)&clientAddr, &nAddrLen);
			if (connSock == INVALID_SOCKET) {
				printf("Server accept connection request error!\n");
				closesocket(srvSock);
				WSACleanup();
				return -1;
			}

			sprintf(sendBuf, "来自%s的游客进入聊天室!\n", inet_ntoa(clientAddr.sin_addr));
			printf("%s", sendBuf);

			// 将产生的会话SOCKET保存在conList中
			conList.insert(conList.end(), connSock);
		}
		
		if (nTotal > 0) {
			// 检查所有有效的会话SOCKET是否有数据到来
			// 或是否可以发送数据
			for (itor = conList.begin(); itor != conList.end(); itor++) {
				// 如果会话SOCKET可以发送数据，
				// 则向客户发送消息
				if (FD_ISSET(*itor, &wfds)) {
					// 如果发送缓冲区有内容，则发送
					if (strlen(sendBuf) > 0) {
						nRC = send(*itor, sendBuf, strlen(sendBuf), 0);
						if (nRC == SOCKET_ERROR) {
							// 发送数据错误，
							// 记录下产生错误的会话SOCKET
							conErrList.insert(conErrList.end(), *itor);
						}
						else {
							// 发送数据成功，清空发送缓冲区
							memset(sendBuf, '\0', BUFLEN);
						}
					}
				}

				// 如果会话SOCKET有数据到来，则接受客户的数据
				if (FD_ISSET(*itor, &rfds)) {
					nRC = recv(*itor, recvBuf, BUFLEN, 0);
					if (nRC == SOCKET_ERROR) {
						// 接受数据错误，
						// 记录下产生错误的会话SOCKET
						conErrList.insert(conErrList.end(), *itor);
					} else {
						// 接收数据成功，保存在发送缓冲区中，
						// 以发送到所有客户去
						recvBuf[nRC] = '\0';
						sprintf(sendBuf, "\n游客说:%s\n", recvBuf);
						printf("%s", sendBuf);
					}
				}
			}
		}
	}

	closesocket(srvSock);
	WSACleanup();

	return 0;
}

