# PAO-Project - Library
___________

## Classes / Objects

* [x] - Main
* [x] - Person (firstName, lastName, birthDate)
  * [x] - Author (writtenBooks)
  * [x] - Client (rentedBooks, donatedBooks)
  * [x] - Librarian (salary, hireDate)
* [x] - PersonService (people, addPerson, removePerson, showPeople)
* [x] - Book (title, author, pageCount, genre)
* [x] - Transaction (type, date, book, person)
* [x] - TransactionService (transactions, borrowBook, returnBook, showTransactions)
* [x] - LibraryService (books, addBook, removeBook, showBooks...)
  
* [x] - Enum -> Genre (genres)
* [x] - Enum -> BorrowStatus (borrowed, returned)
* [x] - Enum -> TransactionType (borrow, return, donate)

___________

## Functionality 

1. [x] - Add librarian
2. [x] - Print librarians   
3. [x] - Donate a book
    * increment book counter / create book if it does not exist
    * create a new client if not existing
    * add a new transaction
    * add author if it doesn't exist / add title to list
4. [x] - List available books
5. [x] - List authors
6. [x] - List clients
7. [x] - Borrow a book
    * decrease count
    * create a new client if not existing
    * add a new transaction
8. [x] - Return a book
    * increase count
    * add a new transaction
9. [x] - Raise librarian salary
10. [x] - Show transaction history

___________

## CSV persistance

1. [x] - Generic Writer Singleton
2. [x] - Generic Reader Singleton
3. [x] - Persist data for 4 objects
    - [x] Librarian
    - [x] Author
    - [x] Book
    - [x] Transaction
4. [x] - Load persistent data for 4 objects
   - [x] Librarian
   - [x] Author
   - [x] Book
   - [x] Transaction
5. [x] - Logger
