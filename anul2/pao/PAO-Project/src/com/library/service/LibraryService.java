package com.library.service;

import com.library.book.Book;
import com.library.genericIO.Reader;
import com.library.genericIO.Writer;
import com.library.person.Author;
import com.library.person.Client;
import com.library.person.Librarian;
import com.library.utils.Genre;
import com.library.utils.TransactionType;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.util.*;

public final class LibraryService {

    public static LibraryService getInstace() {
        if (instance == null) {
            instance = new LibraryService();
        }
        return instance;
    }

    private LibraryService() {
        personService = PersonService.getInstance();
        transactionService = TransactionService.getInstance();

        booksAvailable = new HashMap<Book, Integer>();

        Reader r = Reader.getInstance();
        ArrayList<ArrayList<String>> data = r.readLines("db/books.csv");
        for (ArrayList<String> line : data) {
            Book book = new Book(line.get(0), line.get(1),
                    Integer.parseInt(line.get(2)), Genre.valueOf(line.get(3)));
            if (booksAvailable.containsKey(book)) {
                int count = booksAvailable.get(book);
                booksAvailable.put(book, count + 1);
            } else {
                booksAvailable.put(book, 1);
            }

            Author author = (Author) personService.getByName(line.get(1));
            author.addBook(line.get(0));
        }

    }

    private static LibraryService instance;

    private TransactionService transactionService;
    private PersonService personService;
    private HashMap<Book, Integer> booksAvailable;

