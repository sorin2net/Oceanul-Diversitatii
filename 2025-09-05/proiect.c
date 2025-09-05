Acest proiect mic calculează aria unui dreptunghi și a unui cerc, folosind funcții separate.

**Fișier: `geometria.h`**

```c
#ifndef GEOMETRIA_H
#define GEOMETRIA_H

// Prototipuri de funcții
float calculeaza_aria_dreptunghi(float lungime, float latime);
float calculeaza_aria_cerc(float raza);

#endif
```

**Fișier: `geometria.c`**

```c
#include <stdio.h>
#include <math.h>
#include "geometria.h"

// Funcție pentru calcularea ariei unui dreptunghi
float calculeaza_aria_dreptunghi(float lungime, float latime) {
  if (lungime <= 0 || latime <= 0) {
    fprintf(stderr, "Eroare: Lungimea si latimea trebuie sa fie valori pozitive.\n");
    return -1; // Returneaza -1 pentru a indica o eroare
  }
  return lungime * latime;
}

// Funcție pentru calcularea ariei unui cerc
float calculeaza_aria_cerc(float raza) {
  if (raza <= 0) {
    fprintf(stderr, "Eroare: Raza trebuie sa fie o valoare pozitiva.\n");
    return -1; // Returneaza -1 pentru a indica o eroare
  }
  return M_PI * raza * raza;
}
```

**Fișier: `main.c`**

```c
#include <stdio.h>
#include "geometria.h"

int main() {
  float lungime_dreptunghi, latime_dreptunghi, raza_cerc;
  float aria_dreptunghi, aria_cerc;

  // Citirea datelor de la utilizator
  printf("Introduceti lungimea dreptunghiului: ");
  scanf("%f", &lungime_dreptunghi);
  printf("Introduceti latimea dreptunghiului: ");
  scanf("%f", &latime_dreptunghi);
  printf("Introduceti raza cercului: ");
  scanf("%f", &raza_cerc);


  // Calcularea ariilor
  aria_dreptunghi = calculeaza_aria_dreptunghi(lungime_dreptunghi, latime_dreptunghi);
  aria_cerc = calculeaza_aria_cerc(raza_cerc);

  // Afisarea rezultatelor
  if (aria_dreptunghi >= 0) {
    printf("Aria dreptunghiului este: %.2f\n", aria_dreptunghi);
  }
  if (aria_cerc >= 0) {
    printf("Aria cercului este: %.2f\n", aria_cerc);
  }

  return 0;
}
```

Pentru a compila și rula acest cod, salvați cele trei fișiere în același director și utilizați următoarea comandă în terminal (pe Linux/macOS):

```bash
gcc main.c geometria.c -o geometria -lm
./geometria
```

Comanda `-lm` este necesară pentru a lega biblioteca matematică (`math.h`).  Acest proiect demonstrează utilizarea header files, funcțiilor și tratarea erorilor într-un program C simplu.
