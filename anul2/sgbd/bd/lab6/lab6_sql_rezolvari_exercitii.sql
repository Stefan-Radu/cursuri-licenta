--LABORATOR 6 SQL   
--I.  Limbajul de control al datelor (LCD). COMMIT, SAVEPOINT, ROLLBACK.
--II. Limbajul de prelucrare a datelor (LMD). INSERT, UPDATE, DELETE, MERGE.

--I. Limbajul de control al datelor (LCD). COMMIT, SAVEPOINT, ROLLBACK.

-- Observatie:
-- Incepand cu acest laborator fiecare dintre noi isi la crea propriile obiecte si va lucra cu acestea
-- Pentru a nu avea probleme atunci cand lucrati in contul comun a grupei fiecare obiect va avea in nume initialele voastre din NUME si PRENUME
-- De exemplu, pentru numele POPESCU OANA => "***" se inlocuiesc in tot fisierul cu "PO" => Popescu Ioana va lucra pe tabele test_po etc

--1. Ce efect are urmatoarea secventa de instructiuni?
      
      --incepe tranzactia T1
      CREATE TABLE test_*** AS         --se creeaza o copie a tabelei departments folosnd comanda CREATE TABLE ... AS SELECT
      	SELECT * FROM departments;     --comanda CREATE este o comanda LDD => incheie tranzactia cu COMMIT => modificarile sunt permanentizate si
                                       --    nu se mai pot anula folosind comanda ROLLBACK;
      --incepe tranzactia T2  
      SELECT * FROM test_***;

      SAVEPOINT a;   --se declara un punct intermediar in tranzactie

      -- delete 1
      DELETE FROM test_***;   -- se sterg toate informatiile din tabela

      -- insert 1
      INSERT INTO test_*** VALUES (300, 'Economic ',100,1000);    -- se adauga o inregistrare in tabela

      -- insert 2
      INSERT INTO  test_*** VALUES (350, 'Cercetare ',200,2000);  -- se adauga alta inregistrare in tabela

      SAVEPOINT b;  --se declara alt punct intermediar in tranzactie

      -- insert 3
      INSERT INTO  test_*** VALUES (400, 'Juritic',150,3000);  -- se adauga alta inregistrare in tabela

      SELECT * FROM  test_***; 

      ROLLBACK TO b;  --se deruleaza inapoi tranzactia pana la punctul intermediar b => insert 3 este anulat

      SELECT * FROM  test_***;  
     
      ROLLBACK TO  a; --se deruleaza inapoi tranzactia pana la punctul intermediar a => delete 1, insert 1 si insert 2 sunt anulate

      --insert 4
      INSERT INTO  test_*** VALUES (500, 'Contabilitate',175,1500);  -- se adauga alta inregistrare in tabela
      
      COMMIT; -- tranzactia 2 se incheie cu COMMIT => insert 4 este permanentizat si vizibi acum din orice alta sesiune
      
      --tranzactie 3
      SELECT * FROM test_***;
 
      DROP TABLE test_***;  --tabela este stearsa 
                            --comanda DROP este o comanda LDD => incheie tranzactia cu COMMIT => modificarile sunt permanentizate si
                            --    nu se mai pot anula folosind comanda ROLLBACK;
     

--II. Limbajul de prelucrare a datelor (LMD). INSERT, UPDATE, DELETE

--2. Creati tabele emp_*** si dept_***, avand aceeasi structura si date ca si tabelele employees, respectiv departments.
--   CREATE TABLE nume_tabel AS subcerere;

create table emp_*** 
as 
select * 
from   employees;

create table dept_*** 
as 
select * 
from   departments;

--3. Afisati toate inregistrarile din cele doua tabele create anterior.

select * 
from   emp_***;

select *
from   dept_***;

--4. Stergeti toate inregistrarile din cele 2 tabele create anterior. Salvati modificarile realizate.
--   DELETE FROM nume_tabel;

delete from emp_***;

delete from dept_***;

commit;

--5. Exemplificati cateva dintre erorile care pot sa apara la inserare si observati mesajul intors de sistem.

--se afiseaza structura tabelei 
describe dept_***  

--	lipsa de valori pentru coloane NOT NULL (coloana department_name este definita NOT NULL)
INSERT INTO dept_*** (department_id, location_id) --coloanele care nu apar in lista sunt populate automat cu valoare null daca nu au setata 
                                                   --    o valoare implicita
VALUES (200, 2000);

--	nepotrivirea listei de coloane cu cea de expresii
INSERT INTO dept_***    --tabela contine mai mult de 2 coloane
VALUES (200, 2000);

INSERT INTO dept_*** (department_id, department_name,location_id)  --se incearca adaugarea a 2 valori pentru 3 coloane
VALUES (200, 2000);

--	nepotrivirea tipului de date 
INSERT INTO dept_*** (department_id, location_id)  --se incearca introducerea unui sir de caractere pe o coloana de tip numeric
VALUES ('D23', 2000);

