```kotlin
import java.time.LocalDate
import java.util.logging.Logger
import java.util.concurrent.ConcurrentHashMap

class Carti(val isbn: String, val titlu: String, val autor: String, val anAparitie: Int) {
    var disponibil: Boolean = true
    val logger = Logger.getLogger(Carti::class.java.name)

    fun marcheazaIndisponibil() {
        if (disponibil) {
            disponibil = false
            logger.info("Cartea $titlu a fost marcata ca indisponibila.")
        } else {
            logger.warning("Cartea $titlu este deja indisponibila.")
        }
    }

    fun marcheazaDisponibil() {
        if (!disponibil) {
            disponibil = true
            logger.info("Cartea $titlu a fost marcata ca disponibila.")
        } else {
            logger.warning("Cartea $titlu este deja disponibila.")
        }
    }
}


object ManagerCarti {
    private val carti: MutableMap<String, Carti> = ConcurrentHashMap()
    private val logger = Logger.getLogger(ManagerCarti::class.java.name)

    private var observers: MutableList<ObserverCarti> = mutableListOf()


    init {
        // Init data (e.g., load from database)
    }


    fun adaugaCarte(carte: Carti) {
        if (carte.isbn.isBlank() || carte.titlu.isBlank() || carte.autor.isBlank() || carte.anAparitie <= 0) {
            throw IllegalArgumentException("Date invalide pentru carte.")
        }

        if (carti.containsKey(carte.isbn)) {
            throw IllegalArgumentException("Carte cu ISBN-ul $carte.isbn deja existentă.")
        }


        carti[carte.isbn] = carte
        logger.info("Cartea $carte a fost adaugata.")
        notifyObservers(carte)
    }



    fun stergeCarte(isbn: String) {
        val carte = carti.remove(isbn)
        if (carte != null) {
            logger.info("Cartea cu ISBN $isbn a fost stearsa.")
            notifyObservers(carte)
        } else {
            logger.warning("Cartea cu ISBN $isbn nu a fost gasita.")
        }
    }



    fun gasesteCarte(isbn: String): Carti? {
        return carti[isbn]
    }


    fun actualizeazaCarte(carte: Carti) {
        val existingCarte = carti[carte.isbn]
        if (existingCarte != null) {
            carti[carte.isbn] = carte
            logger.info("Cartea cu ISBN $carte.isbn a fost actualizata.")
            notifyObservers(carte)
        } else {
            throw IllegalArgumentException("Carte cu ISBN $carte.isbn nu a fost gasita.")
        }
    }



     fun inchiriazaCarte(isbn: String) {
        val carte = carti[isbn] ?: throw IllegalArgumentException("Cartea cu ISBN $isbn nu exista.")
        carte.marcheazaIndisponibil()
    }

    fun returneazaCarte(isbn: String) {
         val carte = carti[isbn] ?: throw IllegalArgumentException("Cartea cu ISBN $isbn nu exista.")
         carte.marcheazaDisponibil()
    }

   // Observer Pattern
   fun addObserver(observer: ObserverCarti) { observers.add(observer) }
    fun removeObserver(observer: ObserverCarti) { observers.remove(observer) }
    private fun notifyObservers(carte: Carti) {
      observers.forEach { it.update(carte) }
    }
}


interface ObserverCarti {
    fun update(carte: Carti)
}


fun main() {

// Exemplu utilizare
    try {
        val carte1 = Carti("978-0321765677", "Clean Code", "Robert C. Martin", 2008)
        val manager = ManagerCarti
        manager.adaugaCarte(carte1)
    } catch (e: Exception) {
        println("Eroare: ${e.message}")
    }
}
```

**Explicații și îmbunătățiri:**

