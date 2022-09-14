#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>

struct procij_arg {
  int i, j, lim;
  int ** mat1, **mat2;
};

void *procij(void *arg) {

  struct procij_arg *args = (struct procij_arg *) arg;

  int *ret = calloc(1, sizeof(*ret));
  for (int it = 0; it < args->lim; ++ it) {
    *ret += args->mat1[args->i][it] * args->mat2[it][args->j];
  }

  return (void *) ret;
}

int main() {

  // initializare si citire

  FILE* input = fopen("input", "r");
  int n, m, p;

  fscanf(input, "%d %d %d\n", &n, &m, &p);

  int **mat1 = malloc(n * sizeof(*mat1));
  int **mat2 = malloc(m * sizeof(*mat2));

  printf("Matrix A:\n");
  for (int i = 0; i < n; ++ i) {
    mat1[i] = malloc(m * sizeof(*mat1[i]));
    for (int j = 0; j < m; ++ j) {
      fscanf(input, "%d", &mat1[i][j]);
      printf("%d ", mat1[i][j]);
    }
    printf("\n");
  }
  puts("");
  
  printf("Matrix B:\n");
  for (int i = 0; i < m; ++ i) {
    mat2[i] = malloc(p * sizeof(*mat2[i]));
    for (int j = 0; j < p; ++ j) {
      fscanf(input, "%d", &mat2[i][j]);
      printf("%d ", mat2[i][j]);
    }
    printf("\n");
  }

  fclose(input);
  puts("");

  // ====================================================================

  pthread_t thr[n * p];
  struct procij_arg args[n * p];

  for (int i = 0; i < n; ++ i) {
    for (int j = 0; j < p; ++ j) {
      args[i * p + j] = (struct procij_arg) {i, j, m, mat1, mat2};
      if (pthread_create(&thr[i * p + j], NULL, procij, &args[i * p + j])) {
        perror("Thread creation failed\n");
        return errno;
      }
      else {
        printf("created thread w/id %d\n", i * p + j);
      }
    }
  }
  puts("");

  int *res[n * p];
  for (int i = 0; i < n * p; ++ i) {
    if (pthread_join(thr[i], (void *) &res[i])) {
      perror("Thread join failed\n");
      return errno;
    }
    else {
      printf("joined thread w/id %d\n", i);
    }
  }

  puts("\nMatrix Product:");
  for (int i = 0; i < n; ++ i) {
    for (int j = 0; j < p; ++ j) {
      printf("%d ", *res[i * p + j]);
    }
    printf("\n");
  }

  for (int i = 0; i < n; ++ i) free(mat1[i]);
  free(mat1);
  for (int i = 0; i < m; ++ i) free(mat2[i]);
  free(mat2);
}