--	valoare prea mare pentru coloana
INSERT INTO dept_*** (department_id, location_id) --se depaseste dimensiunea maxim admisa
VALUES (15000, 2000);

--6. Inserati in tabelul emp_*** salariatii (din tabelul employees) al caror comision depaseste 25% din salariu. 
insert into emp_***  --inregistrarile intoarse de cerere sunt adaugate in tabela
select * 
from   employees 
where  commission_pct > 0.25;

select *
from   emp_***;

commit;  

-- BONUS cu raspuns trimis pe mail:  
--    Creati doua sesiuni (pot fi pentru acelasi utilizator) si verificati ce date sunt vizibile in tabela pentru fiecare dintre sesiuni
--    inainte si dupa rularea comenzii COMMIT. 
-- Toate raspunsurile aferente laboratorului 6 vor fi incluse intr-un fisier doc de forma nume_prenume_lab6_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

--7. Creati tabelele emp1_***, emp2_*** si emp3_*** cu aceeasi structura ca tabelul employees, dar fara date. Inserati, utilizand o singura comanda INSERT, informatiile din tabelul employees astfel:
--   - in tabelul emp1_*** salariatii care au salariul mai mic sau egal decat 6000;
--   - in tabelul emp2_*** salariatii care au salariul cuprins intre 6000 si 10000;
--   - in tabelul emp3_*** salariatii care au salariul mai mare sau egal decat 10000.
--  Verificati rezultatele, apoi stergeti toate inregistrarile din aceste tabele.

create table emp1_*** as select * from employees where 0=1; --predcatul 0=1 este fals => nicio inregistrare nu va fi intoarsa de comanda SELECT =>
create table emp2_*** as select * from employees where 0=1; --    se creeaza tabele cu aceeasi structura cu employees fara inregistrari in ele
create table emp3_*** as select * from employees where 0=1;

insert all  
   when salary <= 6000 then   
      into emp1_***  
   when salary between 6001 and 10000 then    
      into emp2_***    
   else        
      into emp3_***  
select * from employees; 


select * from emp1_***;
select * from emp2_***;
select * from emp3_***;

rollback;  

-- BONUS cu raspuns trimis pe mail:  
--    In acest caz este eficienta rezolvarea folosind  INSERT ALL? Comentati.
-- Toate raspunsurile aferente laboratorului 6 vor fi incluse intr-un fisier doc de forma nume_prenume_lab6_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

-- BONUS cu raspuns trimis pe mail:  
--    Ce se intampla atunci cand clauza 
--              when salary between 6001 and 10000 then 
--    este inlocuita cu clauza
--              when salary <= 10000 then
-- Toate raspunsurile aferente laboratorului 6 vor fi incluse intr-un fisier doc de forma nume_prenume_lab6_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

-- 8. Creati tabelul emp0_*** cu aceeasi structura ca tabelul employees si fara date. 
--    Inserati, utilizand o singura comanda INSERT, informatiile din tabelul employees astfel:
--    -	in tabelul emp0_*** salariatii care lucreaza in departamentul 80;
--    -	in tabelul emp1_*** salariatii care au salariul mai mic sau egal decat 6000 si nu lucreaza in departamentul 80;
--    -	in tabelul emp2_*** salariatii care au salariul cuprins intre 6001 si 10000 si nu lucreaza in departamentul 80;
--    -	in tabelul emp3_*** salariatii care au salariul mai mare decat 10001 si nu lucreaza in departamentul 80.

create table emp0_*** as select * from employees where 0=1;

insert first
   when department_id = 80 then   
      into emp0_***    
   when salary <= 6000 then   
      into emp1_***  
   when salary <= 10000 then    
      into emp2_***    
   else        
      into emp3_***  
select * from employees; 

select * from emp0_***;
select * from emp1_***;
select * from emp2_***;
select * from emp3_***;

rollback;  

--9. Inserati o linie noua in tabelul dept_***, folosind valori introduse de la tastatura.
describe dept_***

insert into dept_***     
values (&v_dept_id,'&v_dept_name',&v_mgr_id, &v_loc_id); 

select * 
from   dept_***;

rollback;

--sau

-- Atunci cand rulati comenzile de mai jos este indicat sa le includeti toate intr-un nou SQL Worksheet (Alt + F10) si sa le rulati toate odata 
-- cu Run Script (F5)
-- Observatie: in acest mod creati o noua pagina de lucru SQL, nu o sesiune noua; in continuare sunteti in aceeasi sesiune si vedeti datele 
-- modificate in acea sesiune chiar daca nu ati permanentizat modificarile.
-- Puteti obtine acelasi lucru (dar depindeti de versiune softului) daca selectati toate liniile de cod si le rulati toate odata 
--     cu Run Statement (Ctrl + Enter)

undefine v_dept_id
undefine v_dept_name
undefine v_mgr_id
undefine v_loc_id

accept v_dept_id prompt 'Introduceti codul departamentului'    
accept v_dept_name prompt 'Introduceti numele departamentului'
accept v_mgr_id prompt 'Introduceti codul managerului'
accept v_loc_id prompt 'Introduceti codul loatiei'

