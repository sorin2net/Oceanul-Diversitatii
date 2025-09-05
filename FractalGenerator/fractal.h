#ifndef FRACTAL_H
#define FRACTAL_H

#include "image.h"

class FractalGenerator {
public:
    FractalGenerator(int width, int height, int maxIterations);
    Image generateMandelbrot();

private:
    int width;
    int height;
    int maxIterations;
    double escapeRadius = 2.0;
};

#endif