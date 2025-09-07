#ifndef FRACTION_H
#define FRACTION_H

#include <stdio.h>
#include <stdlib.h>

typedef struct {
    long long num;
    long long den;
} Fraction;

Fraction createFraction(long long num, long long den);
Fraction simplifyFraction(Fraction f);
Fraction addFractions(Fraction f1, Fraction f2);
Fraction subtractFractions(Fraction f1, Fraction f2);
Fraction multiplyFractions(Fraction f1, Fraction f2);
Fraction divideFractions(Fraction f1, Fraction f2);
int compareFractions(Fraction f1, Fraction f2);
void printFraction(Fraction f);
long long gcd(long long a, long long b);
long long lcm(long long a, long long b);


#endif