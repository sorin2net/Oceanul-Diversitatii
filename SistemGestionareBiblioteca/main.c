#include <stdio.h>
#include "fractal.h"
#include "julia.h"

int main() {
    ImageParameters mandelbrotParams = createImageParameters(512, 512, -2.0, 1.0, -1.5, 1.5);
    Image mandelbrotImage = generateMandelbrotImage(mandelbrotParams);
    saveImagePPM(mandelbrotImage, "mandelbrot.ppm");
    printImageInfo(mandelbrotImage);
    freeImage(mandelbrotImage);


    JuliaParameters juliaParams = {0.285 + 0.01*I, createImageParameters(512,512,-1.5,1.5,-1.5,1.5)};
    Image juliaImage = generateJuliaImage(juliaParams);
    saveImagePPM(juliaImage, "julia.ppm");
    printImageInfo(juliaImage);
    freeImage(juliaImage);

    return 0;
}