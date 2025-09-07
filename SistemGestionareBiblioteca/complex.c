#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "complex.h"

Complex complex_new(double re, double im) {
    Complex c;
    c.re = re;
    c.im = im;
    return c;
}

Complex complex_add(Complex a, Complex b) {
    Complex c;
    c.re = a.re + b.re;
    c.im = a.im + b.im;
    return c;
}

Complex complex_sub(Complex a, Complex b) {
    Complex c;
    c.re = a.re - b.re;
    c.im = a.im - b.im;
    return c;
}

Complex complex_mul(Complex a, Complex b) {
    Complex c;
    c.re = a.re * b.re - a.im * b.im;
    c.im = a.re * b.im + a.im * b.re;
    return c;
}

Complex complex_div(Complex a, Complex b) {
    Complex c;
    double den = b.re * b.re + b.im * b.im;
    c.re = (a.re * b.re + a.im * b.im) / den;
    c.im = (a.im * b.re - a.re * b.im) / den;
    return c;
}

double complex_abs(Complex a) {
    return sqrt(a.re * a.re + a.im * a.im);
}

Complex complex_pow(Complex a, int n) {
    Complex res = complex_new(1,0);
    for(int i = 0; i < n; i++) {
        res = complex_mul(res, a);
    }
    return res;
}

Complex complex_exp(Complex a){
    Complex res;
    res.re = exp(a.re) * cos(a.im);
    res.im = exp(a.re) * sin(a.im);
    return res;
}

Complex complex_ln(Complex a){
    Complex res;
    res.re = 0.5 * log(a.re * a.re + a.im * a.im);
    res.im = atan2(a.im, a.re);
    return res;
}


void complex_print(Complex a) {
    printf("(%lf, %lf)\n", a.re, a.im);
}

Complex complex_conjugate(Complex z){
    Complex conj;
    conj.re = z.re;
    conj.im = -z.im;
    return conj;
}

int complex_equal(Complex a, Complex b, double tolerance){
    return (fabs(a.re - b.re) < tolerance) && (fabs(a.im - b.im) < tolerance);
}