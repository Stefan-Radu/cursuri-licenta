package com.library.person;

import java.time.LocalDate;
import java.util.ArrayList;

public class Librarian extends Person {

    public Librarian(String name, String email, int _age,
                     int salary, LocalDate hireDate) {
        super(name, email, _age);
        this.salary = salary;
        this.hireDate = hireDate;
    }

    private int salary;
    private LocalDate hireDate;

    public int getSalary() {
        return salary;
    }

    public void setSalary(int salary) {
        this.salary = salary;
    }

    public LocalDate getHireDate() {
        return hireDate;
    }

    @Override
    public String toString() {
        return "Librarian{" +
                "salary=" + salary +
                ", hireDate=" + hireDate +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", age=" + age +
                '}';
    }

    public ArrayList<String> serialize() {
        ArrayList<String> ret = new ArrayList<String>();
        ret.add(String.valueOf(salary));
        ret.add(hireDate.toString());
        ret.add(name);
        ret.add(email);
        ret.add(String.valueOf(age));
        return ret;
    }
}
