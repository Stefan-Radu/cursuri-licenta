--LAB4 SQL 

--1. Afisati cel mai mare salariu, cel mai mic salariu, suma si media salariilor tuturor angajatilor. Etichetati coloanele Maxim, Minim, Suma, respectiv Media. 
	
SELECT MIN(salary) min, MAX(salary) max, 
       SUM(salary) suma, ROUND(AVG(salary)) media
FROM   employees;

  
--2. Utilizand functia grup COUNT determinati:
--  a. numarul total de angajati; 
--  b. numarul de angajati care au manager;
--  c. numarul de manageri. 

--3. Afisati diferenta dintre cel mai mare si cel mai mic salariu. Etichetati coloana Diferenta. 

-- 4. a. Selectati data angajarii primei persoane care a fost angajata de companie (tinand cont si de istoricul angajatilor).
--    b. Selectati numele persoanelor care au fost angajate primele in companie.


--5. Afisati numarul de angajati pentru fiecare job.

SELECT job_id, COUNT(employee_id) nr_angajati
FROM   employees
GROUP BY job_id;

--6.Afisati codul departamentului si media salariilor pentru fiecare job din cadrul acestuia.

SELECT department_id, job_id, AVG(salary)
FROM   employees
GROUP BY department_id, job_id;

--7.a. Afisati codul departamentelor pentru care salariul minim depaseste 5000$.

SELECT   department_id, MIN(salary)
FROM     employees
GROUP BY department_id
HAVING MIN(salary)>5000;

--b. Modificati cererea anterioara astfel incat sa afisati numele acestor departamente.  
--c. Modificati cererea anterioara astfel incat sa afisati si orasul in care functioneaza departamentele.

--8. a. Obtineti codul departamentelor si numarul de angajati al acestora pentru departamentele in care lucreaza  cel putin 10 angajati.
--   b.	Cate departamente au cel putin 10 angajati?

SELECT COUNT(COUNT(employee_id))
FROM   employees
GROUP BY department_id
HAVING   COUNT(*) > =10;

--9. Afisati job-ul pentru care salariul mediu este minim.

SELECT job_id  
FROM   employees
GROUP BY job_id
HAVING AVG(salary) = (SELECT MIN(AVG(salary)) 
                      FROM   employees
                      GROUP BY job_id);
                      
                      
--10. a. Afisati codul, numele departamentului si suma salariilor pe departamente.

SELECT d.department_id, department_name,a.suma
FROM   departments d, (SELECT department_id ,SUM(salary) suma 
                       FROM   employees
                       GROUP BY department_id) a
WHERE  d.department_id =a.department_id; 

-- b. Dati o alta metoda de rezolvare a acestei probleme.

--11. a. Scrieti o cerere pentru a afisa numele departamentului, numarul de angajati si salariul mediu pentru angajatii din acel departament. Coloanele vor fi etichetate Departament, Nr. angajati, Salariu Mediu.

SELECT department_name "Departament ", 
       (SELECT COUNT(employee_id) 
        FROM   employees
        WHERE  department_id = d.department_id ) "Nr. angajati",
       (SELECT AVG(salary) 
        FROM   employees
        WHERE  department_id = d.department_id) "Salariu mediu"
FROM   departments d;

-- b. Dati o alta metoda de rezolvare pentru problema anterioara.  

--12.	a. Scrieti o cerere pentru a afisa job-ul, salariul total pentru job-ul respectiv pe departamentele 10, 20 si 30, respectiv salariul total pentru job-ul respectiv pe toate cele 3 departamente. Etichetati coloanele corespunzator. Datele vor fi afisate in urmatoarea forma:
--      Job		Dep10		Dep20		Dep30		Total
--      ---------------------------------------------------
--      J1		10		     5		     25		    40
--      J2		15		     0		     10		    25

SELECT DISTINCT job_id,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id =10 
        GROUP BY job_id) dep10,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id =20 
        GROUP BY job_id) dep20,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id =30 
        GROUP BY job_id) dep30,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id IN (10, 20,30)
        GROUP BY job_id) total
FROM  employees e;

--    b. Clauzele GROUP BY din subcererile anterioare sunt necesare?
--    c. Este necesara o clauza GROUP BY in cererea principala?
--    d. Clauza SELECT a cererii principale trebuie sa utilizeze optiunea DISTINCT?
--    e. Dati o alta metoda de rezolvare utilizand functia DECODE.
--        Indicatie: SUM(DECODE(department_id,10,salary)) 
