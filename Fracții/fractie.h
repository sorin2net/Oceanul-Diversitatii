#ifndef FRACTIE_H
#define FRACTIE_H

typedef struct {
    int numarator;
    int numitor;
} Fractie;

Fractie aduna(Fractie f1, Fractie f2);
Fractie scade(Fractie f1, Fractie f2);
Fractie inmulteste(Fractie f1, Fractie f2);
Fractie imparte(Fractie f1, Fractie f2);
void simplifica(Fractie *f);
void afiseaza(Fractie f);

#endif