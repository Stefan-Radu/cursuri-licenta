package com.library.person;

import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

public class Author extends Person {

    public Author(String name) {
        super(name);
        this.writtenBooks = new TreeSet<String>();
    }

    private TreeSet<String> writtenBooks;

    // add new a new book to the collection
    public void addBook(String bookTitle) {
        this.writtenBooks.add(bookTitle);
    }

    // check if book is written by this author
    public boolean isWrittenByMe(String bookTitle) {
        return this.writtenBooks.contains(bookTitle);
    }

    @Override
    public String toString() {
        return "Author{" +
                "writtenBooks=" + writtenBooks.toString() +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", age=" + age +
                '}';
    }

    public ArrayList<String> serialize() {
        ArrayList<String> ret = new ArrayList<String>();
        ret.add(name);
        return ret;
    }
}
