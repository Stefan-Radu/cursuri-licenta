#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>


const size_t MAX_FILE_NAME_LENGTH = 64;
const size_t MAX_BYTES_TO_READ = 4096;

void print_stdout(const char* what) {

  /* size_t no_bytes = 0; */
  /* while (what[no_bytes] != '\0') { */
  /*   ++ no_bytes; */
  /* } */

  ssize_t no_bytes = strlen(what);
  int resp = write(STDOUT_FILENO, what, no_bytes);

  if (resp == -1) {
    printf("writing exited with and error: %d\n", errno);
  }
  else if (resp != no_bytes) {
    printf("could not write the whole buffer\n");
  }
}

int open_files(int* fd_r, int* fd_w, const char* if_name, const char* of_name) {

  printf("Opening input file %s\n", if_name);
  *fd_r = open(if_name, O_RDONLY);

  if (*fd_r == -1) {
    printf("Error opening input file\n");
    printf("Errno: %d", errno);
    return errno;
  }
  else {
    printf("Input file opened with descriptor %d\n\n", *fd_r);
  }

  printf("Opening output file %s\n", of_name);
  *fd_w = open(of_name, O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

  if (*fd_w == -1) {
    printf("Error opening output file\n");
    printf("Errno: %d", errno);
    return errno;
  }
  else {
    printf("Output file opened with descriptor %d\n\n", *fd_w);
  }

  return 0;
}


int main(int argc, char** argv) {

  // EX 1: print "hello world" to stdout
  print_stdout("hello world\n\n");


  // EX 2: copy from file 1 to file 2

  // open files for read / write
  int fd_read_from = -1;
  int fd_write_to = -1;

  if (argc == 3) {
    printf("Using main function arguments\n\n");
    int ret = open_files(&fd_read_from, &fd_write_to, argv[1], argv[2]);
    if (ret) return ret;
  }
  else {
    printf("Reading file names from stdin\n\n");

    char *if_name = malloc(MAX_FILE_NAME_LENGTH * sizeof(*if_name));
    char *of_name = malloc(MAX_FILE_NAME_LENGTH * sizeof(*of_name));

    printf("Input file name: "); fflush(STDIN_FILENO);
    int ret1 = read(STDIN_FILENO, if_name, MAX_FILE_NAME_LENGTH);
    printf("Output file name: "); fflush(STDIN_FILENO);
    int ret2 = read(STDIN_FILENO, of_name, MAX_FILE_NAME_LENGTH);

    // get rid of \n from the end
    if (if_name[strlen(if_name) - 1] == '\n') {
      if_name[strlen(if_name) - 1] = '\0';
    }

    if (of_name[strlen(of_name) - 1] == '\n') {
      of_name[strlen(of_name) - 1] = '\0';
    }
   
    if (ret1 < 0 || ret2 < 0) {
      printf("Error while reading from stdin");
    }

    int ret = open_files(&fd_read_from, &fd_write_to, if_name, of_name);
    if (ret) return ret;

    free(if_name);
    free(of_name);
  }

  // read and write to file

  char* buff = malloc(MAX_BYTES_TO_READ * sizeof(*buff));

  int how_much_read = read(fd_read_from, buff, MAX_BYTES_TO_READ);
  while (how_much_read > 0) {

    printf("R %d\n", how_much_read);
    int how_much_written = write(fd_write_to, buff, how_much_read);
    int total_written = how_much_written;

    while (0 < how_much_written && how_much_written < how_much_read) {
      printf("W %d\n", how_much_written);
      how_much_read -= how_much_written;
      how_much_written = write(fd_write_to, buff + total_written, how_much_read);
      total_written += how_much_written;
    }

    if (how_much_written == -1) {
      printf("Writing ended with an error\n");
      printf("Errno: %d\n\n", errno); 
      return errno;
    }

    how_much_read = read(fd_read_from, buff, MAX_BYTES_TO_READ);
  }

  free(buff);

  if (how_much_read == -1) {
    printf("Reading ended with an error\n");
    printf("Errno: %d\n\n", errno); 
    return errno;
  }

  return 0;
}