insert into dept_***     
values (&v_dept_id,'&v_dept_name',&v_mgr_id, &v_loc_id); 

select * 
from   dept_***;

rollback;

--10. Inserati o linie noua in tabelul dept_***. Salvati intr-o variabila de legatura codul departamentului nou introdus. 
-- Afisati valoarea mentinuta in variabila respectiva. Anulati efectele tranzactiei.

-- Atunci cand rulati comenzile de mai jos este indicat sa le includeti toate intr-un nou SQL Worksheet (Alt + F10) si sa le rulati toate odata 
-- cu Run Script(F5)
-- Observatie: in acest mod creati o noua pagina de lucru SQL, nu o sesiune noua; in continuare sunteti in aceeasi sesiune si vedeti datele 
-- modificate in acea sesiune chiar daca nu ati permanentizat modificarile
-- Puteti obtine acelasi lucru (dar depindeti de versiune softului) daca selectati toate liniile de cod si le rulati toate odata 
--     cu Run Statement (Ctrl + Enter)

VARIABLE  h_dept_id NUMBER

INSERT INTO dept_***
VALUES (1,'dept nou',100,1000)
RETURNING department_id INTO :h_dept_id;

PRINT  h_dept_id

--11.Exemplu de bloc PL/SQL (Facultativ): 
-- Atunci cand rulati comenzile de mai jos este indicat sa le includeti toate intr-un nou SQL Worksheet (Alt + F10) si sa le rulati toate odata 
-- cu Run Script(F5)
-- Observatie: in acest mod creati o noua pagina de lucru SQL, nu o sesiune noua; in continuare sunteti in aceeasi sesiune si vedeti datele 
-- modificate in acea sesiune chiar daca nu ati permanentizat modificarile
-- Puteti obtine acelasi lucru (dar depindeti de versiune softului) daca selectati toate liniile de cod si le rulati toate odata 
--     cu Run Statement (Ctrl + Enter)


--se declara o variabila host 
VARIABLE  v_nume VARCHAR2(20) 

--se defineste un bloc PL/SQL
BEGIN
   SELECT last_name    
   INTO   :v_nume      --rezultatul cererii este intors intr-o varibila host (care in interiorul blocului trebui prefixata cu ":")
                       --variabila este scalara => cererea trebuie sa intoarca o singura linie
   FROM   employees
   WHERE  employee_id = 100;  
END;
/

--se afiseaza variabila host
PRINT  v_nume

--12. Stergeti toate inregistrarile din tabelele emp_*** si dept_***. 
-- Inserati in aceste tabele toate inregistrarile corespunzatoare din employees, respectiv departments. Permanentizati tranzactia.
delete from emp_***;
delete from dept_***;
insert into emp_*** select * from employees;
insert into dept_*** select * from departments;
commit;

--13. Eliminati departamentele care nu au angajati. Anulati efectele tranzactiei.
delete from dept_***
where department_id not in (select nvl(department_id,0) from emp_***);  --atentie la valorile null aduse in submultime

rollback;

--14. Mariti salariul tuturor angajatilor (din tabelul emp_***) cu 5%. Anulati modificarile.
update emp_***
set salary = salary * 1.05;

rollback;


--15. Sa se promoveze Douglas Grant la manager in departamentul 20, avand o crestere de salariu cu 1000$. Anulati efectele tranzactiei.
update emp_***
set salary = salary + 1000,
    department_id = 20,
    job_id = 'man_'
where first_name = 'Douglas'
and   last_name = 'Grant';

rollback;

-- BONUS cu raspuns trimis pe mail:  
--  Folosind mai multe comenzi LMD si consultand datele din tabele realizati mai multe modificari implicate de aceasta promovare:
--    - Douglas Grant devine managerul departamentului 20
--    - seful lui Douglas Grant devine Steven King
--    - o noua inregistrare despre Douglas Grant apare in job_history (informatiile corespunzatoare despre jobul sau anterior)
--    - toti angajatii care erau condusi de vechiul manager al departamentului 20 vor fi condusi de Douglas Grant
--    - vechiul manager al departmentului 20 pleca din firma => informatiile despre el sunt sterse din tabela employees si 
--          daca este cazul si din tabele job_history. 
-- Pentru rezolvare trebuie sa aveti definite tabelele copie emp_***, dept_*** si job_history_***.
-- Verificati rezultatul obtinut. Anulati efectele tranzactiei.

  
-- Toate raspunsurile aferente laboratorului 6 vor fi incluse intr-un fisier doc de forma nume_prenume_lab6_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.


--16. Modificati jobul si departamentul angajatului avand codul 114, astfel incat sa fie la fel cu cele ale angajatului avand codul 205. Anulati efectele tranzactiei.
UPDATE emp_*** 
SET (job_id, department_id) = (SELECT job_id, department_id    --subcererea trebuie sa intoarca o singura inregistrare
                               FROM   emp_***
                               WHERE  employee_id = 205)
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


