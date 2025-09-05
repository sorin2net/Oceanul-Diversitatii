#include <stdio.h>
#include <stdlib.h>
#include "fractie.h"

Fractie aduna(Fractie f1, Fractie f2) {
    Fractie rezultat;
    rezultat.numarator = f1.numarator * f2.numitor + f2.numarator * f1.numitor;
    rezultat.numitor = f1.numitor * f2.numitor;
    simplifica(&rezultat);
    return rezultat;
}

Fractie scade(Fractie f1, Fractie f2) {
    Fractie rezultat;
    rezultat.numarator = f1.numarator * f2.numitor - f2.numarator * f1.numitor;
    rezultat.numitor = f1.numitor * f2.numitor;
    simplifica(&rezultat);
    return rezultat;
}

Fractie inmulteste(Fractie f1, Fractie f2) {
    Fractie rezultat;
    rezultat.numarator = f1.numarator * f2.numarator;
    rezultat.numitor = f1.numitor * f2.numitor;
    simplifica(&rezultat);
    return rezultat;
}

Fractie imparte(Fractie f1, Fractie f2) {
    Fractie rezultat;
    rezultat.numarator = f1.numarator * f2.numitor;
    rezultat.numitor = f1.numitor * f2.numarator;
    simplifica(&rezultat);
    return rezultat;
}

void simplifica(Fractie *f) {
    int a = abs(f->numarator);
    int b = abs(f->numitor);
    int c;
    while (b) {
        c = b;
        b = a % b;
        a = c;
    }
    f->numarator /= a;
    f->numitor /= a;
}


void afiseaza(Fractie f) {
    printf("%d/%d\n", f.numarator, f.numitor);
}