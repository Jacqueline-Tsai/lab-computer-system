/**
 * @file proxy.c
 * @brief A web proxy program that handle requests from client concurrently.
 *
 * @author Yun Hsuan <yunhsuat@andrew.cmu.edu>
 */

/* Some useful includes to help you get started */

#include "csapp.h"
#include "http_parser.h"

#include <assert.h>
#include <ctype.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>

#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <signal.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>

/*
 * Debug macros, which can be enabled by adding -DDEBUG in the Makefile
 * Use these if you find them useful, or delete them if not
 */
#ifdef DEBUG
#define dbg_assert(...) assert(__VA_ARGS__)
#define dbg_printf(...) fprintf(stderr, __VA_ARGS__)
#else
#define dbg_assert(...)
#define dbg_printf(...)
#endif

typedef struct sockaddr SA;

/*
 * String to use for the User-Agent header.
 * Don't forget to terminate with \r\n
 */
static const char *header_user_agent = "Mozilla/5.0"
                                       " (X11; Linux x86_64; rv:3.10.0)"
                                       " Gecko/20240719 Firefox/63.0.1";

/**
 * @brief Append a string to a buffer, reallocating the buffer if necessary.
 *
 * @param buffer Pointer to the buffer where the string will be appended.
 * @param str The string to append to the buffer.
 */
void append_string(char **buffer, const char *str) {
    size_t new_size = strlen(*buffer) + strlen(str) + 1;
    *buffer = realloc(*buffer, new_size);
    if (*buffer == NULL) {
        perror("Failed to reallocate buffer");
        exit(EXIT_FAILURE);
    }
    strcat(*buffer, str);
}

/**
 * @brief Returns an error message to the client
 *
 * @param client_fd The file descriptor of the client socket.
 * @param errnum The error number.
 * @param shortmsg A short message describing the error.
 * @param longmsg A long message describing the error.
 */
void clienterror(int client_fd, const char *errnum, const char *shortmsg,
                 const char *longmsg) {
    dbg_printf("clienterror\n");

    char header[MAXLINE];
    char body[MAXBUF];
    size_t headerlen;
    size_t bodylen;

    /* Build the HTTP response body */
    bodylen = snprintf(body, MAXBUF,
                       "<!DOCTYPE html>\r\n"
                       "<html>\r\n"
                       "<head><title>Tiny Error</title></head>\r\n"
                       "<body bgcolor=\"ffffff\">\r\n"
                       "<h1>%s: %s</h1>\r\n"
                       "<p>%s</p>\r\n"
                       "<hr /><em>The Tiny Web server</em>\r\n"
                       "</body></html>\r\n",
                       errnum, shortmsg, longmsg);
    if (bodylen >= MAXBUF) {
        return; // Overflow!
    }

    /* Build the HTTP response headers */
    headerlen = snprintf(header, MAXLINE,
                         "HTTP/1.0 %s %s\r\n"
                         "Content-Type: text/html\r\n"
                         "Content-Length: %zu\r\n\r\n",
                         errnum, shortmsg, bodylen);
    if (headerlen >= MAXLINE) {
        return; // Overflow!
    }

    /* Write the headers */
    if (rio_writen(client_fd, header, headerlen) < 0) {
        fprintf(stderr, "Error writing error response headers to client\n");
        return;
    }

    /* Write the body */
    if (rio_writen(client_fd, body, bodylen) < 0) {
        fprintf(stderr, "Error writing error response body to client\n");
        return;
    }
}

/**
 * @brief Send an HTTP request to the server.
 *
 * @param client_fd The file descriptor of the client socket.
 * @param host The host to which the request is sent.
 * @param port The port on which the request is sent.
 * @param path The path of the requested resource.
 * @param request_line The initial request line of the HTTP request.
 * @param headers The HTTP headers to include in the request.
 */
void send_request(int client_fd, const char *host, const char *port,
                  const char *path, const char *request_line,
                  const char *headers) {
    char request[1024];

    char body[MAXBUF];
    size_t bodylen;
    rio_t rio;

    int socket_fd = open_clientfd(host, port);

    snprintf(request, sizeof(request), "%s%s%s\r\n", request_line, headers,
             header_user_agent);
    if (send(socket_fd, request, strlen(request), 0) == -1) {
        perror("send");
        close(socket_fd);
        return;
    }

    rio_readinitb(&rio, socket_fd);
    while ((bodylen = rio_readnb(&rio, body, MAXLINE)) > 0) {
        body[bodylen] = '\0';
        if (rio_writen(client_fd, body, bodylen) < 0) {
            dbg_printf("Error writing error response body to client %d\n",
                       client_fd);
            return;
        }
    }
}

/**
 * @brief Parse the request line of an HTTP request.
 *
 * @param request_line The HTTP request line to parse.
 * @param method_val Pointer to the method value.
 * @param host_val Pointer to the host value.
 * @param scheme_val Pointer to the scheme value.
 * @param uri_val Pointer to the URI value.
 * @param port_val Pointer to the port value.
 * @param path_val Pointer to the path value.
 * @param http_version_val Pointer to the HTTP version value.
 * @return bool True if the request line was successfully parsed, false
 * otherwise.
 */
