package com.library.transaction;

import com.library.book.Book;
import com.library.person.Person;
import com.library.utils.TransactionType;

import java.time.LocalDate;
import java.util.ArrayList;

public class Transaction {

    public Transaction(TransactionType type, String personName, String bookTitle) {
        this.type = type;
        this.personName = personName;
        this.bookTitle = bookTitle;
        this.date = LocalDate.now();
    }

    public Transaction(TransactionType type, String personName, String bookTitle,
                       LocalDate date) {
        this.type = type;
        this.personName = personName;
        this.bookTitle = bookTitle;
        this.date = date;
    }

    private final TransactionType type;
    private final LocalDate date;
    private String personName;
    private String bookTitle;

    public TransactionType getType() {
        return type;
    }

    public LocalDate getDate() {
        return date;
    }

    public String getPersonName() {
        return personName;
    }

    public void setPersonName(String personName) {
        this.personName = personName;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    @Override
    public String toString() {
        return "Transaction{" +
                "type=" + type +
                ", date=" + date +
                ", personName=" + personName +
                ", bookTitle=" + bookTitle +
                '}';
    }

    public ArrayList<String> serialize() {
        ArrayList<String> ret = new ArrayList<String>();
        ret.add(type.toString());
        ret.add(date.toString());
        ret.add(personName);
        ret.add(bookTitle);
        return ret;
    }
}
