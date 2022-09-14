package com.library.book;

import com.library.person.Author;
import com.library.utils.BorrowStatus;
import com.library.utils.Genre;

import java.util.ArrayList;

public class Book {

    public Book(String title, String authorName, int pageCount, Genre genre) {
        this.title = title;
        this.authorName = authorName;
        this.pageCount = pageCount;
        this.genre = genre;
    }

    private final String title;
    private final String authorName;
    private final int pageCount;
    private final Genre genre;

    public String getTitle() {
        return title;
    }

    public String getAuthorName() {
        return authorName;
    }

    public int getPageCount() {
        return pageCount;
    }

    public Genre getGenre() {
        return genre;
    }

    @Override
    public String toString() {
        return "Book{" +
                "title='" + title + '\'' +
                ", authorName='" + authorName + '\'' +
                ", pageCount=" + pageCount +
                ", genre=" + genre +
                '}';
    }

    public ArrayList<String> serialize() {
        ArrayList<String> ret = new ArrayList<String>();
        ret.add(title);
        ret.add(authorName);
        ret.add(String.valueOf(pageCount));
        ret.add(genre.toString());
        return ret;
    }
}
