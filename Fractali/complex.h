#ifndef COMPLEX_H
#define COMPLEX_H

class Complex {
public:
  Complex(double re = 0.0, double im = 0.0) : re(re), im(im) {}
  double absSq() const;
  Complex operator*(const Complex& other) const;

private:
  double re;
  double im;
};

#endif