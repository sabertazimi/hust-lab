#include <winsock.h>
// for Winsock 2, include <winsock2.h>

const unsigned short DEFAULT_SERVER_PORT = 80;

int main(int argc, char **argv) {
	WSADATA  wsaData;
	int nRc = WSAStartup(0x0101, & wsaData);

	if (nRc) {
		// Winsock初始化错误
		perror("Failed to WSAStartup.\n");
		return;
	}

	if (wsaData.wVersion != 0x0101) {
		// 版本支持不够
		// 报告错误给用户，清除Winsock，返回
		perror("Required version missing.\n")
		WSACleanup();
		return -1;
	}

	int nSockErr;

	SOCKET sServSock;   // 服务器监听socket
	sockaddr_in addr;

	int nNumConns = 0;  // 当前请求连接数
	SOCKET sConns[5];   // 会话SOCKET数组

	sockaddr ConnAddrs[5];// 请求连接的客户端地址
	int nAddrLen;

	// 创建服务器监听socket
	sServSock = socket(AF_INET, SOCK_STREAM, 0);

	addr.sin_family = AF_INET;
	addr.sin_port = htons(DEFAULT_SERVER_PORT);
	addr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);

	if (bind(sServSock, (LPSOCKADDR)&addr, sizeof(addr)) == SOCKET_ERROR ) {
		nSockErr = WSAGetLastError();
		// 绑定出错处理
		perror("Failed to bind socket.\n");
		return -1;
	}

	// 监听客户端请求连接
	if (listen(sServSock, SOMAXCONN) == SOCKET_ERROR) {
		nSockErr = WSAGetLastError();
		// 出错处理
		perror("Failed to listen.\n");
		return -1;
	}

	while (nNumConns < 5) {
		// 每当收到客户端连接请求，创建新的会话SOCKET，保存在/ //sConns数组中
		// 客户端地址保存在ConnAddrs数组中
		sConns[nNumConns] = accept(sServSock, ConnAddrs[nNumConns], &nAddrLen);

		if (sConns[nNumConns] == INVALID_SOCKET) {
			nSockErr = WSAGetLastError();
			// 创建会话SOCKET出错处理
		} else {
			// 创建会话SOCKET成功，启动新的线程与客户端会话
			StartNewHandlerThread(sConns[nNumConns]);
			// 当前请求连接数+1
			nNumConns ++;
		}
	}

	return 0;
}
