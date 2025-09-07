#ifndef FRACTAL_H
#define FRACTAL_H

#include <stdio.h>
#include <stdlib.h>
#include <complex.h>

typedef struct {
    double complex c;
    int iterations;
} MandelbrotData;

typedef struct {
    double minX, maxX, minY, maxY;
    int width, height;
    double scale;
} ImageParameters;

typedef struct {
    int width;
    int height;
    unsigned char* data;
} Image;


MandelbrotData calculateMandelbrot(double complex c, int maxIterations);
Image generateMandelbrotImage(ImageParameters params);
void saveImagePPM(Image img, const char* filename);
ImageParameters createImageParameters(int width, int height, double minX, double maxX, double minY, double maxY);
Image createImage(int width, int height);
void freeImage(Image img);
void printImageInfo(Image img);

#endif