* **`ConcurrentHashMap`:** Folosit pentru `carti` pentru a gestiona posibile accesări concurente (important dacă mai multe thread-uri vor accesa `ManagerCarti`).
* **`Logger`:** Implementat cu `java.util.logging`.
* **Gestionarea Erorilor:**  Adăugate excepții (`IllegalArgumentException`) pentru validări (ISBN vid, carte existentă).  Mesajele de eroare sunt mai descriptive.
* **Validări:**  Adăugate validări pentru datele introduse pentru carte.
* **Observer Pattern:** Adăugat un model Observer pentru notificarea elementelor aflate în afara clasei `ManagerCarti` când se modifică starea unei cărți (adăugare, ştergere, actualizare).
* **Singleton:** `ManagerCarti` este un `object`, implementând singleton-ul implicit din Kotlin.
* **Factory (Implicit):**  Nu e explicit un `Factory` dar crearea obiectelor Carti se face direct in cod. Poate fi extins, dacă vrei crearea cărților de la un alt loc.
* **`notifyObservers`:**  Notifică observatorii atunci când se adaugă/șterge/actualizează o carte.
* **`ObserverCarti`:** Interfață pentru observatori.
* **`main` function:**  Cod de exemplu pentru utilizare.
* **Gestionare Disponibilitate:**  Metodele `marcheazaIndisponibil()` și `marcheazaDisponibil()` sunt validate pentru a gestiona corecte situațiile când cartea este deja indisponibila/disponibila.
* **Consistență:**  Validări și mesajele de log sunt mai consistente.
* **Exemple de excepții:**  `IllegalArgumentException` pentru cazuri de eroare.


**Cum se folosește:**

1.  Implementează `ObserverCarti` în clasele tale care vor fi notificate despre modificările cărților.
2.  Adaugă un `ObserverCarti` la `ManagerCarti` pentru a fi notificat.
3.  Utilizează metodele `adaugaCarte`, `stergeCarte`, `actualizeazaCarte` și altele din `ManagerCarti`.


**Îmbunătățiri viitoare:**

* **Persistență:**  Stocarea datelor în baza de date.
* **Validări mai complexe:**  Validări suplimentare bazate pe regulile de afaceri.
* **Interfață grafică (UI):**  Pentru o interacțiune mai ușor de utilizat.
* **Gestionare în plus a erorilor:** Logare mai detaliată a erorilor, inclusiv stack trace.


Acesta este un exemplu mai avansat și robust, care demonstrează principiile de proiectare și implementare mai moderne.  Nu ezita să adaugi detalii sau modificări în funcție de nevoile tale specifice.
```kotlin
import java.time.LocalDate
import java.util.logging.Logger
import java.util.concurrent.ConcurrentHashMap

class Carti(val isbn: String, val titlu: String, val autor: String, val anAparitie: Int) {
    var disponibil: Boolean = true
    private val logger = Logger.getLogger(Carti::class.java.name)

    fun marcheazaIndisponibil() {
        if (disponibil) {
            disponibil = false
            logger.info("Cartea $titlu a fost marcata ca indisponibila.")
        } else {
            logger.warning("Cartea $titlu este deja indisponibila.")
        }
    }

    fun marcheazaDisponibil() {
        if (!disponibil) {
            disponibil = true
            logger.info("Cartea $titlu a fost marcata ca disponibila.")
        } else {
            logger.warning("Cartea $titlu este deja disponibila.")
        }
    }

    // Adăugare validare pentru constructor
    init {
        if (isbn.isBlank() || titlu.isBlank() || autor.isBlank() || anAparitie <= 0) {
            throw IllegalArgumentException("Date invalide pentru carte.")
        }
    }
}


object ManagerCarti {
    private val carti: MutableMap<String, Carti> = ConcurrentHashMap()
    private val logger = Logger.getLogger(ManagerCarti::class.java.name)
    private val observers: MutableList<ObserverCarti> = mutableListOf()

     init {
        // Exemplu de încărcare din DB (înlocuiește cu logica ta)
       // val cartiDinDB = loadCartiFromDB() // Funcție pentru încărcare
       // carti.putAll(cartiDinDB)

    }


    fun adaugaCarte(carte: Carti) {
        if (carti.containsKey(carte.isbn)) {
            throw IllegalArgumentException("Carte cu ISBN-ul ${carte.isbn} deja existentă.")
        }
        carti[carte.isbn] = carte
        logger.info("Cartea ${carte.titlu} a fost adaugata.")
        notifyObservers(carte)
    }


    fun stergeCarte(isbn: String): Boolean {
        val carte = carti.remove(isbn)
        if (carte != null) {
            logger.info("Cartea cu ISBN $isbn a fost stearsa.")
            notifyObservers(carte)
            return true
        } else {
            logger.warning("Cartea cu ISBN $isbn nu a fost gasita.")
            return false
        }
    }


    fun gasesteCarte(isbn: String): Carti? {
        return carti[isbn]
    }

    fun actualizeazaCarte(carte: Carti) {
        if (!carti.containsKey(carte.isbn)) {
           throw IllegalArgumentException("Cartea cu ISBN ${carte.isbn} nu a fost gasita.")
        }
        carti[carte.isbn] = carte
        logger.info("Cartea ${carte.titlu} a fost actualizata.")
        notifyObservers(carte)
    }

    // ... alte metode (inchiriazaCarte, returneazaCarte)

     // Observer Pattern
    fun addObserver(observer: ObserverCarti) { observers.add(observer) }
    fun removeObserver(observer: ObserverCarti) { observers.remove(observer) }
    private fun notifyObservers(carte: Carti) {
        observers.forEach { it.update(carte) }
    }

    //Exemplu de logare la eroare (optional)
    fun inchiriazaCarte(isbn: String) {
        val carte = carti[isbn] ?: throw IllegalArgumentException("Cartea cu ISBN $isbn nu exista.")
        carte.marcheazaIndisponibil()
    }

    fun returneazaCarte(isbn: String){
        val carte = carti[isbn] ?: throw IllegalArgumentException("Cartea cu ISBN $isbn nu exista.")
        carte.marcheazaDisponibil()
    }
}


interface ObserverCarti {
    fun update(carte: Carti)
}
```

