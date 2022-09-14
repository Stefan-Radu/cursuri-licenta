package com.library.person;

import com.library.book.Book;
import com.library.utils.BorrowStatus;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

public class Client extends Person {

    public Client(String name, String email) {
        super(name, email);
        this.donatedBooks = new ArrayList<String>();
        this.borrowedBooksStatus = new HashMap<Book, BorrowStatus>();
    }

    private ArrayList<String> donatedBooks;
    private HashMap<Book, BorrowStatus> borrowedBooksStatus;

    // donate a book
    public void donateBook(String bookTitle) {
        donatedBooks.add(bookTitle);
    }

    // borrow a book from the library
    public boolean borrowBook(Book book) {
        if (this.borrowedBooksStatus.get(book) != BorrowStatus.BORROWED) {
            this.borrowedBooksStatus.put(book, BorrowStatus.BORROWED);
            return true;
        }

        System.err.println("book already rented");
        return false;
    }

    // return a book that he borrowed
    public boolean returnBook(Book book) {
        if (this.borrowedBooksStatus.get(book) == null) {
            System.err.println("book not borrowed. cannot return.");
            return false;
        }
        if (this.borrowedBooksStatus.get(book) == BorrowStatus.RETURNED) {
            System.err.println("book already returned.");
            return false;
        }

        this.borrowedBooksStatus.put(book, BorrowStatus.RETURNED);
        return true;
    }

    // get borrowed books
    public ArrayList<Book> getBorrowedBooks() {
        ArrayList<Book> ret = new ArrayList<>();
        for (Book book : borrowedBooksStatus.keySet()) {
            if (borrowedBooksStatus.get(book) == BorrowStatus.BORROWED) {
                ret.add(book);
            }
        }
        return ret;
    }

    // get donated books
    public ArrayList<String> getDonatedBooks() {
        return donatedBooks;
    }

    @Override
    public String toString() {
        return "Client{" +
                "donatedBooks=" + donatedBooks.toString() +
                ", borrowedBooksStatus=" + borrowedBooksStatus.toString() +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", age=" + age +
                '}';
    }
}
