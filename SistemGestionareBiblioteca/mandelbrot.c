#include "mandelbrot.h"
#include "complex.h"

int mandelbrot(Complex c, int max_iter) {
    Complex z = {0.0, 0.0};
    int i = 0;
    while (complex_abs(z) <= 2.0 && i < max_iter) {
        z = complex_add(complex_pow(z, 2), c);
        i++;
    }
    return i;
}