bool parse_request_line(
    const char *request_line, const char *method_val[MAXLINE],
    const char *host_val[MAXLINE], const char *scheme_val[MAXLINE],
    const char *uri_val[MAXLINE], const char *port_val[MAXLINE],
    const char *path_val[MAXLINE], const char *http_version_val[MAXLINE]) {
    parser_t *parser_pointer = parser_new();
    int parser_retrieve_result;

    parser_state parse_state_result =
        parser_parse_line(parser_pointer, request_line);
    if (parse_state_result != REQUEST) {
        dbg_printf("Parse error. Not a request. (state %d)\n",
                   parse_state_result);
        return false;
    }

    if ((parser_retrieve_result =
             parser_retrieve(parser_pointer, METHOD, method_val)) < 0) {
        dbg_printf("Parser retrieve error (%d)\n", parser_retrieve_result);
        return false;
    }
    dbg_printf("Method: %s\n", *method_val);

    if ((parser_retrieve_result =
             parser_retrieve(parser_pointer, HOST, host_val)) < 0) {
        dbg_printf("Parser retrieve error (%d)\n", parser_retrieve_result);
        return false;
    }
    dbg_printf("Host: %s\n", *host_val);

    if ((parser_retrieve_result =
             parser_retrieve(parser_pointer, SCHEME, scheme_val)) < 0) {
        dbg_printf("Parser retrieve error (%d)\n", parser_retrieve_result);
        return false;
    }
    dbg_printf("Scheme: %s\n", *scheme_val);

    if ((parser_retrieve_result =
             parser_retrieve(parser_pointer, URI, uri_val)) < 0) {
        dbg_printf("Parser retrieve error (%d)\n", parser_retrieve_result);
        return false;
    }
    dbg_printf("URI: %s\n", *uri_val);

    if ((parser_retrieve_result =
             parser_retrieve(parser_pointer, PORT, port_val)) < 0) {
        dbg_printf("Parser retrieve error (%d)\n", parser_retrieve_result);
        return false;
    }
    dbg_printf("Port: %s\n", *port_val);

    if ((parser_retrieve_result =
             parser_retrieve(parser_pointer, PATH, path_val)) < 0) {
        dbg_printf("Parser retrieve error (%d)\n", parser_retrieve_result);
        return false;
    }
    dbg_printf("Path: %s\n", *path_val);

    if ((parser_retrieve_result = parser_retrieve(parser_pointer, HTTP_VERSION,
                                                  http_version_val)) < 0) {
        dbg_printf("Parser retrieve error (%d)\n", parser_retrieve_result);
        return false;
    }
    dbg_printf("HTTP Version: %s\n", *http_version_val);

    return true;
}

/**
 * @brief Handle the client request.
 *
 * @param client_fd The file descriptor of the client socket.
 */
void handle_request(int client_fd) {
    dbg_printf("handle_request. client_fd %d\n", client_fd);

    char request_line[MAXLINE];
    rio_t rio;

    rio_readinitb(&rio, client_fd);

    size_t n;
    if ((n = rio_readlineb(&rio, request_line, MAXLINE)) == 0) {
        clienterror(client_fd, "404", "Not Found", "");
        return;
    }

    const char *method_val[MAXLINE], *host_val[MAXLINE], *scheme_val[MAXLINE],
        *uri_val[MAXLINE], *port_val[MAXLINE], *path_val[MAXLINE],
        *http_version_val[MAXLINE];
    if (!parse_request_line(request_line, method_val, host_val, scheme_val,
                            uri_val, port_val, path_val, http_version_val)) {
        clienterror(client_fd, "404", "Not Found", "");
        return;
    }

    if (strcmp(*method_val, "GET") != 0) {
        dbg_printf("Not a get request\n");
        clienterror(client_fd, "501", "Not Implemented",
                    "This is not a GET request.");
        return;
    }

    char *header = malloc(sizeof(char));
    header[0] = '\0';
    char buf[MAXLINE];
    while ((n = rio_readlineb(&rio, buf, MAXLINE)) > 0) {
        append_string(&header, buf);
        if (strcmp(buf, "\r\n") == 0) {
            break;
        }
    }

    send_request(client_fd, *host_val, *port_val, *path_val, request_line,
                 header);

    return;
}

/**
 * @brief Handle the client request in a separate thread.
 *
 * @param vargp Pointer to the client file descriptor.
 * @return void* NULL
 */
void *thread_handle_request(void *vargp) {
    int client_fd = *((int *)vargp);
    free(vargp);

    handle_request(client_fd);
    close(client_fd);

    return NULL;
}

/**
 * @brief The main function of the proxy server.
 */
int main(int argc, char **argv) {
    signal(SIGPIPE, SIG_IGN);

    int listenfd, *client_fd;
    socklen_t clientlen;
    struct sockaddr_storage clientaddr;
    char client_hostname[MAXLINE], client_port[MAXLINE];

    listenfd = open_listenfd(argv[1]);
    while (1) {
        clientlen = sizeof(struct sockaddr_storage);
        client_fd = malloc(sizeof(int));
        *client_fd = accept(listenfd, (SA *)&clientaddr, &clientlen);
        getnameinfo((SA *)&clientaddr, clientlen, client_hostname, MAXLINE,
                    client_port, MAXLINE, 0);
        dbg_printf("Connected to (%s, %s, %d)\n", client_hostname, client_port,
                   *client_fd);

        pthread_t tid;
        int rc = pthread_create(&tid, NULL, thread_handle_request, client_fd);
        if (rc != 0) {
            fprintf(stderr, "pthread_create failed: %s\n", strerror(rc));
            close(*client_fd);
            free(client_fd);
        } else {
            // Detach the thread to reclaim resources automatically
            pthread_detach(tid);
        }
    }

    return 0;
}
