Title: LibraryManagement

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
    private int maxBorrowedBooks;
    private int borrowedBooksCount;


    public Member(String name, String memberId, int maxBorrowedBooks) {
        this.name = name;
        this.memberId = memberId;
        this.maxBorrowedBooks = maxBorrowedBooks;
        this.borrowedBooks = new Book[maxBorrowedBooks];
        this.borrowedBooksCount = 0;
    }

    public String getName() {
        return name;
    }

    public String getMemberId() {
        return memberId;
    }

    public Book[] getBorrowedBooks() {
        return borrowedBooks;
    }

    public int getMaxBorrowedBooks() { return maxBorrowedBooks; }

    public boolean borrowBook(Book book) {
        if (borrowedBooksCount < maxBorrowedBooks && book.isAvailable()) {
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
                for(int j = i; j < borrowedBooksCount -1; j++){
                    borrowedBooks[j] = borrowedBooks[j+1];
                }
                borrowedBooksCount--;
                return true;
            }
        }
        return false;
    }

    public String toString(){
        String borrowedBooksString = "";
        for(Book book : borrowedBooks){
            if(book != null) borrowedBooksString += book.toString() + "\n";
        }
        return "Name: " + name + "\nMember ID: " + memberId + "\nBorrowed Books:\n" + borrowedBooksString;
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

    public void processBorrowRequest(String memberId, String isbn) {
        Member member = findMemberById(memberId);
        Book book = findBookByISBN(isbn);
        if (member != null && book != null) {
            if (member.borrowBook(book)) {
                System.out.println(member.getName() + " borrowed " + book.getTitle());
            } else {
                System.out.println("Borrowing failed. Member reached borrowing limit or book unavailable.");
            }
        } else {
            System.out.println("Invalid member ID or ISBN.");
        }
    }

    public void processReturnRequest(String memberId, String isbn){
        Member member = findMemberById(memberId);
        Book book = findBookByISBN(isbn);
        if(member != null && book != null){
            if(member.returnBook(book)){
                System.out.println(member.getName() + " returned " + book.getTitle());
            } else {
                System.out.println("Return failed. Book not found in member's borrowed books.");
            }
        } else {
            System.out.println("Invalid member ID or ISBN.");
        }
    }

    public void printAllBooks(){
        for(Book book : books){
            System.out.println(book);
        }
    }

    public void printAllMembers(){
        for(Member member : members){
            System.out.println(member);
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

        library.addMember(new Member("Alice", "A123", 2));
        library.addMember(new Member("Bob", "B456", 3));


        library.processBorrowRequest("A123", "978-0618002255");
        library.processBorrowRequest("B456", "978-0345391803");
        library.processBorrowRequest("A123", "978-0141439518");
        library.processBorrowRequest("A123", "978-0141439518"); //This should fail

        library.printAllBooks();
        library.printAllMembers();

        library.processReturnRequest("A123", "978-0618002255");
        library.printAllBooks();
        library.printAllMembers();

    }
}
=== END FILE ===