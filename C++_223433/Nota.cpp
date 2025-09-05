Proiectul: **Gestionar Note**

Acest proiect gestionează o listă de note, permitând adăugarea, ștergerea și afișarea lor.  Folosește fișiere pentru persistența datelor.

**Structura proiectului:**

* `main.cpp`:  Conține funcția `main` și interacționează cu clasa `NoteManager`.
* `note.h`:  Definește clasa `Nota`.
* `note.cpp`:  Implementează metodele clasei `Nota`.
* `note_manager.h`: Definește clasa `NoteManager`.
* `note_manager.cpp`: Implementează metodele clasei `NoteManager`.


**Fișier: `main.cpp`**

```cpp



using namespace std;

int main() {
  NoteManager manager;
  int optiune;

  do {
    cout << "\nMeniu:\n";
    cout << "1. Adauga nota\n";
    cout << "2. Afiseaza note\n";
    cout << "3. Sterge nota\n";
    cout << "0. Iesire\n";
    cout << "Optiune: ";
    cin >> optiune;

    switch (optiune) {
      case 1: manager.adaugaNota(); break;
      case 2: manager.afiseazaNote(); break;
      case 3: manager.stergeNota(); break;
      case 0: cout << "La revedere!\n"; break;
      default: cout << "Optiune invalida!\n";
    }
  } while (optiune != 0);

  return 0;
}
```

**Fișier: `note.h`**

```cpp




class Nota {
public:
  Nota(string titlu, string continut);
  string getTitlu() const;
  string getContinut() const;

private:
  string titlu;
  string continut;
};

```

**Fișier: `note.cpp`**

```cpp


Nota::Nota(string titlu, string continut) : titlu(titlu), continut(continut) {}

string Nota::getTitlu() const { return titlu; }
string Nota::getContinut() const { return continut; }
```

**Fișier: `note_manager.h`**

```cpp






class NoteManager {
public:
  void adaugaNota();
  void afiseazaNote();
  void stergeNota();
  void salveazaNote();
  void incarcaNote();

private:
  vector<Nota> note;
};

```

**Fișier: `note_manager.cpp`**

```cpp



using namespace std;

void NoteManager::adaugaNota() {
  string titlu, continut;
  cout << "Titlu: ";
  cin.ignore(); 
  getline(cin, titlu);
  cout << "Continut: ";
  getline(cin, continut);
  note.push_back(Nota(titlu, continut));
  salveazaNote();
}

void NoteManager::afiseazaNote() {
  if (note.empty()) {
    cout << "Nu exista note.\n";
    return;
  }
  for (const auto& nota : note) {
    cout << "Titlu: " << nota.getTitlu() << "\n";
    cout << "Continut: " << nota.getContinut() << "\n\n";
  }
}

void NoteManager::stergeNota() {
    if (note.empty()) {
        cout << "Nu exista note de sters.\n";
        return;
    }
    afiseazaNote();
    int index;
    cout << "Introduceti indexul notei de sters (incepand cu 0): ";
    cin >> index;
    if (index >= 0 && index < note.size()) {
        note.erase(note.begin() + index);
        salveazaNote();
        cout << "Nota a fost stearsa.\n";
    } else {
        cout << "Index invalid.\n";
    }
}


void NoteManager::salveazaNote() {
    ofstream file("note.txt");
    if (file.is_open()) {
        for (const auto& nota : note) {
            file << nota.getTitlu() << "\n";
            file << nota.getContinut() << "\n";
        }
        file.close();
    }
}

void NoteManager::incarcaNote() {
    ifstream file("note.txt");
    if (file.is_open()) {
        string titlu, continut;
        while (getline(file, titlu) && getline(file, continut)) {
            note.push_back(Nota(titlu, continut));
        }
        file.close();
    }
}

NoteManager::NoteManager() {
    incarcaNote();
}
```

Pentru a compila și rula, salvați fișierele în același director și compilați cu un compilator C++ (de exemplu, g++):

`g++ main.cpp note.cpp note_manager.cpp -o gestionar_note`

`./gestionar_note`


Acest exemplu demonstrează utilizarea mai multor fișiere, clase și interacțiunea dintre ele.  Gestionarea erorilor este simplificată pentru claritate.  Poate fi extins cu funcționalități suplimentare, cum ar fi căutarea notelor după titlu etc.
