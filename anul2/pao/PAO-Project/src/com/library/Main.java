package com.library;

import com.library.service.LibraryService;

import java.io.IOException;
import java.util.Scanner;

public class Main {

    private static void printOptions() {
        System.out.println("The Library: \n" +
                "1. Add a new librarian to the platform.\n" +
                "2. List librarians.\n" +
                "3. Donate a book.\n" +
                "4. List available books.\n" +
                "5. List authors.\n" +
                "6. List clients.\n" +
                "7. Borrow book.\n" +
                "8. Return book.\n" +
                "9. Raise librarian salary.\n" +
                "10. Show transaction history.\n" +
                "\n"
        );
    }

    public static void main(String[] args) throws IOException, InterruptedException {

        LibraryService service = LibraryService.getInstace();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            printOptions();

            int id = scanner.nextInt();
            switch (id) {
                case 1:
                    service.addLibrarian();
                    break;
                case 2:
                    service.printLibrarianList();
                    break;
                case 3:
                    service.donateBook();
                    break;
                case 4:
                    service.printAvailableBooks();
                    break;
                case 5:
                    service.printAuthorList();
                    break;
                case 6:
                    service.printClientList();
                    break;
                case 7:
                    service.borrowBook();
                    break;
                case 8:
                    service.returnBook();
                    break;
                case 9:
                    service.raiseLibrarianSalary();
                    break;
                case 10:
                    service.printTransactionHistory();
                    break;
                default:
                    System.out.println("option out of range. exiting...");
                    Thread.sleep(1000);
                    System.out.println("\nbye\n");
                    return;
            }

            Runtime.getRuntime().exec("clear");
            scanner.nextLine();
        }
    }
}
