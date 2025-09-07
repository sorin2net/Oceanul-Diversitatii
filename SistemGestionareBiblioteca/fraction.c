#include "fraction.h"

Fraction createFraction(long long num, long long den) {
    if (den == 0) {
        fprintf(stderr, "Denominator cannot be zero.\n");
        exit(1);
    }
    Fraction f = {num, den};
    return f;
}

Fraction simplifyFraction(Fraction f) {
    long long common = gcd(abs(f.num), abs(f.den));
    f.num /= common;
    f.den /= common;
    if (f.den < 0) {
        f.num *= -1;
        f.den *= -1;
    }
    return f;
}

Fraction addFractions(Fraction f1, Fraction f2) {
    long long num = f1.num * f2.den + f2.num * f1.den;
    long long den = f1.den * f2.den;
    return simplifyFraction(createFraction(num, den));
}

Fraction subtractFractions(Fraction f1, Fraction f2) {
    long long num = f1.num * f2.den - f2.num * f1.den;
    long long den = f1.den * f2.den;
    return simplifyFraction(createFraction(num, den));
}

Fraction multiplyFractions(Fraction f1, Fraction f2) {
    long long num = f1.num * f2.num;
    long long den = f1.den * f2.den;
    return simplifyFraction(createFraction(num, den));
}

Fraction divideFractions(Fraction f1, Fraction f2) {
    if (f2.num == 0) {
        fprintf(stderr, "Cannot divide by zero.\n");
        exit(1);
    }
    long long num = f1.num * f2.den;
    long long den = f1.den * f2.num;
    return simplifyFraction(createFraction(num, den));
}

int compareFractions(Fraction f1, Fraction f2) {
    long long num1 = f1.num * f2.den;
    long long num2 = f2.num * f1.den;
    if (num1 > num2) return 1;
    if (num1 < num2) return -1;
    return 0;
}

void printFraction(Fraction f) {
    printf("%lld/%lld\n", f.num, f.den);
}

long long gcd(long long a, long long b) {
    if (b == 0) return a;
    return gcd(b, a % b);
}

long long lcm(long long a, long long b) {
    return (a * b) / gcd(a, b);
}