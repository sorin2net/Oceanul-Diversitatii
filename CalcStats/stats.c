#include <stdio.h>
#include "stats.h"
#include <limits.h>


double calculateAverage(double numbers[], int count) {
  double sum = 0;
  for (int i = 0; i < count; i++) {
    sum += numbers[i];
  }
  return sum / count;
}

double findMinimum(double numbers[], int count) {
  double min = numbers[0];
  for (int i = 1; i < count; i++) {
    if (numbers[i] < min) {
      min = numbers[i];
    }
  }
  return min;
}

double findMaximum(double numbers[], int count) {
  double max = numbers[0];
  for (int i = 1; i < count; i++) {
    if (numbers[i] > max) {
      max = numbers[i];
    }
  }
  return max;
}