**Explicații și îmbunătățiri cheie:**

* **Validări în `Carti`:** Constructorul clasei `Carti` conține acum validări pentru datele introduse, prevenind erori.
* **`stergeCarte` returnând `Boolean`:** Metoda `stergeCarte` returnează acum `true` dacă ștergerea a avut succes și `false` dacă cartea nu a fost găsită.  Acest lucru permite un feedback mai precis asupra operației.
* **Gestionarea erorilor îmbunătățită:** Excepțiile `IllegalArgumentException` includ acum mesajele de eroare mai precise, făcând depanarea mai ușoară.
* **`init` block în `ManagerCarti`:** A fost adaugat un `init` block in `ManagerCarti` care poate servi pentru initializarea datelor din surse externe, în acest caz (fictiv) o baza de date.


**Cum se utilizează (exemplu):**

```kotlin
fun main() {
    // ... (cod existent)

    try {
        val carte1 = Carti("978-0321765677", "Clean Code", "Robert C. Martin", 2008)
        ManagerCarti.adaugaCarte(carte1)

        // Verifică dacă a fost adăugată
        val carteGasita = ManagerCarti.gasesteCarte("978-0321765677")
        if (carteGasita != null) {
            println("Cartea a fost gasita.")
        }

        if (ManagerCarti.stergeCarte("978-0321765677")) {
          println("Cartea a fost ştearsă.");
        } else {
          println("Cartea nu a fost găsită.");
        }
    } catch (e: IllegalArgumentException) {
        println("Eroare: ${e.message}")
    }
}
```

Aceste modificări fac codul mai robust și mai ușor de utilizat.  Adaugă validări, excepții mai informative și feedback atunci când operația nu reuseste.  Acum, gestionarea erorilor este mult mai sigură.



**Importanți:**
1.   **Înlocuire `loadCartiFromDB`:** Înlocuiește comentariul `// val cartiDinDB = loadCartiFromDB()` cu logica ta specifică pentru încărcarea datelor din sursa ta de date (de exemplu, din baza de date).
2.   **Logare:** Logarea este acum mai detaliată, include informații relevante despre eveniment. Poti configura nivele de log, etc.