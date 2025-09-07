#ifndef CALCULATOR_H
#define CALCULATOR_H

#include "fraction.h"

typedef enum {ADD, SUBTRACT, MULTIPLY, DIVIDE, COMPARE} Operation;

Fraction calculate(Fraction f1, Fraction f2, Operation op);

#endif