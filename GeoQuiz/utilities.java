Title: BibliotecaDigitala

=== FILE: Main.java ===
import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Biblioteca biblioteca = new Biblioteca();
        boolean running = true;

        while (running) {
            System.out.println("\nMeniu:");
            System.out.println("1. Adauga carte");
            System.out.println("2. Cauta carte");
            System.out.println("3. Afiseaza toate cartile");
            System.out.println("4. Imprumuta carte");
            System.out.println("5. Returneaza carte");
            System.out.println("6. Iesire");

            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    biblioteca.adaugaCarte(new Carte(scanner.nextLine(), scanner.nextLine(), scanner.nextLine()));
                    break;
                case 2:
                    System.out.println("Introduceti titlul sau autorul:");
                    String query = scanner.nextLine();
                    biblioteca.cautaCarte(query);
                    break;
                case 3:
                    biblioteca.afiseazaToateCartile();
                    break;
                case 4:
                    System.out.println("Introduceti titlul cartii:");
                    String title = scanner.nextLine();
                    biblioteca.imprumutaCarte(title);
                    break;
                case 5:
                    System.out.println("Introduceti titlul cartii:");
                    String returnTitle = scanner.nextLine();
                    biblioteca.returneazaCarte(returnTitle);
                    break;
                case 6:
                    running = false;
                    break;
                default:
                    System.out.println("Optiune invalida.");
            }
        }
        scanner.close();
    }
}
=== END FILE ===

=== FILE: Biblioteca.java ===
import java.util.ArrayList;
import java.util.List;

public class Biblioteca {
    private List<Carte> carti;
    private List<Carte> cartiImprumutate;

    public Biblioteca() {
        carti = new ArrayList<>();
        cartiImprumutate = new ArrayList<>();
    }

    public void adaugaCarte(Carte carte) {
        carti.add(carte);
    }

    public void cautaCarte(String query) {
        boolean found = false;
        for (Carte carte : carti) {
            if (carte.getTitlu().toLowerCase().contains(query.toLowerCase()) || carte.getAutor().toLowerCase().contains(query.toLowerCase())) {
                System.out.println(carte);
                found = true;
            }
        }
        if (!found) {
            System.out.println("Cartea nu a fost gasita.");
        }
    }

    public void afiseazaToateCartile() {
        if (carti.isEmpty()) {
            System.out.println("Biblioteca este goala.");
            return;
        }
        for (Carte carte : carti) {
            System.out.println(carte);
        }
    }

    public void imprumutaCarte(String title) {
        Carte carte = cautaCarteInBiblioteca(title);
        if (carte != null) {
            cartiImprumutate.add(carte);
            carti.remove(carte);
            System.out.println("Cartea '" + title + "' a fost imprumutata.");
        } else {
            System.out.println("Cartea '" + title + "' nu a fost gasita.");
        }
    }

    public void returneazaCarte(String title) {
        Carte carte = cautaCarteInImprumut(title);
        if (carte != null) {
            carti.add(carte);
            cartiImprumutate.remove(carte);
            System.out.println("Cartea '" + title + "' a fost returnata.");
        } else {
            System.out.println("Cartea '" + title + "' nu a fost gasita in lista de carti imprumutate.");
        }
    }

    private Carte cautaCarteInBiblioteca(String title) {
        for (Carte carte : carti) {
            if (carte.getTitlu().equalsIgnoreCase(title)) {
                return carte;
            }
        }
        return null;
    }

    private Carte cautaCarteInImprumut(String title) {
        for (Carte carte : cartiImprumutate) {
            if (carte.getTitlu().equalsIgnoreCase(title)) {
                return carte;
            }
        }
        return null;
    }
}
=== END FILE ===

=== FILE: Carte.java ===
public class Carte {
    private String titlu;
    private String autor;
    private String isbn;

    public Carte(String titlu, String autor, String isbn) {
        this.titlu = titlu;
        this.autor = autor;
        this.isbn = isbn;
    }

    public String getTitlu() {
        return titlu;
    }

    public String getAutor() {
        return autor;
    }

    @Override
    public String toString() {
        return "Titlu: " + titlu + ", Autor: " + autor + ", ISBN: " + isbn;
    }
}
=== END FILE ===