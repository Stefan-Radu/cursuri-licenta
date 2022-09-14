--LABORATOR 6 SQL   
--I.  Limbajul de control al datelor (LCD). COMMIT, SAVEPOINT, ROLLBACK.
--II. Limbajul de prelucrare a datelor (LMD). INSERT, UPDATE, DELETE.

--I. Limbajul de control al datelor (LCD). COMMIT, SAVEPOINT, ROLLBACK.

--1.  Ce efect are urmatoarea secventa de instructiuni?
      CREATE TABLE test_*** AS 
      	SELECT * FROM departments;
        
      SELECT * FROM test_***;

      SAVEPOINT a;

      DELETE FROM test_***;

      INSERT INTO test_*** VALUES (300, 'Economic ',100,1000);

      INSERT INTO  test_*** VALUES (350, 'Cercetare ',200,2000);

      SAVEPOINT b;

      INSERT INTO  test_*** VALUES (400, 'Juritic',150,3000);

      SELECT * FROM  test_***;

      ROLLBACK TO b;

      SELECT * FROM  test_***;
     
      ROLLBACK TO  a;

      INSERT INTO  test_*** 
      VALUES (500, 'Contabilitate',175,1500);
      
      COMMIT;
      
      SELECT * FROM test_***;
 
      DROP TABLE test_***;


--II. Limbajul de prelucrare a datelor (LMD). INSERT, UPDATE, DELETE.

--2. Creati tabele emp_*** si dept_***, avand aceeasi structura si date ca si tabelele employees, respectiv departments.
CREATE TABLE nume_tabel AS subcerere;

--3. Afisati toate inregistrarile din cele doua tabele create anterior.

--4. Stergeti toate inregistrarile din cele 2 tabele create anterior. Salvati modificarile realizate.
DELETE FROM nume_tabel;

--5. Exemplificati cateva dintre erorile care pot sa apara la inserare si observati mesajul intors de sistem.
--    - lipsa de valori pentru coloane NOT NULL (coloana department_name este definita NOT NULL)
INSERT INTO dept_*** (department_id, location_id)
VALUES (200, 2000);

--    -	nepotrivirea listei de coloane cu cea de expresii
INSERT INTO dept_*** 
VALUES (200, 2000);
INSERT INTO dept_*** (department_id, department_name,location_id)
VALUES (200, 2000);

--    -	nepotrivirea tipului de date 
INSERT INTO dept_*** (department_id, location_id)
VALUES ('D23', 2000);

--    -	valoare prea mare pentru coloana
INSERT INTO dept_*** (department_id, location_id)
VALUES (15000, 2000);

--6. Inserati in tabelul emp_*** salariatii (din tabelul employees) al caror comision depaseste 25% din salariu. 

--7. Creati tabelele emp1_***, emp2_*** si emp3_*** cu aceeasi structura ca tabelul employees, dar fara date. 
--   Inserati, utilizand o singura comanda INSERT, informatiile din tabelul employees astfel:
--   -  in tabelul emp1_*** salariatii care au salariul mai mic sau egal decat 6000;
--   -  in tabelul emp2_*** salariatii care au salariul cuprins intre 6000 si 10000;
--   -  in tabelul emp3_*** salariatii care au salariul mai mare sau egal decat 10000.
--   Verificati rezultatele, apoi stergeti toate inregistrarile din aceste tabele.

--8. Creati tabelul emp0_*** cu aceeasi structura ca tabelul employees si fara date. 
--   Inserati, utilizand o singura comanda INSERT, informatiile din tabelul employees astfel:
--   -	in tabelul emp0_*** salariatii care lucreaza in departamentul 80;
--   -	in tabelul emp1_*** salariatii care au salariul mai mic sau egal decat 6000 si nu lucreaza in departamentul 80;
--   -	in tabelul emp2_*** salariatii care au salariul cuprins intre 6001 si 10000 si nu lucreaza in departamentul 80;
--   -	in tabelul emp3_*** salariatii care au salariul mai mare decat 10001 si nu lucreaza in departamentul 80.

--9. Inserati o linie noua in tabelul dept_***, folosind valori introduse de la tastatura.

--10. Inserati o linie noua in tabelul dept_***. Salvati intr-o variabila de legatura codul departamentului nou introdus. Afisati valoarea mentinuta in variabila respectiva. Anulati efectele tranzactiei.

--11.Exemplu de bloc PL/SQL (Facultativ): 
VARIABLE  v_nume VARCHAR2(20)
BEGIN
   SELECT last_name
   INTO   :v_nume
   FROM   employees
   WHERE  employee_id = 100;
END;
/      
PRINT  v_nume

--12. Stergeti toate inregistrarile din tabelele emp_*** si  dept_***. 
--    Inserati in aceste tabele toate inregistrarile corespunzatoare din employees, respectiv departments. Permanentizati tranzactia.

--13. Eliminati departamentele care nu au angajati. Anulati efectele tranzactiei.

--14. Mariti salariul tuturor angajatilor (din tabelul emp_***) cu 5%. Anulati modificarile.

--15. Sa se promoveze Douglas Grant la manager in departamentul 20, avand o crestere de salariu cu 1000$. Anulati efectele tranzactiei.
--16. Modificati jobul si departamentul angajatului avand codul 114, astfel incat sa fie la fel cu cele ale angajatului avand codul 205. 
--    Anulati efectele tranzactiei.
UPDATE emp_*** 
SET (job_id, department_id) = (SELECT job_id, department_id
                               FROM emp_***
                               WHERE employee_id = 205)
WHERE employee_id = 114;
ROLLBACK;

--17. Schimbati salariul si comisionul celui mai prost platit salariat din firma, astfel incat sa fie egale cu salariul ?i comisionul directorului. 
--    Anulati efectele tranzactiei.
UPDATE emp_*** 
SET (salary, commission_pct) = (SELECT salary, commission_pct
                                FROM emp_*** 
                                WHERE manager_id IS NULL)
WHERE salary = (SELECT MIN(salary)
                FROM emp_***);
ROLLBACK;

