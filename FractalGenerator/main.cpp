#include <iostream>
#include "fractal.h"
#include "image.h"

int main() {
    FractalGenerator fractalGen(800, 600, 100);
    Image image = fractalGen.generateMandelbrot();
    image.save("mandelbrot.ppm");
    return 0;
}