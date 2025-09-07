#ifndef RENDERER_H
#define RENDERER_H

#include "mandelbrot.h"
#include "julia.h"
#include "complex.h"

void render_fractal(int width, int height, int max_iter, char* filename, int (*fractal_func)(Complex,int), Complex param);


#endif