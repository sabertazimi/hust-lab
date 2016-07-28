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

void parse_url(char *url, char *hostname, char *query_path, char *port);
int connect_server(char *hostname, char *port, char *query_path);
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
    sem_t url_mutex;
    sem_t url_w;
    int url_readcnt;
};

struct cache_block cache[10];

void cache_erase(int index);
void cache_write(int index, char *url, char *data, int turn);
void cache_data_read(int index, char *dst, int turn);
void cache_url_read(int index, char *dst);
int cache_turn_read(int index);

int main(int argc, char *argv[])
{
    Signal(SIGPIPE, SIG_IGN);
    struct sockaddr_in clientaddr;
    int listenfd, clientlen;
    int turn = 1;
    pthread_t tid;
    struct arg *p;

    if (argc != 2) {
        fprintf(stdout, "usage: %s <port>\n", argv[0]);
        exit(0);
    }

    for (int i = 0; i < 10; i++) {
        cache_erase(i);
    }

    listenfd = Open_listenfd(argv[1]);
    clientlen = sizeof(clientaddr);

    while (1) {
        p = (struct arg *)Malloc(sizeof(struct arg));
        p->connfd = Accept(listenfd, (SA*)&clientaddr, &clientlen);
        p->turn = turn++;
        Pthread_create(&tid, NULL, thread, (void *)p);
    }

    return 0;
}

