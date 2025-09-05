#include "fractal.h"
#include <fstream>

Fractal::Fractal(int width, int height) : width(width), height(height), image(height, std::vector<int>(width)) {}

void Fractal::generateMandelbrot() {
  for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
      Complex c(-2.0 + x * 3.0 / width, -1.5 + y * 3.0 / height);
      Complex z(0, 0);
      int iterations = 0;
      while (z.absSq() < 4 && iterations < 255) {
        z = z * z + c;
        iterations++;
      }
      image[y][x] = iterations;
    }
  }
}


void Fractal::saveImage(const std::string& filename) {
  std::ofstream file(filename);
  file << "P3\n" << width << " " << height << "\n255\n";
  for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
      file << image[y][x] << " " << image[y][x] << " " << image[y][x] << "\n";
    }
  }
  file.close();
}