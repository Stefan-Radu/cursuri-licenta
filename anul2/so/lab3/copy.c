#include <stdlib.h>
#include <stdio.h>
#include <string.h>


int main() {
	char * from = "hello";
	char * to = malloc(100);

	int ret = syscall(332, from, to, strlen(from));
	printf("%s\n%d\n", to, ret);

	free(to);
	return ret;
}
