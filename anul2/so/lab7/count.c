#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

#define MAX_RESOURCES 10

const int THREAD_COUNT = 5;

pthread_mutex_t mtx;
int available_resources = MAX_RESOURCES;

int decrease_count(int count) {
  pthread_mutex_lock(&mtx);
  if (available_resources < count) {
    printf("Could not get %d resources. Abording\n", count);
    pthread_mutex_unlock(&mtx);
    return -1;
  }

  available_resources -= count;
  printf("Got %d resources, %d remaining\n", count, available_resources);
  pthread_mutex_unlock(&mtx);
  return 0;
}

int increase_count(int count) {
  pthread_mutex_lock(&mtx);
  available_resources += count;
  printf("Released %d resources, %d remaining\n", count, available_resources);
  pthread_mutex_unlock(&mtx);
  return 0;
}

void *use_resources(void *attr) {
  int *how_many = attr;
  if (decrease_count(*how_many) != -1) {
    increase_count(*how_many);
  }
  free(how_many);
  return NULL;
}

int main () {

  printf("MAX_RESOURCES = %d\n", MAX_RESOURCES);

  srand((unsigned) time(NULL));
  if (pthread_mutex_init(&mtx, NULL)) {
    perror("Failed to init mutex");
    return errno;
  }

  pthread_t thr[THREAD_COUNT];
  for (int i = 0; i < THREAD_COUNT; ++ i) {
    int *how_many = calloc(1, sizeof(*how_many));
    *how_many = rand() % MAX_RESOURCES + 1;
    if (pthread_create(&thr[i], NULL, use_resources, how_many)) {
      perror("Thread creation failed\n");
      return errno;
    }
  }

  for (int i = 0; i < THREAD_COUNT; ++ i) {
    if (pthread_join(thr[i], NULL)) {
      perror("Thread join failed\n");
      return errno;
    }
  }

  pthread_mutex_destroy(&mtx);
  return 0;
}
