#include <stdio.h>
#include "input.h"

int readNumbers(double numbers[]) {
  int count = 0;
  double num;
  printf("Enter numbers (enter a non-numeric value to finish):\n");
  while (scanf("%lf", &num) == 1) {
    numbers[count++] = num;
  }
  return count;
}