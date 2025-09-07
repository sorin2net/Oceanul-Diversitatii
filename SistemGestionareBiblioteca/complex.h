typedef struct {
    double re;
    double im;
} Complex;

Complex complex_new(double re, double im);
Complex complex_add(Complex a, Complex b);
Complex complex_sub(Complex a, Complex b);
Complex complex_mul(Complex a, Complex b);
Complex complex_div(Complex a, Complex b);
double complex_abs(Complex a);
Complex complex_pow(Complex a, int n);
Complex complex_exp(Complex a);
Complex complex_ln(Complex a);
void complex_print(Complex a);
Complex complex_conjugate(Complex z);
int complex_equal(Complex a, Complex b, double tolerance);