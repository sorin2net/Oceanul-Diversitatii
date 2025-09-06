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
    private int borrowedCount;
    private final int MAX_BORROWED = 3;

    public Member(String name, String memberId) {
        this.name = name;
        this.memberId = memberId;
        this.borrowedBooks = new Book[MAX_BORROWED];
        this.borrowedCount = 0;
    }

    public String getName() {
        return name;
    }

    public String getMemberId() {
        return memberId;
    }

    public boolean borrowBook(Book book) {
        if (borrowedCount < MAX_BORROWED && book.isAvailable()) {
            borrowedBooks[borrowedCount++] = book;
            book.setAvailable(false);
            return true;
        }
        return false;
    }

    public boolean returnBook(Book book) {
        for (int i = 0; i < borrowedCount; i++) {
            if (borrowedBooks[i].getIsbn().equals(book.getIsbn())) {
                borrowedBooks[i] = null;
                book.setAvailable(true);
                shiftArray(i);
                borrowedCount--;
                return true;
            }
        }
        return false;
    }

    private void shiftArray(int index) {
        for (int i = index; i < borrowedCount; i++) {
            borrowedBooks[i] = borrowedBooks[i + 1];
        }
    }

    public String getBorrowedBooks() {
        StringBuilder sb = new StringBuilder();
        for (Book book : borrowedBooks) {
            if (book != null) {
                sb.append(book.toString()).append("\n");
            }
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


    public String getAllBooks() {
        StringBuilder sb = new StringBuilder();
        for (Book book : books) {
            sb.append(book.toString()).append("\n");
        }
        return sb.toString();
    }

    public String getAllMembers() {
        StringBuilder sb = new StringBuilder();
        for (Member member : members) {
            sb.append("Member Name: ").append(member.getName()).append(", Member ID: ").append(member.getMemberId()).append("\n");
        }
        return sb.toString();
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
        library.addBook(new Book("1984", "George Orwell", "978-0451524935"));

        library.addMember(new Member("John Doe", "1234"));
        library.addMember(new Member("Jane Smith", "5678"));

        Member john = library.findMemberById("1234");
        Book lordOfTheRings = library.findBookByISBN("978-0618002255");

        if (john != null && lordOfTheRings != null) {
            john.borrowBook(lordOfTheRings);
            System.out.println(john.getBorrowedBooks());
            john.returnBook(lordOfTheRings);
            System.out.println(library.getAllBooks());
            System.out.println(library.getAllMembers());

        } else {
            System.out.println("Member or book not found.");
        }
    }
}
=== END FILE ===