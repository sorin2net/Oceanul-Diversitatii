

Acest proiect este un gestionar simplu de note, care permite utilizatorului să creeze, să citească, să modifice și să șteargă note textuale.  Folosește fișiere pentru a stoca datele persistent.

**Structura proiectului:**

* **note.h:**  Definește clasa `Nota`.
* **note.cpp:**  Implementează metodele clasei `Nota`.
* **gestionar_note.cpp:**  Conține funcția `main` și logica principală a programului.


**note.h:**

```cpp






class Nota {
public:
    Nota(std::string titlu, std::string continut);
    void salveaza(const std::string& numeFisier);
    static Nota citeste(const std::string& numeFisier);
    std::string getTitlu() const;
    std::string getContinut() const;
    void setContinut(const std::string& continutNou);

private:
    std::string titlu;
    std::string continut;
};


```

**note.cpp:**

```cpp


Nota::Nota(std::string titlu, std::string continut) : titlu(titlu), continut(continut) {}

void Nota::salveaza(const std::string& numeFisier) {
    std::ofstream fisier(numeFisier);
    fisier << titlu << std::endl;
    fisier << continut << std::endl;
    fisier.close();
}

Nota Nota::citeste(const std::string& numeFisier) {
    std::ifstream fisier(numeFisier);
    std::string titlu, continut;
    std::getline(fisier, titlu);
    std::getline(fisier, continut);
    fisier.close();
    return Nota(titlu, continut);
}

std::string Nota::getTitlu() const { return titlu; }
std::string Nota::getContinut() const { return continut; }
void Nota::setContinut(const std::string& continutNou) { continut = continutNou; }
```

**gestionar_note.cpp:**

```cpp




int main() {
    std::string numeFisier;
    std::cout << "Introduceti numele fisierului: ";
    std::cin >> numeFisier;

    try {
        Nota nota = Nota::citeste(numeFisier);
        std::cout << "Titlu: " << nota.getTitlu() << std::endl;
        std::cout << "Continut: " << nota.getContinut() << std::endl;

        std::string nouContinut;
        std::cout << "Introduceti noul continut (lasati gol pentru a pastra continutul): ";
        std::getline(std::cin >> std::ws, nouContinut); 

        if (!nouContinut.empty()) {
            nota.setContinut(nouContinut);
            nota.salveaza(numeFisier);
            std::cout << "Nota a fost actualizata." << std::endl;
        }
    } catch (const std::exception& e) {
        std::cout << "Eroare la citirea fisierului: " << e.what() << std::endl;

        std::string titlu;
        std::string continut;
        std::cout << "Introduceti titlul notei: ";
        std::getline(std::cin >> std::ws, titlu);
        std::cout << "Introduceti continutul notei: ";
        std::getline(std::cin, continut);

        Nota notaNoua(titlu, continut);
        notaNoua.salveaza(numeFisier);
        std::cout << "Nota a fost creata." << std::endl;

    }

    return 0;
}
```

Pentru a compila și rula acest proiect, trebuie să aveți un compilator C++ (cum ar fi g++) instalat.  Salvați codul în trei fișiere separate (note.h, note.cpp, gestionar_note.cpp) și compilați folosind o comandă similară cu:

```bash
g++ note.cpp gestionar_note.cpp -o gestionar_note
./gestionar_note
```

Programul va cere utilizatorului numele fisierului.  Daca fisierul exista, va afisa continutul si va permite modificarea lui. Daca fisierul nu exista, va crea o noua nota.
