#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int main () {
  // new process
  pid_t pid = fork();

  if (pid == -1) {
    return errno;
  }

  if (pid == 0) {
    // in child
    char *argv[] = {"ls", "-la", NULL};
    execve("/usr/bin/ls", argv, NULL);
  }
  else {
    // in parent
    printf("My: %d\nChild: %d\n", getpid(), pid);
  }
}