void parse_url(char *url, char *hostname, char *query_path, char *port) {
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

// treat proxy as client
int connect_server(char *hostname, char *port, char *query_path) {
    char buf[MAXLINE];
    int proxy_clientfd;

    proxy_clientfd = Open_clientfd(hostname, port);
    sprintf(buf, "GET %s HTTP/1.0\r\n", query_path);
    Rio_writen(proxy_clientfd, buf, strlen(buf));
    Rio_writen(proxy_clientfd, user_agent_hdr, strlen(user_agent_hdr));
    Rio_writen(proxy_clientfd, accept_str, strlen(accept_str));
    Rio_writen(proxy_clientfd, connection, strlen(connection));
    Rio_writen(proxy_clientfd, "\r\n", strlen("\r\n"));

    return proxy_clientfd;
}

// treat proxy as server
void *thread(void *p) {
    // make thread can be free automatically
    Pthread_detach(pthread_self());

    int connfd = ((struct arg*)p)->connfd,
        turn = ((struct arg*)p)->turn;
    free(p);

    char buf[MAXLINE];
    char method[MAXLINE],
         version[MAXLINE],
         url[MAXLINE];
    char host[MAXLINE],
         port[MAXLINE],
         query[MAXLINE];
    char url_tmp[300],
         *data_tmp;
    rio_t rio;
    int index,
        content_length;
    int serverfd;

    rio_readinitb(&rio, connfd);
    rio_readlineb(&rio, buf, MAXLINE);
    sscanf(buf, "%s %s %s", method, url, version);

    if (strcasecmp(method, "GET")) {
        printf("Not Get\r\n");
        Close(connfd);
        return NULL;
    }

    do {
        rio_readlineb(&rio, buf, MAXLINE - 1);
    } while (strcmp(buf, "\r\n"));

    for (index = 0; index < 10; index++) {
        cache_url_read(index, url_tmp);
        if (!strcmp(url, url_tmp)) {
            // found in cache
            break;
        }
    }

    data_tmp = (char *)Malloc(MAX_OBJECT_SIZE);
    data_tmp[0] = '\0';

    if (index < 10) {
        // directly return data(cache) to client(browser)
        cache_data_read(index, data_tmp, turn);
        rio_writen(connfd, data_tmp, strlen(data_tmp));
        Close(connfd);
        free(data_tmp);
        return NULL;
    }

   // connect to server
   parse_url(url, host, query, port);

   if ((serverfd = connect_server(host, port, query)) < 0) {
        free(data_tmp);
        Close(connfd);
        return NULL;
   }

   content_length = 0;

   // read response header
   do {
       int t = rio_readlineb(&rio, buf, MAXLINE - 1);

       if ( t <= 0) {
           break;
       }

       strncat(data_tmp, buf, t);

       if (strstr(buf, "Content-length") != NULL) {
           sscanf(buf, "Content-length: %d\r\n", &content_length);
       }

       rio_writen(connfd, buf, t);
   } while (strcmp(buf, "\r\n"));

   // read response body
   if (content_length + strlen(data_tmp) < MAX_OBJECT_SIZE) {
        while (content_length > 0) {
            int t = rio_readnb(&rio, buf, (content_length < MAXLINE - 1) ? content_length : MAXLINE - 1);

            if (t <= 0) {
                continue;
            }

            content_length -= t;
            strncat(data_tmp, buf, t);
            rio_writen(connfd, buf, t);
        }
        
        index = 0;
        for(int i = 1; i < 10; i++) {
            if(cache_turn_read(i) < cache_turn_read(index)) {
                index = i;
            }
        }

        // cache write
        cache_write(index, url, data_tmp, turn);
    } else {
        // there no enough cache space
        while(content_length > 0) {
             int t = rio_readnb(&rio, buf, (content_length < MAXLINE - 1) ? content_length : MAXLINE - 1);

             if(t <= 0) {
                 break;
             }

             content_length -= t;
             rio_writen(connfd, buf, t);
         }
    }

     Close(connfd);
     Close(serverfd);
     free(data_tmp);
     return NULL;
}

void cache_erase(int index)
{
    cache[index].turn = 0;    
    cache[index].url[0] = '\0';
    cache[index].data[0] = '\0';
    Sem_init(&cache[index].t_mutex, 0, 1);
    Sem_init(&cache[index].t_w, 0, 1);
    cache[index].t_readcnt = 0;
    Sem_init(&cache[index].url_mutex, 0, 1);
    Sem_init(&cache[index].url_w, 0, 1);
    cache[index].url_readcnt = 0;
    Sem_init(&cache[index].mutex, 0, 1);
    Sem_init(&cache[index].w, 0, 1);
    cache[index].readcnt = 0;
}
 
void cache_write(int index,char *url, char *data, int turn) {
    // semaphore
    P(&cache[index].url_w);
    P(&cache[index].w);
    P(&cache[index].t_w);

    cache[index].turn = turn;
    strcpy(cache[index].data, data);
    strcpy(cache[index].url, url);

    // semaphore
    V(&cache[index].t_w);
    V(&cache[index].w);
    V(&cache[index].url_w);
}
 
void cache_data_read(int index, char *dst, int turn) {
    // semaphore
    P(&cache[index].mutex);
    cache[index].readcnt++;
    if (cache[index].readcnt == 1) {
        P(&cache[index].w);
    }
    V(&cache[index].mutex);
    P(&cache[index].t_w);

    cache[index].turn=turn;
    strcpy(dst,cache[index].data);

    // semphore
    V(&cache[index].t_w);
    P(&cache[index].mutex);
    if (cache[index].readcnt == 0) {
        V(&cache[index].w);
    }
    cache[index].readcnt--;
    V(&cache[index].mutex);
}

void cache_url_read(int index,char *dst)
{
    // semaphore
    P(&cache[index].url_mutex);
    cache[index].url_readcnt++;
    if (cache[index].url_readcnt == 1) {
        P(&cache[index].url_w);
    }
    V(&cache[index].url_mutex);

    strcpy(dst,cache[index].url);

    // semphore
    P(&cache[index].url_mutex);
    if (cache[index].url_readcnt == 0) {
        V(&cache[index].url_w);
    }
    cache[index].url_readcnt--;
    V(&cache[index].url_mutex);
}

int cache_turn_read(int index)
{
    int t;

    // semaphore
    P(&cache[index].t_mutex);
    cache[index].t_readcnt++;
    if (cache[index].t_readcnt == 1) {
        P(&cache[index].t_w);
    }
    V(&cache[index].t_mutex);

    t=cache[index].turn;

    // semphore
    P(&cache[index].t_mutex);
    cache[index].t_readcnt--;
    if (cache[index].t_readcnt == 0) {
        V(&cache[index].t_w);
    }
    V(&cache[index].t_mutex);
 
    return t;
}
