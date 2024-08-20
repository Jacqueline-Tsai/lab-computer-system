/**
 * @file tsh.c
 * @brief A tiny shell program with job control
 *
 * TODO: Delete this comment and replace it with your own.
 * <The line above is not a sufficient documentation.
 *  You will need to write your program documentation.
 *  Follow the 15-213/18-213/15-513 style guide at
 *  http://www.cs.cmu.edu/~213/codeStyle.html.>
 *
 * @author Yun Hsuan <yunhsuat@andrew.cmu.edu>
 * TODO: Include your name and Andrew ID here.
 */

#include "csapp.h"
#include "tsh_helper.h"

#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

/*
 * If DEBUG is defined, enable contracts and printing on dbg_printf.
 */
#ifdef DEBUG
/* When debugging is enabled, these form aliases to useful functions */
#define dbg_printf(...) printf(__VA_ARGS__)
#define dbg_requires(...) assert(__VA_ARGS__)
#define dbg_assert(...) assert(__VA_ARGS__)
#define dbg_ensures(...) assert(__VA_ARGS__)
#else
/* When debugging is disabled, no code gets generated for these */
#define dbg_printf(...)
#define dbg_requires(...)
#define dbg_assert(...)
#define dbg_ensures(...)
#endif

/* Function prototypes */
void block_signals(sigset_t *prev_mask);
void unblock_signals(const sigset_t *prev_mask);
void handle_builtin_command(struct cmdline_tokens *token);
bool parse_bg_fg_argv(char *argv, pid_t *pid, jid_t *jid);
void bg_fg(char **argv, int status);

void print_signal_mask(int n);
void eval(const char *cmdline);

void sigchld_handler(int sig);
void sigtstp_handler(int sig);
void sigint_handler(int sig);
void sigquit_handler(int sig);
void sigcont_handler(int sig);
void cleanup(void);

/**
 * @brief The main function of the shell.
 *
 * Initializes the shell environment, sets up signal handlers,
 * and enters the main read/eval loop.
 *
 * @param argc The number of command line arguments.
 * @param argv The command line arguments.
 * @return int Exit status of the shell.
 */
int main(int argc, char **argv) {
    int c;
    char cmdline[MAXLINE_TSH]; // Cmdline for fgets
    bool emit_prompt = true;   // Emit prompt (default)

    // Redirect stderr to stdout (so that driver will get all output
    // on the pipe connected to stdout)
    if (dup2(STDOUT_FILENO, STDERR_FILENO) < 0) {
        perror("dup2 error");
        exit(1);
    }

    // Parse the command line
    while ((c = getopt(argc, argv, "hvp")) != EOF) {
        switch (c) {
        case 'h': // Prints help message
            usage();
            break;
        case 'v': // Emits additional diagnostic info
            verbose = true;
            break;
        case 'p': // Disables prompt printing
            emit_prompt = false;
            break;
        default:
            usage();
        }
    }

    // Create environment variable
    if (putenv(strdup("MY_ENV=42")) < 0) {
        perror("putenv error");
        exit(1);
    }

    // Set buffering mode of stdout to line buffering.
    // This prevents lines from being printed in the wrong order.
    if (setvbuf(stdout, NULL, _IOLBF, 0) < 0) {
        perror("setvbuf error");
        exit(1);
    }

    // Initialize the job list
    init_job_list();

    // Register a function to clean up the job list on program termination.
    // The function may not run in the case of abnormal termination (e.g. when
    // using exit or terminating due to a signal handler), so in those cases,
    // we trust that the OS will clean up any remaining resources.
    if (atexit(cleanup) < 0) {
        perror("atexit error");
        exit(1);
    }

    // Install the signal handlers
    Signal(SIGINT, sigint_handler);   // Handles Ctrl-C
    Signal(SIGTSTP, sigtstp_handler); // Handles Ctrl-Z
    Signal(SIGCHLD, sigchld_handler); // Handles terminated or stopped child
    Signal(SIGCONT, sigcont_handler); // Handles terminated or stopped child

    Signal(SIGTTIN, SIG_IGN);
    Signal(SIGTTOU, SIG_IGN);

    Signal(SIGQUIT, sigquit_handler);

    // Execute the shell's read/eval loop
    while (true) {
        if (emit_prompt) {
            printf("%s", prompt);

            // We must flush stdout since we are not printing a full line.
            fflush(stdout);
        }

        if ((fgets(cmdline, MAXLINE_TSH, stdin) == NULL) && ferror(stdin)) {
            perror("fgets error");
            exit(1);
        }

        if (feof(stdin)) {
            // End of file (Ctrl-D)
            printf("\n");
            return 0;
        }

        // Remove any trailing newline
        char *newline = strchr(cmdline, '\n');
        if (newline != NULL) {
            *newline = '\0';
        }

        // Evaluate the command line
        eval(cmdline);
    }

    return -1; // control never reaches here
}

