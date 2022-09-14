#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>


void *sttrev(void *arg) {
  char *str = (char *) arg;
  int len = strlen(str);

  char *rev = malloc(len * sizeof(*rev));
  for (int i = 0; i < len; ++ i) {
    rev[i] = str[len - i - 1];
  }

  return rev;
}


int main(int argc, char **argv) {

  if (argc != 2) {
    printf("%d arguments required. %d provided\n", 1, argc - 1);
    return -1;
  }


  pthread_t thr;
  if (pthread_create(&thr, NULL, sttrev, argv[1])) {
    perror("Thread creation failed\n");
    return errno;
  }

  char *res;
  if (pthread_join(thr, (void *) &res)) {
    perror("Thread join failed\n");
    return errno;
  }

  printf("reversed '%s' to '%s'\n", argv[1], res);
  free(res);

  return 0;
}
