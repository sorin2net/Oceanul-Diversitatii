#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "renderer.h"
#include "ppm.h"


void render_fractal(int width, int height, int max_iter, char* filename, int (*fractal_func)(Complex,int), Complex param){

    PPMImage* image = ppm_create(width, height);
    double x_min = -2.0;
    double x_max = 1.0;
    double y_min = -1.5;
    double y_max = 1.5;

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            double x = x_min + (x_max - x_min) * j / width;
            double y = y_min + (y_max - y_min) * i / height;
            Complex c = {x,y};
            int iterations;

            if(fractal_func == mandelbrot){
                iterations = fractal_func(c, max_iter);
            } else {
                iterations = fractal_func({0,0},param, max_iter);
            }

            uint8_t r = (iterations % 256);
            uint8_t g = ((iterations * 3) % 256);
            uint8_t b = ((iterations * 7) % 256);
            ppm_set_pixel(image, j, i, r, g, b);
        }
    }
    ppm_save(image, filename);
    ppm_destroy(image);

}