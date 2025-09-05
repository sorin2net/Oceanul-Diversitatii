#include "complex.h"
#include <cmath>

double Complex::absSq() const {
  return re * re + im * im;
}

Complex Complex::operator*(const Complex& other) const {
  return Complex(re * other.re - im * other.im, re * other.im + im * other.re);
}