#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>


int main (int argc, char *argv[]) {

  if (argc != 2) {
    fprintf(stderr, "one argument required");
    exit(-1);
  }

  pid_t pid = fork();
  if (pid == -1) {
    perror("couldn't fork");
    exit(errno);
  }

  if (pid == 0) {
    // in child
    printf("Child with pid %d started\n\n", getpid());

    int n = strtol(argv[1], NULL, 10);
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
    printf("Child with pid %d finished\n", getpid());
    exit(0);
  }
  else {
    if (wait(NULL) == -1) {
      perror("error in child");
      exit(errno);
    }
  }

  printf("parent and child finished successfully");
}
