#include "fractal.h"
#include <complex>

FractalGenerator::FractalGenerator(int width, int height, int maxIterations) : width(width), height(height), maxIterations(maxIterations) {}

Image FractalGenerator::generateMandelbrot() {
    Image image(width, height);
    double minX = -2.0;
    double maxX = 1.0;
    double minY = -1.5;
    double maxY = 1.5;

    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            double cReal = minX + (maxX - minX) * x / width;
            double cImag = minY + (maxY - minY) * y / height;
            std::complex<double> c(cReal, cImag);
            std::complex<double> z(0, 0);
            int iterations = 0;
            while (abs(z) < escapeRadius && iterations < maxIterations) {
                z = z * z + c;
                iterations++;
            }
            if (iterations == maxIterations) {
                image.setPixel(x, y, 0, 0, 0); // Black for points inside
            } else {
                int color = iterations * 255 / maxIterations;
                image.setPixel(x, y, color, color, color);
            }
        }
    }
    return image;
}