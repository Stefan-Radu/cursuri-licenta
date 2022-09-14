package com.library.genericIO;

import java.io.*;
import java.util.ArrayList;

public class Writer {
    private static Writer instance;

    private Writer() { }

    public static Writer getInstance() {
        if (instance == null) {
            instance = new Writer();
        }
        return instance;
    }

    // empty file contents
    public static void clearFile(String path) {
        try {
            FileWriter w = new FileWriter(path, false);
            w.close();
        } catch (IOException e) {
            System.out.println("Error when opening file.");
            e.printStackTrace();
        }
    }

    // append line to file
    public static void appendLine(String path, ArrayList<String> line) {
        try {
            FileWriter w = new FileWriter(path, true);
            BufferedWriter bw = new BufferedWriter(w);
            for (String s : line) {
                bw.write(s);
                bw.write(",");
            }
            bw.newLine();
            bw.close();
        }
        catch (IOException e) {
            System.out.println("Error when opening file.");
            e.printStackTrace();
        }
    }
}
