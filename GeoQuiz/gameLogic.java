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

    public String toString() {
        String borrowedBooksString = "";
        for (Book book : borrowedBooks) {
            if (book != null) {
                borrowedBooksString += book.toString() + "\n";
            }
        }
        return "Name: " + name + ", Member ID: " + memberId + "\nBorrowed Books:\n" + borrowedBooksString;
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


    public Book findBookByIsbn(String isbn) {
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

    public void processTransaction(String memberId, String isbn, String action) {
        Member member = findMemberById(memberId);
        Book book = findBookByIsbn(isbn);

        if (member == null || book == null) {
            System.out.println("Invalid member ID or ISBN.");
            return;
        }

        if (action.equalsIgnoreCase("borrow")) {
            if (member.borrowBook(book)) {
                System.out.println(member.getName() + " borrowed " + book.getTitle());
            } else {
                System.out.println("Could not borrow book. Book unavailable or member has reached borrowing limit.");
            }
        } else if (action.equalsIgnoreCase("return")) {
            if (member.returnBook(book)) {
                System.out.println(member.getName() + " returned " + book.getTitle());
            } else {
                System.out.println("Could not return book. Book not found in member's borrowed list.");
            }
        } else {
            System.out.println("Invalid action.");
        }
    }


    public String toString(){
        String bookList = "";
        for(Book b : books){
            bookList += b.toString() + "\n";
        }
        String memberList = "";
        for(Member m : members){
            memberList += m.toString() + "\n";
        }
        return "Books:\n" + bookList + "\nMembers:\n" + memberList;
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

        library.addMember(new Member("John Doe", "1234"));
        library.addMember(new Member("Jane Smith", "5678"));

        library.processTransaction("1234", "978-0618002255", "borrow");
        library.processTransaction("5678", "978-0345391803", "borrow");
        library.processTransaction("1234", "978-0618002255", "return");
        library.processTransaction("1234", "978-0141439518", "borrow");
        library.processTransaction("1234", "978-0141439518", "borrow");
        library.processTransaction("1234", "978-0141439518", "borrow");


        System.out.println(library);
    }
}
=== END FILE ===