// void print_signal_mask(int n) {
//     sigset_t current_mask;
//     if (sigprocmask(SIG_BLOCK, NULL, &current_mask) < 0) {
//         perror("sigprocmask");
//         return;
//     }
//     printf("Current signal mask:\n");
//     for (int sig = 1; sig < NSIG; ++sig) {
//         if (sigismember(&current_mask, sig)) {
//             printf("Signal %d is blocked ", sig);
//         }
//     }
//     printf("\n");
// }

/**
 * @brief Evaluates a command line.
 *
 * Parses the command line, checks if it is a built-in command,
 * and if not, forks a new process to execute it.
 *
 * @param cmdline The command line to evaluate.
 * NOTE: The shell is supposed to be a long-running process, so this function
 *       (and its helpers) should avoid exiting on error.  This is not to say
 *       they shouldn't detect and print (or otherwise handle) errors!
 */
void eval(const char *cmdline) {
    parseline_return parse_result;
    struct cmdline_tokens token;

    // Parse command line
    parse_result = parseline(cmdline, &token);

    if (parse_result == PARSELINE_ERROR || parse_result == PARSELINE_EMPTY) {
        return;
    }

    if (token.builtin != BUILTIN_NONE) {
        handle_builtin_command(&token);
        return;
    }

    pid_t pid;
    sigset_t prev_mask;
    block_signals(&prev_mask);

    if ((pid = fork()) == 0) { // child
        setpgid(0, 0);

        unblock_signals(&prev_mask);

        char *infile = token.infile;
        char *outfile = token.outfile;
        if (infile != NULL) {
            int fd = open(infile, O_RDONLY);
            if (fd == -1) {
                perror(infile);
                exit(-1);
            }
            dup2(fd, STDIN_FILENO);
            close(fd);
        }
        if ((outfile != NULL)) {
            int fd = open(outfile, O_WRONLY | O_CREAT | O_TRUNC, DEF_MODE);
            if (fd == -1) {
                perror(outfile);
                exit(-1);
            }
            dup2(fd, STDOUT_FILENO);
            close(fd);
        }

        int exec_result = execve(token.argv[0], token.argv, environ);
        if (exec_result == -1) {
            switch (errno) {
            case ENOENT:
                sio_printf("%s: No such file or directory\n", token.argv[0]);
                break;
            case EACCES:
                sio_printf("%s: Permission denied\n", token.argv[0]);
                break;
            default:
                sio_printf("%s: Error: execve failed. errno %s\n",
                           token.argv[0], strerror(errno));
                exit(EXIT_FAILURE);
                break;
            }
        }
    } else { // parent
        add_job(pid, parse_result == PARSELINE_BG ? BG : FG, cmdline);
        jid_t jid = job_from_pid(pid);

        if (parse_result == PARSELINE_BG) {
            // bg
            sio_printf("[%d] (%d) %s \n", jid, pid, cmdline);
        } else {
            // fg
            while (fg_job() != 0) {
                sigsuspend(&prev_mask);
            }
        }
        unblock_signals(&prev_mask);
    }
}

/**
 * @brief Blocks signals for critical sections.
 *
 * Adds SIGCHLD, SIGINT, and SIGTSTP to the signal mask.
 *
 * @param prev_mask The previous signal mask.
 */
void block_signals(sigset_t *prev_mask) {
    // printf("%d block_signals\n", getppid());
    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, SIGCHLD);
    sigaddset(&mask, SIGINT);
    sigaddset(&mask, SIGTSTP);
    sigprocmask(SIG_BLOCK, &mask, prev_mask);

    // for (int sig = 1; sig < NSIG; ++sig) {
    //     if (sigismember(prev_mask, sig)) {
    //         printf("  Signal %d in prev_mask ", sig);
    //     }
    // }
    // printf("\n");
}

/**
 * @brief Unblocks signals after critical sections.
 *
 * Restores the previous signal mask.
 *
 * @param prev_mask The previous signal mask.
 */
void unblock_signals(const sigset_t *prev_mask) {
    // printf("%d unblock_signals\n", getppid());
    sigprocmask(SIG_SETMASK, prev_mask, NULL);
}

/**
 * @brief Handles built-in commands.
 *
 * Executes built-in commands such as 'quit', 'jobs', 'bg', and 'fg'.
 *
 * @param token The command line tokens.
 */
void handle_builtin_command(struct cmdline_tokens *token) {
    if (token->builtin == BUILTIN_QUIT) {
        exit(0);
    } else if (token->builtin == BUILTIN_JOBS) {
        sigset_t prev_mask;
        block_signals(&prev_mask);

        char *outfile = token->outfile;
        if ((outfile != NULL)) {
            int fd = open(outfile, O_WRONLY | O_CREAT | O_TRUNC, DEF_MODE);
            if (fd == -1) {
                perror(outfile);
                exit(-1);
            }
            list_jobs(fd);
            close(fd);
        } else {
            list_jobs(STDOUT_FILENO);
        }
        unblock_signals(&prev_mask);
    } else if (token->builtin == BUILTIN_BG) {
        bg_fg(token->argv, BG);
    } else if (token->builtin == BUILTIN_FG) {
        bg_fg(token->argv, FG);
    }
}

