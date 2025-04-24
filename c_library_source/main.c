#include<stdio.h>
#include "mul.h"
int main(void)
{
	double ar[1];
	mul(ar, 2,5);
  printf("Inside main %f \n", ar[0]);
  return 0;
}
