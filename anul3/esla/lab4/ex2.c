#include <stdio.h>
#include <string.h>
#include <unistd.h>

int func(char * argv){
	char buffer[32];
	strcpy(buffer, argv);
	return 0;
}

int main(int argc, char * argv[]){
	func(argv[1]);
	return 0;
}
