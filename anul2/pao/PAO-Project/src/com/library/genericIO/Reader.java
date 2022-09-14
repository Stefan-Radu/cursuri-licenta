package com.library.genericIO;

import java.io.*;
import java.util.ArrayList;

public class Reader {

    private static Reader instance;

    private Reader() { }

    public static Reader getInstance() {
        if (instance == null) {
            instance = new Reader();
        }
        return instance;
    }

    // read all lines in file
    public static ArrayList<ArrayList<String>> readLines(String path) {
        try {
            File file = new File(path);
            if(!file.exists() || file.isDirectory()) {
                return null;
            }

            FileReader f = new FileReader(file);
            BufferedReader br = new BufferedReader(f);

            String line;
            ArrayList<ArrayList<String>> ret = new ArrayList<ArrayList<String>>();
            while ((line = br.readLine()) != null) {
                ArrayList<String> arrLine = new ArrayList<String>();
                String[] split = line.split(",");
                for (String s: split) {
                    arrLine.add(s);
                }
                ret.add(arrLine);
            }
            br.close();
            return ret;
        }
        catch (IOException e) {
            System.out.println("Error when opening file.");
            e.printStackTrace();
            return null;
        }
    }
}
