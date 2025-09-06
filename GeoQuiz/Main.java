Title: LibraryManager

=== FILE: Book.java ===
package library;

public class Book {
    private String title;
    private String author;
    private String isbn;
    private boolean available;

    public Book(String title, String author, String isbn) {
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.available = true;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public String getIsbn() {
        return isbn;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String toString() {
        return "Title: " + title + ", Author: " + author + ", ISBN: " + isbn + ", Available: " + available;
    }
}
=== END FILE ===

=== FILE: Member.java ===
package library;

public class Member {
    private String name;
    private String memberId;
    private Book[] borrowedBooks;
    private int borrowedBooksCount;
    private final int MAX_BOOKS = 5;

    public Member(String name, String memberId) {
        this.name = name;
        this.memberId = memberId;
        this.borrowedBooks = new Book[MAX_BOOKS];
        this.borrowedBooksCount = 0;
    }

    public String getName() {
        return name;
    }

    public String getMemberId() {
        return memberId;
    }

    public boolean borrowBook(Book book) {
        if (borrowedBooksCount < MAX_BOOKS && book.isAvailable()) {
            borrowedBooks[borrowedBooksCount++] = book;
            book.setAvailable(false);
            return true;
        }
        return false;
    }

    public boolean returnBook(Book book) {
        for (int i = 0; i < borrowedBooksCount; i++) {
            if (borrowedBooks[i].getIsbn().equals(book.getIsbn())) {
                borrowedBooks[i] = null;
                book.setAvailable(true);
                //Shift elements to fill the gap
                for(int j=i; j<borrowedBooksCount-1; j++){
                    borrowedBooks[j] = borrowedBooks[j+1];
                }
                borrowedBooksCount--;
                return true;
            }
        }
        return false;
    }


    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append("Member Name: ").append(name).append("\n");
        sb.append("Member ID: ").append(memberId).append("\n");
        sb.append("Borrowed Books:\n");
        for(Book b : borrowedBooks){
            if(b != null) sb.append(b).append("\n");
        }
        return sb.toString();
    }
}
=== END FILE ===

=== FILE: Library.java ===
package library;

import java.util.ArrayList;
import java.util.List;

public class Library {
    private List<Book> books;
    private List<Member> members;

    public Library() {
        this.books = new ArrayList<>();
        this.members = new ArrayList<>();
    }

    public void addBook(Book book) {
        books.add(book);
    }

    public void addMember(Member member) {
        members.add(member);
    }

    public Book findBookByISBN(String isbn) {
        for (Book book : books) {
            if (book.getIsbn().equals(isbn)) {
                return book;
            }
        }
        return null;
    }

    public Member findMemberById(String memberId) {
        for (Member member : members) {
            if (member.getMemberId().equals(memberId)) {
                return member;
            }
        }
        return null;
    }

    public void processTransactions(String[] transactions){
        for(String transaction : transactions){
            String[] parts = transaction.split(",");
            if(parts.length < 3){
                System.out.println("Invalid transaction: " + transaction);
                continue;
            }
            String action = parts[0].trim();
            String memberId = parts[1].trim();
            String isbn = parts[2].trim();

            Member member = findMemberById(memberId);
            Book book = findBookByISBN(isbn);

            if(member == null || book == null){
                System.out.println("Invalid transaction: Member or book not found.");
                continue;
            }

            if(action.equalsIgnoreCase("borrow")){
                if(member.borrowBook(book)){
                    System.out.println(member.getName() + " borrowed " + book.getTitle());
                } else {
                    System.out.println("Borrow failed for " + book.getTitle());
                }
            } else if (action.equalsIgnoreCase("return")){
                if(member.returnBook(book)){
                    System.out.println(member.getName() + " returned " + book.getTitle());
                } else {
                    System.out.println("Return failed for " + book.getTitle());
                }
            } else {
                System.out.println("Invalid transaction action: " + action);
            }
        }
    }

    public void printLibraryStatus(){
        System.out.println("Library Status:");
        System.out.println("Books:");
        for(Book b : books){
            System.out.println(b);
        }
        System.out.println("\nMembers:");
        for(Member m : members){
            System.out.println(m);
        }
    }
}
=== END FILE ===

=== FILE: Main.java ===
package library;

public class Main {
    public static void main(String[] args) {
        Library library = new Library();

        library.addBook(new Book("The Lord of the Rings", "J.R.R. Tolkien", "978-0618002255"));
        library.addBook(new Book("The Hitchhiker's Guide to the Galaxy", "Douglas Adams", "978-0345391803"));
        library.addBook(new Book("Pride and Prejudice", "Jane Austen", "978-0141439518"));

        library.addMember(new Member("Alice Smith", "A123"));
        library.addMember(new Member("Bob Johnson", "B456"));

        String[] transactions = {
                "borrow,A123,978-0618002255",
                "borrow,B456,978-0345391803",
                "return,A123,978-0618002255",
                "borrow,A123,978-0141439518",
                "borrow,B456,978-0618002255",
                "invalid transaction",
                "borrow,C789,978-0345391803"
        };

        library.processTransactions(transactions);
        library.printLibraryStatus();
    }
}
=== END FILE ===