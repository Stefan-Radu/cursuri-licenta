-- LABORATOR 5 SQL   

--1. Afisati numele departamentelor pentru care suma alocata salariilor depaseste valoare medie alocata pe departamente.
--Varianta 1
    WITH
    dept_costuri AS (
            SELECT department_name, SUM(salary) dept_cost
            FROM   employees e, departments d
            WHERE  e.department_id= d.department_id
            GROUP BY department_name)
    SELECT *
    FROM   dept_costuri
    WHERE  dept_cost > (select avg(dept_cost) from dept_costuri) 
    ORDER BY department_name;
    
--Varianta 2
    WITH 
    dept_costuri AS (
            SELECT department_name, SUM(salary) dept_cost
            FROM   employees e, departments d
            WHERE  e.department_id= d.department_id
            GROUP BY department_name),
    medie_cost AS (
            SELECT AVG(dept_cost) medie
            FROM   dept_costuri)
    SELECT *  
    FROM   dept_costuri, medie_cost
    WHERE  dept_cost > medie 
    ORDER BY department_name;

--2. Dati o metoda de rezolvare a cererii anterioare fara sa utilizati clauza WITH. Verificati rezultatul obtinut. Comentati.
--3. Modificati cererea anterioara astfel incat sa obtineti acelasi rezultat ca in cazul punctului 1.
--4. Modificati cererile de la punctul 1 astfel incat sa obtineti acelasi rezultat ca in cazul punctului 2.

--5. Obtineti numele primilor 5 angajati care au cel mai mare salariul (top 5 angajati in functie de salariu). 
--   Studiati cele doua alternative de rezolvare. Rezultatul obtinut va fi mereu acelasi indiferent de varianta aleasa?
--Varianta1
SELECT last_name, job_id, salary     
FROM  employees e
WHERE 5>=(SELECT COUNT(*) 
          FROM   employees
          WHERE  salary > e.salary)
ORDER BY salary DESC;

--Varianta2
SELECT  *     
FROM  (SELECT last_name, job_id, salary  
         FROM   employees
         ORDER BY salary DESC) 
  WHERE ROWNUM<=5;

--6. Afisati numele, job-ul si salariul celor mai prost platiti angajati din fiecare departament.
-- Fara sincronizare   
	SELECT last_name, salary, job_id, department_id  
	FROM   employees
	WHERE (department_id, salary) IN (SELECT department_id, MIN(salary) 
                                  	  FROM   employees 
                                     GROUP BY department_id);
-- Cu sincronizare
	SELECT last_name, salary, job_id, department_id  
	FROM   employees e
	WHERE  salary = (SELECT MIN(salary) 
                    FROM   employees 
                    WHERE  department_id=e.department_id);
                    
--7. Obtineti pentru fiecare job, numele si salariul angajatilor care sunt cel mai bine platiti pe jobul respectiv. Rezolvati problema cu sincronizare si fara sincronizare.

--8. Modificati cererea anterioara astfel incat sa afisati pentru fiecare job top 3 angajati din punct de vedere al salariului primit.

--9. Obtineti codurile si numele departamentelor in care nu lucreaza nimeni. Pentru rezolvare utilizati operatorul NOT IN.

--10. Folosind operatorul ALL, afisati angajatii care castiga mai mult decat oricare functionar (CLERK). Ce rezultat este obtinut daca se inlocuieste ALL cu ANY? 

--11. Afisati numele si salariul angajatilor al caror salariu este mai mare decat salariile medii din toate departamentele. Rezolvati problema in doua variante.

--12. Obtineti numarul total de angajati ai companiei, respectiv numarul celor care au fost angajati in anul 1997. Afisati informatiile cerute in urmatoarea forma:
--    a) pe linii (rezultatul va contine doua linii si o coloana);
--       Indicatie: Utilizati operatorul UNION.
--       NUMAR                                               
--       ---------------- 
--       Numar total: 107  
--       Numar 1997:  28
--    b) pe coloane (rezultatul va contine doua coloane si o linie).
--       Numar total            Numar 1997             
--       --------------------- ---------------------- 
--       107                    28
                   
--13. Pentru fiecare angajat obtineti urmatoarele informatii despre job-ul prezent, respectiv joburile sale anterioare: numele job-ului, 
--    numele departamentului, respectiv data la care a inceput sa lucreze pe job-ul respectiv. Ordonati rezultatul dupa codul angajatului.  

--14. Folosind operatorul INTERSECT, obtineti angajatii care au salariul cel mult 3000 si lucreaza in departamentul 50.

SELECT employee_id, last_name
FROM   employees 
WHERE  salary<3000
INTERSECT
SELECT employee_id, last_name
FROM   employees 
WHERE  department_id = 50;

--15. Obtineti codul, job-ul si departamentul angajatilor care in trecut au mai lucrat pe acelasi job si in acelasi departament ca in prezent. 
--    Utilizati operatorul INTERSECT.

--16. Modificati cererea anterioara astfel incat sa obtineti numele angajatilor care indeplinesc conditia impusa.

--17. Afisati codurile departamentelor care nu au angajati, implementand operatorul MINUS.
SELECT department_id   
FROM   departments      
MINUS
SELECT DISTINCT department_id   
FROM   employees;

--18. Determinati numele si codul angajatilor care castiga mai mult decat angajatul avand codul 200. 
-- Varianta 1 - Forma relationala 
SELECT a.employee_id, a.last_name
FROM   employees a, employees b
WHERE  a.salary > b.salary 
AND    b.employee_id = 200;

-- Varianta 2 - Forma procedurala
SELECT employee_id, last_name
FROM   employees e
WHERE  EXISTS (SELECT 1
               FROM   employees 		
               WHERE  employee_id = 200 
               AND    e.salary >salary);

--19. Dati o alta metoda de rezolvare pentru problema anterioara, utilizand subcereri si operatorul „>”.

--20. Folosind operatorul EXISTS determinati numele departamentelor in care lucreaza cel putin un angajat.
SELECT department_id, department_name
FROM   departments d
WHERE  EXISTS (SELECT 'x'
               FROM   employees
               WHERE  department_id = d.department_id);
               
--21.	Dati o alta metoda de rezolvare pentru problema anterioara, utilizand subcereri si operatorul IN.



