package com.library.service;

import com.library.genericIO.Reader;
import com.library.person.Author;
import com.library.person.Librarian;
import com.library.person.Person;
import com.library.person.Client;
import com.library.transaction.Transaction;
import com.library.utils.TransactionType;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public final class PersonService {

    public static PersonService getInstance() {
        if (instance == null) {
            instance = new PersonService();
        }
        return instance;
    }

    private PersonService() {
        this.people = new ArrayList<Person>();

        Reader r = Reader.getInstance();
        ArrayList<ArrayList<String>> data = r.readLines("db/librarians.csv");
        for (ArrayList<String> line : data) {
            Librarian l = new Librarian(line.get(2), line.get(3),
                    Integer.parseInt(line.get(4)), Integer.parseInt(line.get(0)),
                    LocalDate.parse(line.get(1)));
            people.add(l);
        }

        data = r.readLines("db/authors.csv");
        for (ArrayList<String> line : data) {
            Author a = new Author(line.get(0));
            people.add(a);
        }
    }

    private ArrayList<Person> people;
    private static PersonService instance;

    // add new person to the system
    public boolean addPerson(Person person) {
        for (Person p : this.people) {
            if (p.getName().equals(person.getName())) {
                System.err.println("person already exists in the system. can't add.");
                return false;
            }
        }

        this.people.add(person);
        return true;
    }

    // get person object by name
    public Person getByName(String name) {
        for (Person p : people) {
            if (p.getName().equals(name)) {
                return p;
            }
        }
        return null;
    }

    // return list of authors
    public ArrayList<Author> getAuthors() {
        ArrayList<Author> ret = new ArrayList<Author>();

        for (Person p : this.people) {
            if (p instanceof Author) {
                ret.add((Author) p);
            }
        }
        return ret;
    }

    // return list of clients
    public ArrayList<Client> getClients() {
        ArrayList<Client> ret = new ArrayList<Client>();

        for (Person p : this.people) {
            if (p instanceof Client) {
                ret.add((Client) p);
            }
        }
        return ret;
    }

    // return list of librarians
    public ArrayList<Librarian> getLibrarians() {
        ArrayList<Librarian> ret = new ArrayList<Librarian>();

        for (Person p : this.people) {
            if (p instanceof Librarian) {
                ret.add((Librarian) p);
            }
        }
        return ret;
    }
}