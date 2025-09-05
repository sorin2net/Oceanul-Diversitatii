#include <stdio.h>
#include "fractie.h"

int main() {
    Fractie f1 = {1, 2};
    Fractie f2 = {3, 4};

    Fractie suma = aduna(f1, f2);
    printf("Suma: ");
    afiseaza(suma);

    Fractie diferenta = scade(f1, f2);
    printf("Diferenta: ");
    afiseaza(diferenta);

    Fractie produs = inmulteste(f1, f2);
    printf("Produs: ");
    afiseaza(produs);

    Fractie cat = imparte(f1, f2);
    printf("Cat: ");
    afiseaza(cat);

    return 0;
}