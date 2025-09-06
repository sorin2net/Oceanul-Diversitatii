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

    public String toString(){
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
    private final int MAX_BORROWED_BOOKS = 5;


    public Member(String name, String memberId) {
        this.name = name;
        this.memberId = memberId;
        this.borrowedBooks = new Book[MAX_BORROWED_BOOKS];
        this.borrowedBooksCount = 0;
    }

    public String getName() {
        return name;
    }

    public String getMemberId() {
        return memberId;
    }

    public boolean borrowBook(Book book) {
        if (borrowedBooksCount < MAX_BORROWED_BOOKS && book.isAvailable()) {
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
                //Shift elements
                for(int j=i; j<borrowedBooksCount-1; j++){
                    borrowedBooks[j] = borrowedBooks[j+1];
                }
                borrowedBooksCount--;
                return true;
            }
        }
        return false;
    }

    public Book[] getBorrowedBooks(){
        Book[] borrowed = new Book[borrowedBooksCount];
        System.arraycopy(borrowedBooks, 0, borrowed, 0, borrowedBooksCount);
        return borrowed;
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
        this.books.add(book);
    }

    public void addMember(Member member) {
        this.members.add(member);
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

    public void processLoan(String memberId, String isbn){
        Member member = findMemberById(memberId);
        Book book = findBookByISBN(isbn);
        if(member != null && book != null){
            if(member.borrowBook(book)){
                System.out.println(member.getName() + " borrowed " + book.getTitle());
            } else {
                System.out.println("Loan failed. Book unavailable or member limit reached.");
            }
        } else {
            System.out.println("Member or book not found.");
        }
    }


    public void processReturn(String memberId, String isbn){
        Member member = findMemberById(memberId);
        Book book = findBookByISBN(isbn);
        if(member != null && book != null){
            if(member.returnBook(book)){
                System.out.println(member.getName() + " returned " + book.getTitle());
            } else {
                System.out.println("Return failed. Book not found in member's borrowed books.");
            }
        } else {
            System.out.println("Member or book not found.");
        }
    }

    public void displayAllBooks(){
        for(Book b : books){
            System.out.println(b);
        }
    }

    public void displayMemberBooks(String memberId){
        Member member = findMemberById(memberId);
        if(member != null){
            Book[] borrowed = member.getBorrowedBooks();
            if(borrowed.length > 0){
                for(Book b : borrowed){
                    System.out.println(b);
                }
            } else {
                System.out.println("Member has no borrowed books.");
            }
        } else {
            System.out.println("Member not found.");
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
        library.addBook(new Book("Pride and Prejudice", "Jane Austen", "978-0141439518"));
        library.addBook(new Book("1984", "George Orwell", "978-0451524935"));

        library.addMember(new Member("John Doe", "1234"));
        library.addMember(new Member("Jane Smith", "5678"));

        library.processLoan("1234", "978-0618002255");
        library.processLoan("5678", "978-0141439518");
        library.processLoan("1234", "978-0451524935");
        library.processLoan("1234", "978-0451524935"); //Should fail


        library.displayAllBooks();
        library.displayMemberBooks("1234");

        library.processReturn("1234", "978-0618002255");
        library.displayAllBooks();
        library.displayMemberBooks("1234");

    }
}
=== END FILE ===