#include <stdio.h>

int main()
{
  int admin = 0;
  char buffer[10];
  gets (buffer);
  if (admin)
  {
    printf("%d\n", admin);
    printf ("You are admin.\n");
  }
  else
  {
    printf ("You are not admin");
  }

  return 0;
}
