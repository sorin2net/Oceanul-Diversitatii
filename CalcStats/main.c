#include <stdio.h>
#include "input.h"
#include "stats.h"

int main() {
  double numbers[100];
  int count = readNumbers(numbers);
  if (count > 0) {
    double avg = calculateAverage(numbers, count);
    double min = findMinimum(numbers, count);
    double max = findMaximum(numbers, count);
    printf("Average: %.2lf\n", avg);
    printf("Minimum: %.2lf\n", min);
    printf("Maximum: %.2lf\n", max);
  } else {
    printf("No numbers entered.\n");
  }
  return 0;
}