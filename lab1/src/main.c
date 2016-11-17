/*!
 * \file main.c
 * \brief entry file for pipe and signal lab
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-17
 * \license MIT
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>     ///< for fork()    and pipe()    function
#include <sys/types.h>  ///< for kill()    and waitpid() function
#include <sys/wait.h>   ///< for waitpid()               function
#include <signal.h>     ///< for kill()    and signal()  function

pid_t c1, c2;           ///< pid for child process 1 and child process 2

/// \brief handler get invoked when process get signal
/// \param sig_no numero symbol of signal
/// \return void
void handler(int sig_no) {
    switch(sig_no) {
        case SIGINT:
            kill(c1, SIGUSR1);
            kill(c2, SIGUSR2);
            break;
        case SIGUSR1:
            fprintf(stdout, "Child Process 1 is Killed by Parent!\n");
            exit(0);
        case SIGUSR2:
            fprintf(stdout, "Child Process 2 is Killed by Parent!\n");
            exit(0);
        default:
            break;
    }
}

/*
 * parent : create pipe -> close pipe, create process -> wait process, handle SIGINT signal(send signal to children)
 * child 1: write data to pipe, ignore SIGINT signal, handle SIGUSRONE signal
 * child 2: read data from pipe, ignore SIGINT signal, handle SIGUSRTWO signal
 */
int main(void) {
    int status;         ///< child process exit status buffer

    int pipe_fd[2];     ///< pipe file descriptor for reading from pipe and writing to pipe
    char w_buf[80];     ///< write buffer
    char r_buf[80];     ///< read buffer

    if (pipe(pipe_fd) < 0) {
        perror("create pipe failed\n");
        exit(-1);
    }

    // set handle for SIGINT
    signal(SIGINT, handler);

    while ((c1 = fork()) == -1) ;       // while loop for error recovery
    if (c1 == 0) {                      // child 1
        int cnt = 1;

        signal(SIGINT, SIG_IGN);        // ignore SIGINT signal
        signal(SIGUSR1, handler);       // handle SIGUSR signal

        // write data to pipe
        close(pipe_fd[0]);
        sleep(1);

        // child 1 won't exit, until get SIGUSRONE signal
        while (1) {
            sprintf(w_buf, "I send you %d times\n", cnt++);
            if (write(pipe_fd[1], w_buf, 80) < 0) {
                perror("write error\n");
                exit(-1);
            }
        }
    } else {                            // parent
        while ((c2 = fork()) == -1) ;   // while loop for error recovery
        if (c2 == 0) {                  // child 2
            signal(SIGINT, SIG_IGN);    // ignore SIGINT signal
            signal(SIGUSR2, handler);   // handle SIGUSR signal

            // read data from pipe
            close(pipe_fd[1]);
            sleep(1);

            // child 2 won't exit, until get SIGUSRTWO signal
            while (1) {
                if (read(pipe_fd[0], r_buf, 80) < 0) {
                    perror("read error\n");
                    exit(-1);
                }
                fprintf(stdout, "%s", r_buf);
            }
        } else {                        // parent
            // when parent get SIGINT signal, it will send SIGUSR signal to children to kill them
            // wait child process to finish
            for (int i = 0; i < 2;i++) {
                waitpid(-1, &status, 0);
            }

            close(pipe_fd[0]);          // close read file descriptor for pipe
            close(pipe_fd[1]);          // close write file descriptor for pipe
            fprintf(stdout, "Parent Process is Killed!\n");
        }
    }

    return 0;
}
