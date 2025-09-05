#include <iostream>
#include "fractal.h"
#include "complex.h"

int main() {
  Fractal fractal(500, 500);
  fractal.generateMandelbrot();
  fractal.saveImage("mandelbrot.ppm");
  return 0;
}