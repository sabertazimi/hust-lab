#include <stdio.h>
#include "csapp.h"

/* Recommended max cache and object sizes */
#define MAX_CACHE_SIZE 1049000
#define MAX_OBJECT_SIZE 102400

/* You won't lose style points for including this long line in your code */
static const char *user_agent_hdr = "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120305 Firefox/10.0.3\r\n";
static const char *accept_str= "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\nAccept-Encoding: gzip, deflate\r\n";
static const char *connection = "Connection: close\r\nProxy-Connection: close\r\n";

struct arg {
    int connfd;
    int turn;
};

void parse_url(char *url, char *hostname, char *query_path, int *port);
int connect_server(char *hostname, int port, char *query_path);
void *thread(void *connfdp);

struct cache_block {
    char data[MAX_OBJECT_SIZE];
    sem_t mutex;
    sem_t w;
    int readcnt;

    int turn;
    sem_t t_mutex;
    sem_t t_w;
    int t_readcnt;

    char url[300];
    sem_t url_mutex
    sem_t url_w;
    int url_readcnt;
};

struct cache_block cache[10];

void cache_erase(int index);
void cache_write(int index, char *url, char *data, int turn);
void cache_data_read(int index, char *dst, int turn);
void cache_url_read(int index, char *dst);
int cache_turn_read(int index);

int main()
{
    Signal(SIGPIPE, SIG_IGN);
    struct sockaddr_in clientaddr;
    int post, listenfd, clientlen;
    int turn = 1;
    pthread_t tid;
    struct arg *p;

    if (argc != 2) {
        fprintf(stdout, "usage: %s <port>\n", argv[0]);
        exit(0);
    }

    for (int i = 0; i < 10; i++) {
        cache_erase[i];
    }

    port = atoi(argv[1]);
    listenfd = Open_listenfd(port);
    clientlen = sizeof(clientaddr);

    while (1) {
        p = (int *)Malloc(sizeof(struct arg));
        p->connfd = Accept(listenfd, (SA*)&clientaddr, &clientlen);
        p->turn = turn++;
        Pthread_create(&tid, NULL, thread, (void *)p);
    }

    return 0;
}

void parse_url(char *url, char *hostname, char *query_path, int *port) {
    char _url[100];
    _url[0] = '\0';
    strcat(_url, url);
    hostname[0] = query_path[0] = '\0';
    char *p = strstr(_url, "//");

    if (p) {
        p += 2;
    } else {
        p = _url;
    }

    char *q = strstr(p, ":");

    if (q) {
        *q = '\0';
        sscanf(p, "%s", hostname);
        sscanf(q+1, "%d%s", port, query_path);
    } else {
        q = strstr(p, "/");

        if (q) {
            *q = '\0';
            sscanf(p, "%s", hostname);
            *q = '/';
            sscanf(q, "%s", query_path);
        } else {
            sscanf(p, "%s", hostname);
        }

        *port = 80;
    }

    if (strlen(query_path) <= 1) {
        strcpy(query_path, "/index.html");
    }
}

int connect_server(char *hostname, int port, char *query_path) {
    char buf[MAXLINE];
    int proxy_clientfd;

    proxy_clientfd = Open_clientfd(hostname, port);
    sprintf(buf, "GET %s HTTP/1.0\r\n", query_path);
    Rio_writen(proxy_clientfd, buf, strlen(buf);
    Rio_writen(proxy_clientfd, user_agent_hdr, strlen(user_agent_hdr));
    Rio_writen(proxy_clientfd, accept_str, strlen(accept_str));
    Rio_writen(proxy_clientfd, connection, strlen(connection));
    Rio_writen(proxy_clientfd, "\r\n", strlen("\r\n"));

    return proxy_clientfd;
}
