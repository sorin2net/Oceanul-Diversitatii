Title: BibliotecaDigitala

=== FILE: Carte.java ===
package biblioteca;

public class Carte {
    private String titlu;
    private String autor;
    private int anAparitie;
    private String isbn;
    private boolean imprumutata;

    public Carte(String titlu, String autor, int anAparitie, String isbn) {
        this.titlu = titlu;
        this.autor = autor;
        this.anAparitie = anAparitie;
        this.isbn = isbn;
        this.imprumutata = false;
    }

    public String getTitlu() {
        return titlu;
    }

    public String getAutor() {
        return autor;
    }

    public int getAnAparitie() {
        return anAparitie;
    }

    public String getIsbn() {
        return isbn;
    }

    public boolean isImprumutata() {
        return imprumutata;
    }

    public void setImprumutata(boolean imprumutata) {
        this.imprumutata = imprumutata;
    }

    public String toString() {
        return "Titlu: " + titlu + ", Autor: " + autor + ", An aparitie: " + anAparitie + ", ISBN: " + isbn + ", Imprumutata: " + imprumutata;
    }
}
=== END FILE ===

=== FILE: Membru.java ===
package biblioteca;

public class Membru {
    private String nume;
    private String idMembru;
    private int nrCartiImprumutate;

    public Membru(String nume, String idMembru) {
        this.nume = nume;
        this.idMembru = idMembru;
        this.nrCartiImprumutate = 0;
    }

    public String getNume() {
        return nume;
    }

    public String getIdMembru() {
        return idMembru;
    }

    public int getNrCartiImprumutate() {
        return nrCartiImprumutate;
    }

    public void incrementeazaNrCartiImprumutate() {
        this.nrCartiImprumutate++;
    }

    public void decrementeazaNrCartiImprumutate() {
        this.nrCartiImprumutate--;
    }

    public String toString() {
        return "Nume: " + nume + ", ID Membru: " + idMembru + ", Nr. carti imprumutate: " + nrCartiImprumutate;
    }
}
=== END FILE ===

=== FILE: Biblioteca.java ===
package biblioteca;

import java.util.ArrayList;
import java.util.List;

public class Biblioteca {
    private List<Carte> carti;
    private List<Membru> membri;

    public Biblioteca() {
        this.carti = new ArrayList<>();
        this.membri = new ArrayList<>();
    }

    public void adaugaCarte(Carte carte) {
        this.carti.add(carte);
    }

    public void adaugaMembru(Membru membru) {
        this.membri.add(membru);
    }

    public Carte gasesteCarteDupaISBN(String isbn) {
        for (Carte carte : carti) {
            if (carte.getIsbn().equals(isbn)) {
                return carte;
            }
        }
        return null;
    }


    public Membru gasesteMembruDupaID(String idMembru) {
        for (Membru membru : membri) {
            if (membru.getIdMembru().equals(idMembru)) {
                return membru;
            }
        }
        return null;
    }

    public void imprumutaCarte(String isbn, String idMembru) {
        Carte carte = gasesteCarteDupaISBN(isbn);
        Membru membru = gasesteMembruDupaID(idMembru);
        if (carte != null && membru != null && !carte.isImprumutata()) {
            carte.setImprumutata(true);
            membru.incrementeazaNrCartiImprumutate();
            System.out.println("Carte imprumutata cu succes!");
        } else {
            System.out.println("Eroare la imprumutarea cartii.");
        }
    }

    public void returneazaCarte(String isbn, String idMembru) {
        Carte carte = gasesteCarteDupaISBN(isbn);
        Membru membru = gasesteMembruDupaID(idMembru);
        if (carte != null && membru != null && carte.isImprumutata()) {
            carte.setImprumutata(false);
            membru.decrementeazaNrCartiImprumutate();
            System.out.println("Carte returnata cu succes!");
        } else {
            System.out.println("Eroare la returnarea cartii.");
        }
    }

    public void afiseazaCarti() {
        for (Carte carte : carti) {
            System.out.println(carte);
        }
    }

    public void afiseazaMembri() {
        for (Membru membru : membri) {
            System.out.println(membru);
        }
    }
}
=== END FILE ===

=== FILE: Main.java ===
package biblioteca;

public class Main {
    public static void main(String[] args) {
        Biblioteca biblioteca = new Biblioteca();

        biblioteca.adaugaCarte(new Carte("1984", "George Orwell", 1949, "978-0451524935"));
        biblioteca.adaugaCarte(new Carte("Stăpânul Inelelor", "J.R.R. Tolkien", 1954, "978-0618002255"));
        biblioteca.adaugaCarte(new Carte("Mândrie și Prejudecată", "Jane Austen", 1813, "978-0141439518"));

        biblioteca.adaugaMembru(new Membru("Ion Popescu", "12345"));
        biblioteca.adaugaMembru(new Membru("Maria Ionescu", "67890"));

        biblioteca.imprumutaCarte("978-0451524935", "12345");
        biblioteca.returneazaCarte("978-0451524935", "12345");
        biblioteca.imprumutaCarte("978-0618002255", "67890");


        biblioteca.afiseazaCarti();
        System.out.println();
        biblioteca.afiseazaMembri();
    }
}
=== END FILE ===