    // add a new librarian to the system
    public void addLibrarian() {
        try {
            LocalDate now = LocalDate.now();

            Scanner sc = new Scanner(System.in);
            System.out.println("Librarian name: ");
            String name = sc.nextLine();
            System.out.println(name);
            System.out.println("Librarian email: ");
            String email = sc.nextLine();
            System.out.println(email);
            System.out.println("Librarian age: ");
            int age = sc.nextInt();
            System.out.println(age);
            System.out.println("Librarian salary: ");
            int salary = sc.nextInt();
            System.out.println(salary);

            Librarian librarian = new Librarian(name, email, age, salary, now);
            personService.addPerson(librarian);
            System.out.println(name + " added\n");

            // add to DB
            Writer genericWriter = Writer.getInstance();
            genericWriter.appendLine("db/librarians.csv",
                    librarian.serialize());

            ArrayList<String> line = new ArrayList<String>();
            line.add("ADD_LIBRARIAN");
            line.add(Timestamp.from(Instant.now()).toString());
            genericWriter.appendLine("db/logs.csv", line);

        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    // print list of librarians
    public void printLibrarianList() {
        ArrayList<Librarian> list = personService.getLibrarians();
        for (int i = 0; i < list.size(); ++ i) {
            Librarian lib = list.get(i);
            System.out.println(String.valueOf(i) + ": " + lib.toString());
        }

        Writer genericWriter = Writer.getInstance();
        ArrayList<String> line = new ArrayList<String>();
        line.add("PRINT_LIBRARIAN_LIST");
        line.add(Timestamp.from(Instant.now()).toString());
        genericWriter.appendLine("db/logs.csv", line);
    }

    private Genre genreInput() {
        try {
            Scanner sc = new Scanner(System.in);

            System.out.println("Genre. Select one if from the following:\n" +
                    "0: ADVENTURE\n" +
                    "1: FANTASY\n" +
                    "2: HORROR\n" +
                    "3: ROMANCE\n" +
                    "4: SCIENCE_FICTION\n");

            int id = sc.nextInt();
            if (id == 0) {
                return Genre.ADVENTURE;
            } else if (id == 1) {
                return Genre.FANTASY;
            } else if (id == 2) {
                return Genre.HORROR;
            } else if (id == 3) {
                return Genre.ROMANCE;
            } else if (id == 4) {
                return Genre.SCIENCE_FICTION;
            } else {
                throw new IOException("wrong id value");
            }
        } catch (Exception e) {
            System.err.println(e.toString());
        }
        return null;
    }

    public void donateBook() {
        try {
            Scanner sc = new Scanner(System.in);

            System.out.println("Book title: ");
            String title = sc.nextLine();
            System.out.println(title);
            System.out.println("Author name: ");
            String authorName = sc.nextLine();
            System.out.println(authorName);
            System.out.println("Page count: ");
            int pageCount = sc.nextInt();
            System.out.println(pageCount);
            Genre genre = genreInput();
            System.out.println(genre);
            sc.nextLine();
            System.out.println("Donor name: ");
            String donorName = sc.nextLine();
            System.out.println(donorName);
            System.out.println("Donor email: ");
            String donorEmail = sc.nextLine();
            System.out.println(donorEmail);

            Book book = new Book(title, authorName, pageCount, genre);
            if (booksAvailable.containsKey(book)) {
                int count = booksAvailable.get(book);
                booksAvailable.put(book, count + 1);
            } else {
                booksAvailable.put(book, 1);
            }

            Writer w = Writer.getInstance();
            w.appendLine("db/books.csv",  book.serialize());

            Author author = (Author) personService.getByName(authorName);
            if (author == null) {
                author = new Author(authorName);
                personService.addPerson(author);
                System.out.println(author.serialize());
                w.appendLine("db/authors.csv",  author.serialize());
            }
            author.addBook(title);

            Client client = (Client) personService.getByName(donorName);
            if (client == null) {
                client = new Client(donorName, donorEmail);
                personService.addPerson(client);
            }
            client.donateBook(title);

            transactionService.newTransaction(TransactionType.DONATION, client, book);

            ArrayList<String> line = new ArrayList<String>();
            line.add("PRINT_LIBRARIAN_LIST");
            line.add(Timestamp.from(Instant.now()).toString());
            w.appendLine("db/logs.csv", line);
        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    // get list of books available for rental
    private ArrayList<Book> getAvailableBooksByTitle(String bookTitle) {
       ArrayList<Book> ret = new ArrayList<>();
       for (Book book : booksAvailable.keySet()) {
           if (book.getTitle() != bookTitle) continue;
           if (booksAvailable.get(book) == 0) continue;
           ret.add(book);
       }
       return ret;
    }

    // get available books
    private ArrayList<Book> getAvailableBooks() {
        ArrayList<Book> ret = new ArrayList<>();
        for (Book book : booksAvailable.keySet()) {
            if (booksAvailable.get(book) == 0) continue;
            ret.add(book);
        }
        return ret;
    }

    // print available books
    public void printAvailableBooks() {
        ArrayList<Book> list = getAvailableBooks();
        for (int i = 0; i < list.size(); ++ i) {
            Book book = list.get(i);
            System.out.println(String.valueOf(i) + ": " +
                    book.toString());
        }
        System.out.println();

        Writer genericWriter = Writer.getInstance();
        ArrayList<String> line = new ArrayList<String>();
        line.add("PRINT_AVAILABLE_BOOKS");
        line.add(Timestamp.from(Instant.now()).toString());
        genericWriter.appendLine("db/logs.csv", line);
    }

    public void printAvailableBooks(ArrayList<Book> list) {
        for (int i = 0; i < list.size(); ++ i) {
            Book book = list.get(i);
            System.out.println(String.valueOf(i) + ": " +
                    book.toString());
        }
        System.out.println();

        Writer genericWriter = Writer.getInstance();
        ArrayList<String> line = new ArrayList<String>();
        line.add("PRINT_AVAILABLE_BOOKS");
        line.add(Timestamp.from(Instant.now()).toString());
        genericWriter.appendLine("db/logs.csv", line);
    }

    // print list of clients
    public void printClientList() {
        ArrayList<Client> list = personService.getClients();
        for (int i = 0; i < list.size(); ++ i) {
            Client client = list.get(i);
            System.out.println(String.valueOf(i) + ": " + client.toString());
        }

        Writer genericWriter = Writer.getInstance();
        ArrayList<String> line = new ArrayList<String>();
        line.add("PRINT_CLIENT_LIST");
        line.add(Timestamp.from(Instant.now()).toString());
        genericWriter.appendLine("db/logs.csv", line);
    }

    // print list of authors
    public void printAuthorList() {
        ArrayList<Author> list = personService.getAuthors();
        for (int i = 0; i < list.size(); ++ i) {
            Author author = list.get(i);
            System.out.println(String.valueOf(i) + ": " + author.toString());
        }

        Writer genericWriter = Writer.getInstance();
        ArrayList<String> line = new ArrayList<String>();
        line.add("PRINT_AUTHOR_LIST");
        line.add(Timestamp.from(Instant.now()).toString());
        genericWriter.appendLine("db/logs.csv", line);
    }

    // output list of books and return selected by id
    private Book selectBookById() {
        try {
            Scanner sc = new Scanner(System.in);
            System.out.println("Input ONE book id:\n");
            printAvailableBooks();
            int id = sc.nextInt();

            ArrayList<Book> availableBooks = getAvailableBooks();
            return availableBooks.get(id);
        } catch (Exception e) {
            System.err.println(e.toString());
        }
        return null;
    }

    public void borrowBook() {
        try {
            Scanner sc = new Scanner(System.in);

            System.out.println("Client name: ");
            String clientName = sc.nextLine();
            System.out.println(clientName);
            System.out.println("Client email: ");
            String clientEmail = sc.nextLine();
            System.out.println(clientEmail);
            Book book = selectBookById();
            System.out.println(book.toString());

            // update client
            Client client = (Client) personService.getByName(clientName);
            if (client == null) {
                client = new Client(clientName, clientEmail);
                personService.addPerson(client);
            }
            client.borrowBook(book);

            // update count
            int count = booksAvailable.get(book);
            booksAvailable.put(book, count - 1);

            transactionService.newTransaction(TransactionType.BORROWING, client, book);

            Writer genericWriter = Writer.getInstance();
            ArrayList<String> line = new ArrayList<String>();
            line.add("BORROW_BOOK");
            line.add(Timestamp.from(Instant.now()).toString());
            genericWriter.appendLine("db/logs.csv", line);
        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    // return a borrowed book
    public void returnBook() {
        try {
            Scanner sc = new Scanner(System.in);

            System.out.println("Client name: ");
            String clientName = sc.nextLine();
            System.out.println(clientName);
            System.out.println("Client email: ");
            String clientEmail = sc.nextLine();
            System.out.println(clientEmail);

            // get client
            Client client = (Client) personService.getByName(clientName);
            if (client == null) {
                System.err.println("Client does not exist\n");
            }
            ArrayList<Book> borrowedBooks = client.getBorrowedBooks();
            if (borrowedBooks.size() == 0) {
                System.err.println("Client has no books borrowed\n");
                return;
            }

            System.out.println("Input ONE book id:\n");
            printAvailableBooks(borrowedBooks);
            int id = sc.nextInt();
            if (id < 0 || id > borrowedBooks.size()) {
                System.err.println("Bad id - out of range\n");
                return;
            }

            // return
            Book book = borrowedBooks.get(id);
            client.returnBook(book);

            // update count
            int count = booksAvailable.get(book);
            booksAvailable.put(book, count + 1);

            transactionService.newTransaction(TransactionType.RETURN, client, book);

            Writer genericWriter = Writer.getInstance();
            ArrayList<String> line = new ArrayList<String>();
            line.add("RETURN_BOOK");
            line.add(Timestamp.from(Instant.now()).toString());
            genericWriter.appendLine("db/logs.csv", line);
        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    public void raiseLibrarianSalary() {
        try {
            Scanner sc = new Scanner(System.in);
            ArrayList<Librarian> list = personService.getLibrarians();

            System.out.println("Input ONE book id:\n");
            for (int i = 0; i < list.size(); ++i) {
                Librarian lib = list.get(i);
                System.out.println(String.valueOf(i) + ": " +
                        lib.toString());
            }
            int id = sc.nextInt();
            if (id < 0 || id > list.size()) {
                System.err.println("Bad id - out of range\n");
                return;
            }

            Librarian lib = list.get(id);
            System.out.println("Increase amount: ");
            int amount = sc.nextInt();
            if (amount <= 0) {
                System.err.println("Non positive amount entered.\n");
                return;
            }

            lib.setSalary(lib.getSalary() + amount);
            System.out.println("New salary: " + String.valueOf(lib.getSalary()));

            // update librarians in db
            Writer genericWriter = Writer.getInstance();
            genericWriter.clearFile("db/librarians.csv");
            for (Librarian l : list) {
                genericWriter.appendLine("db/librarians.csv", l.serialize());
            }

            ArrayList<String> line = new ArrayList<String>();
            line.add("RAISE_LIBRARIAN_SALARY");
            line.add(Timestamp.from(Instant.now()).toString());
            genericWriter.appendLine("db/logs.csv", line);
        } catch (Exception e) {
            System.err.println(e.toString());
        }
    }

    public void printTransactionHistory() {
        transactionService.printHistory();

        Writer genericWriter = Writer.getInstance();
        ArrayList<String> line = new ArrayList<String>();
        line.add("PRINT_TRANSACTION_HISTORY");
        line.add(Timestamp.from(Instant.now()).toString());
        genericWriter.appendLine("db/logs.csv", line);
    }
}
