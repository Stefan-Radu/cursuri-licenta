package com.library.service;

import com.library.book.Book;
import com.library.genericIO.Reader;
import com.library.genericIO.Writer;
import com.library.person.Person;
import com.library.transaction.Transaction;
import com.library.utils.TransactionType;

import java.time.LocalDate;
import java.util.ArrayList;

public final class TransactionService {

    public static TransactionService getInstance() {
        if (instance == null) {
            instance = new TransactionService();
        }
        return instance;
    }

    private TransactionService() {
        this.transactionHistory = new ArrayList<Transaction>();
        Reader r = Reader.getInstance();
        ArrayList<ArrayList<String>> data = r.readLines("db/transactions.csv");
        for (ArrayList<String> line : data) {
            Transaction t = new Transaction(TransactionType.valueOf(line.get(0)),
                    line.get(2), line.get(3), LocalDate.parse(line.get(1)));
            transactionHistory.add(t);
        }
    }

    private ArrayList<Transaction> transactionHistory;
    private static TransactionService instance;

    public void newTransaction(TransactionType type, Person person, Book book) {
        Transaction t = new Transaction(type, person.getName(), book.getTitle());
        transactionHistory.add(t);

        // add to db
        Writer w = Writer.getInstance();
        w.appendLine("db/transactions.csv",  t.serialize());
    }

    // edit a transaction person & book
    public boolean editTransaction(int id, Person person, Book book) {
        return this.editTransaction(id, person) &&
                this.editTransaction(id, book);
    }

    // edit a transaction person only
    public boolean editTransaction(int id, Person person) {
        if (transactionHistory.size() <= id) {
            System.err.println("invalid transaction id: " + String.valueOf(id));
            return false;
        }
        transactionHistory.get(id).setPersonName(person.getName());

        // update
        Writer w = Writer.getInstance();
        w.clearFile("db/transactions.csv");
        for (Transaction t : transactionHistory) {
            w.appendLine("db/transactions.csv",  t.serialize());
        }

        return true;
    }

    // edit a transaction book only
    public boolean editTransaction(int id, Book book) {
        if (transactionHistory.size() <= id) {
            System.err.println("invalid transaction id: " + String.valueOf(id));
            return false;
        }
        transactionHistory.get(id).setBookTitle(book.getTitle());

        // update
        Writer w = Writer.getInstance();
        w.clearFile("db/transactions.csv");
        for (Transaction t : transactionHistory) {
            w.appendLine("db/transactions.csv",  t.serialize());
        }

        return true;
    }

    public void printHistory() {
        System.out.println("Transaction history:");
        for (int i = 0; i < transactionHistory.size(); ++ i) {
            Transaction transaction = transactionHistory.get(i);
            System.out.println(String.valueOf(i) + ": " +
                    transaction.toString());
        }
        System.out.println("");
    }

    @Override
    public String toString() {
        return "TransactionService{" +
                "transactionHistory=" + transactionHistory.toString() +
                '}';
    }
}
