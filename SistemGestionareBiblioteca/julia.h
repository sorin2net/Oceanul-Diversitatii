#ifndef JULIA_H
#define JULIA_H

#include "fractal.h"

typedef struct {
    double complex c;
    ImageParameters params;
} JuliaParameters;

Image generateJuliaImage(JuliaParameters params);

#endif