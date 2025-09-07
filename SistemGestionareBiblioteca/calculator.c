#include "calculator.h"

Fraction calculate(Fraction f1, Fraction f2, Operation op) {
    switch (op) {
        case ADD: return addFractions(f1, f2);
        case SUBTRACT: return subtractFractions(f1, f2);
        case MULTIPLY: return multiplyFractions(f1, f2);
        case DIVIDE: return divideFractions(f1, f2);
        case COMPARE: {
            int result = compareFractions(f1,f2);
            if(result > 0) return createFraction(1,1);
            if(result < 0) return createFraction(-1,1);
            return createFraction(0,1);
        }
        default:
            fprintf(stderr, "Invalid operation.\n");
            exit(1);
    }
}