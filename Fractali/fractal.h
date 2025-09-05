#ifndef FRACTAL_H
#define FRACTAL_H

#include "complex.h"
#include <vector>

class Fractal {
public:
  Fractal(int width, int height);
  void generateMandelbrot();
  void saveImage(const std::string& filename);
private:
  int width;
  int height;
  std::vector<std::vector<int>> image;
};

#endif