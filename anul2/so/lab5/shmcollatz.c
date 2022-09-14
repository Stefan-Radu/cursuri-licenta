#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>


void end_w_error(const char *shm_name, const char* msg) {
  perror(msg);
  shm_unlink(shm_name);
  exit(errno);
}

int main (int argc, char *argv[]) {

  printf("started parent w/pid: %d\n\n", getpid());

  size_t shm_page_size = getpagesize();
  const char * shm_name = "shared_mem";

  int shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
  if (shm_fd < 0) {
    end_w_error(shm_name, "could not open FD");
  }

  if (ftruncate(shm_fd, argc * shm_page_size) == -1) {
    end_w_error(shm_name, "could not truncate");
  }

  for (int i = 1; i < argc; ++ i) {
    pid_t pid = fork();
    if (pid == -1) {
      end_w_error(shm_name, "process could not be forked");
    }

    if (pid == 0) {
      // in child

      int *shm_ptr = mmap(0, shm_page_size, PROT_WRITE, MAP_SHARED,
          shm_fd, (i - 1) * shm_page_size);

      if(shm_ptr == MAP_FAILED) {
        perror("mmap in child failed");
        exit(-1);
      }

      int n = strtol(argv[i], NULL, 10);
      printf("started child w/pid: %d | parent w/pid: %d | n: %d\n", 
          getpid(), getppid(), n);

      int offset = 0;
      while (n != 1) {
        shm_ptr[offset ++] = n;
        if (n & 1) n = n * 3 + 1; 
        else n = n / 2;
      }
      shm_ptr[offset ++] = n;

      if (munmap(shm_ptr, shm_page_size) == -1) {
        perror("munmap in child failed");
        exit(-1);
      }

      printf("ended child w/pid: %d\n", getpid());
      return 0;
    }
    else {
      if (wait(NULL) == -1) {
        end_w_error(shm_name, "error in chld");
      }
    }
  }

  printf("\nall children finished successfully\n\n");

  int *shm_ptr = mmap(0, argc * shm_page_size, PROT_READ, MAP_SHARED,
      shm_fd, 0);

  for (int i = 1; i < argc; ++ i) {

    int offset = (i - 1) * shm_page_size / sizeof(int);
    printf("%d: ", shm_ptr[offset]);

    while (1) {
      printf("%d ", shm_ptr[offset]);
      if (shm_ptr[offset] == 1) {
        printf(".\n");
        break;
      }
      ++ offset;
    }
  }
  printf("\n");

  if (munmap(shm_ptr, shm_page_size) == -1) {
    perror("munmap failed in parent");
    return errno;
  }
  shm_unlink(shm_name);

  printf("parent w/pid: %d finished\n", getpid());
}
