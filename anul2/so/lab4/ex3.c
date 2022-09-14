#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/wait.h>

int main (int argc, char *argv[]) {

  printf("parent w/pid: %d started\n\n", getpid());

  for (int i = 1; i < argc; ++ i) {
    pid_t pid = fork();
    if (pid == -1) {
      perror("couldn't fork");
      return errno;
    }

    if (pid == 0) {
      // in child
      int n = strtol(argv[i], NULL, 10);
      printf("started child w/pid: %d | parent w/pid: %d | n: %d\n", 
          getpid(), getppid(), n);

      printf("%d: ", n);
      while (n != 1) {
        printf("%d ", n);
        if (n & 1) {
          n = n * 3 + 1;
        }
        else {
          n = n / 2;
        }
      }
      printf("1\n\n");
      exit(0);
    }
  }


  for (int i = 1; i < argc; ++ i) {
    int child_pid = wait(NULL);
    if (child_pid == -1) {
      perror("error in child");
      exit(errno);
    }
    printf("finished child w/pid: %d\n\n", child_pid);
  }

  printf("finished all children\n");
  printf("finished parent w/pid:%d", getpid());
}