/**
 * @brief Parses arguments for bg/fg commands.
 *
 * Parses the PID or job ID from the arguments and validates them.
 *
 * @param argv The argument string.
 * @param pid The process ID.
 * @param jid The job ID.
 * @return bool True if parsing is successful, false otherwise.
 */
bool parse_bg_fg_argv(char *argv, pid_t *pid, jid_t *jid) {
    if (argv == NULL) { // Checks if it has second argument
        printf("%s command requires PID or %%jobid argument\n", argv);
        return false;
    } else if (argv[0] == '%') {
        if ((*jid = atoi(&argv[1])) == 0 || !job_exists(*jid) ||
            (*pid = job_get_pid(*jid)) == 0) {
            printf("%s: No such job\n", argv);
            return false;
        }
    } else if (isdigit(argv[0])) {
        if ((*pid = atoi(argv)) == 0 || (*jid = job_from_pid(*pid)) == 0 ||
            !job_exists(*jid)) {
            printf("%s: No such process\n", argv);
            return false;
        }
    } else {
        printf("%s: argument must be a PID or %%jobid\n", argv);
        return false;
    }
    return true;
}

/**
 * @brief Handles background and foreground jobs.
 *
 * Changes the state of jobs to background or foreground and sends SIGCONT to
 * them.
 *
 * @param argv The command line arguments.
 * @param status The desired job status (BG or FG).
 */
void bg_fg(char **argv, int status) {
    sigset_t prev_mask;
    block_signals(&prev_mask);

    jid_t new_jid = 0;
    pid_t new_pid = 0;

    if (!parse_bg_fg_argv(argv[1], &new_pid, &new_jid)) {
        return;
    }

    kill(-new_pid, SIGCONT);

    // printf("after kill\n");

    job_set_state(new_jid, status == BG ? BG : FG);

    if (status == BG) {
        sio_printf("[%d] (%d) %s \n", new_jid, new_pid,
                   job_get_cmdline(new_jid));
    } else if (status == FG) {
        // suspend the process before receving signals
        while (fg_job() != 0) {
            sigset_t empty_mask;
            sigemptyset(&empty_mask);
            sigsuspend(&empty_mask);
        }
    }
    unblock_signals(&prev_mask);
}

/*****************
 * Signal handlers
 *****************/

/**
 * @brief Handles SIGCHLD signal.
 *
 * Cleans up terminated or stopped child processes.
 *
 * @param sig The signal number.
 */
void sigchld_handler(int sig) {
    int status;
    pid_t pid;
    int saved_errno = errno;

    sigset_t prev_mask;
    block_signals(&prev_mask);

    while ((pid = waitpid(-1, &status, WNOHANG | WUNTRACED | WCONTINUED)) > 0) {
        jid_t job = job_from_pid(pid);
        if (WIFSTOPPED(status)) {
            job_set_state(job, ST);
            sio_printf("Job [%d] (%d) stopped by signal %d \n", job, pid,
                       WSTOPSIG(status));
        } else if (WIFSIGNALED(status)) {
            sio_printf("Job [%d] (%d) terminated by signal %d \n", job, pid,
                       WTERMSIG(status));
            delete_job(job);
        } else if (WIFCONTINUED(status)) {

        } else {
            delete_job(job);
        }
    }
    unblock_signals(&prev_mask);
    errno = saved_errno;
    return;
}

/**
 * @brief Handles SIGINT signal.
 *
 * Sends SIGINT to the foreground job.
 *
 * @param sig The signal number.
 */
void sigint_handler(int sig) {
    int saved_errno = errno;

    sigset_t prev_mask;
    block_signals(&prev_mask);

    jid_t fg_jobs = fg_job();
    if (fg_jobs != 0) {
        pid_t fg_pids = job_get_pid(fg_jobs);
        kill(-fg_pids, sig);
    }

    unblock_signals(&prev_mask);

    errno = saved_errno;
}

/**
 * @brief Handles SIGTSTP signal.
 *
 * Sends SIGTSTP to the foreground job.
 *
 * @param sig The signal number.
 */
void sigtstp_handler(int sig) {
    int saved_errno = errno;

    sigset_t prev_mask;
    block_signals(&prev_mask);

    jid_t fg_jobs = fg_job();
    if (fg_jobs != 0) {
        pid_t fg_pids = job_get_pid(fg_jobs);
        kill(-fg_pids, sig);
    }

    unblock_signals(&prev_mask);

    errno = saved_errno;
}

/**
 * @brief Handles SIGCONT signal.
 *
 * Currently does nothing.
 *
 * @param sig The signal number.
 */
void sigcont_handler(int sig) {
    printf("sigcont_handler\n");
}

/**
 * @brief Attempt to clean up global resources when the program exits.
 *
 * In particular, the job list must be freed at this time, since it may
 * contain leftover buffers from existing or even deleted jobs.
 */
void cleanup(void) {
    // Signals handlers need to be removed before destroying the joblist
    Signal(SIGINT, SIG_DFL);  // Handles Ctrl-C
    Signal(SIGTSTP, SIG_DFL); // Handles Ctrl-Z
    Signal(SIGCHLD, SIG_DFL); // Handles terminated or stopped child

    destroy_job_list();
}