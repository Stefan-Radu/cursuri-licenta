#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int good_func(char * buffer)
{
    printf ("%s\n", buffer);
    return 0;
}

int bad_func(char * buffer)
{
    system (buffer);
    return 0;
}

typedef int (*MYFUNC)(char * buffer);

int main(int argc, char * argv[])
{
    char buffer1[12];
    volatile MYFUNC fct;
    char buffer2[12];
    fct = good_func;
    printf("a%sa\n", argv[2]);
    strncpy(buffer1, argv[1], strlen(argv[1]));
    strncpy(buffer2, argv[2], strlen(argv[2]));

    printf("%s\n", buffer1);
    printf("%s\n", buffer2);
    printf("%p %p\n", fct, bad_func);

    fct(buffer1);
    fct(buffer2);
    return 0;
}

