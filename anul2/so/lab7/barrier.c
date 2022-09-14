#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <semaphore.h>

#define NTHRS 5

sem_t sem;
pthread_mutex_t mtx;
pthread_t *thr;
int reached_cnt = 0;

int init(int n) {
  if (pthread_mutex_init(&mtx, NULL)) {
    perror("Failed to init mutex\n");
    return errno;
  }

  if (sem_init(&sem, 0, 0)) {
    perror("Failed to init semaphore\n");
    return errno;
  }

  thr = malloc(n * sizeof(*thr));
  return 0;
}

int barrier_point() {

  pthread_mutex_lock(&mtx);
  ++ reached_cnt;
  pthread_mutex_unlock(&mtx);

  if (reached_cnt < NTHRS) {
    if (sem_wait(&sem)) {
      perror("Failed on wait\n");
      return errno;
    }
  }

  if (sem_post(&sem)) {
    perror("Failed on post\n");
    return errno;
  }

  return 0;
}

void *tfun(void *v) {

  int *tid = (int *) v;

  printf("%d reached the barrier\n", *tid);
  barrier_point();
  printf("%d passed the barrier\n", *tid);

  free(tid);
  return NULL;
}

int main() {
  
  init(NTHRS);
  printf("NTHRS = %d\n", NTHRS);

  for (int i = 0; i < NTHRS; ++ i) {
    int *index = malloc(sizeof(*index));
    *index = i;
    if (pthread_create(&thr[i], NULL, tfun, index)) {
      perror("Thread creation failed\n");
      return errno;
    }
  }

  for (int i = 0; i < NTHRS; ++ i) {
    if (pthread_join(thr[i], NULL)) {
      perror("Thread join failed\n");
      return errno;
    }
  }

  free(thr);
  sem_destroy(&sem);
  pthread_mutex_destroy(&mtx);
}
