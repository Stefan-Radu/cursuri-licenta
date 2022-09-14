-- LABORATOR 5 SQL   

--1. Afisati numele departamentelor pentru care suma alocata salariilor depaseste valoare medie alocata pe departamente.
--Varianta 1
    WITH 
    dept_costuri AS (                                           --dept_costuri este folosita ca si cand af fi fost o tabela specificata in clauza FROM
            SELECT department_name, SUM(salary) dept_cost       
            FROM   employees e, departments d
            WHERE  e.department_id= d.department_id
            GROUP BY department_name)
    SELECT *
    FROM   dept_costuri                                         -- este utila atunci cand cererea principala utilizeaza de mai multe ori subcererea
    WHERE  dept_cost > (select avg(dept_cost) from dept_costuri) 
    ORDER BY department_name;
   
    
--Varianta 2
    WITH 
    dept_costuri AS (                                          --clauza WITH permite precizarea mai multor "tabele in-line" ce vor fi utilizate 
            SELECT department_name, SUM(salary) dept_cost      --    in cererea principala de care depinde clauza WITH
            FROM   employees e, departments d
            WHERE  e.department_id= d.department_id
            GROUP BY department_name),
    medie_cost AS (
            SELECT round(AVG(dept_cost)) medie
            FROM   dept_costuri)
    SELECT *  
    FROM   dept_costuri, medie_cost
    WHERE  dept_cost > medie 
    ORDER BY department_name;

--2. Dati o metoda de rezolvare a cererii anterioare fara sa utilizati clauza WITH. Verificati rezultatul obtinut. Comentati.

-- varianta 1
-- se obtine acelasi rezultat ca la exercitiul 1
    SELECT *
    FROM   (SELECT department_name, SUM(salary) dept_cost        --se utilizeaza subcererea in clauza FROM
            FROM   employees e, departments d 
            WHERE  e.department_id= d.department_id
            GROUP BY department_name) dept_costuri                                        
    WHERE  dept_cost > (select avg(dept_cost) 
                        from   (SELECT department_name, SUM(salary) dept_cost       
                                FROM   employees e, departments d
                                WHERE  e.department_id= d.department_id
                                GROUP BY department_name) dept_costuri)  
    ORDER BY department_name;

--varianta 2
-- nu se obtine acelasi rezulat!

-- BONUS cu raspuns trimis pe mail:  
--     De ce nu se obtine acelasi rezultat ca in cazul celor doua cereri anterioare?
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

select department_name, sum(salary),round(avg(salary))
from departments d, employees e
where d.department_id = e.department_id
group by department_name
having sum(salary)>(select avg(sum(salary))   --suma alocata salariilor depaseste valoare medie alocata pe departamente
                    from employees
                    group by department_id);
                    
--3. Modificati cererea anterioara astfel incat sa obtineti acelasi rezultat ca in cazul punctului 1.

-- BONUS cu raspuns trimis pe mail:  
--     In subcererea din lista SELECT este necesara utilizarea conditiei de JOIN si gruparea dupa department_name?
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

select department_name, sum(salary),round(avg(salary)),
       (select round(avg(sum(salary)))                     -- subcererea apare in lista SELECT
        from   employees e, departments d                  
        where  e.department_id = d.department_id
        group by department_name) media
from  departments d, employees e
where d.department_id = e.department_id
group by department_name
having sum(salary)>(select  avg(sum(salary))                  
                    from    employees e, departments d
                    where   e.department_id = d.department_id
                    group by department_name);

--4. Modificati cererile de la punctul 1 astfel incat sa obtineti acelasi rezultat ca in cazul punctului 2.

-- BONUS cu raspuns trimis pe mail:  
--     De ce este necesara conditia de outer-join in subcererea din clauza WITH?
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

with    
dept_costuri as (     
         select department_name, sum(salary) dept_cost 
         from   employees e, departments d          
         where  e.department_id= d.department_id(+)      
         group by department_name),     
medie_cost as (          
         select round(avg(dept_cost)) medie         
         from   dept_costuri)    
select *     
from   dept_costuri, medie_cost   
where  dept_cost > medie    
order by department_name;

--5. Obtineti numele primilor 5 angajati care au cel mai mare salariul (top 5 angajati in functie de salariu). 
--   Studiati cele doua alternative de rezolvare. Rezultatul obtinut va fi mereu acelasi indiferent de varianta aleasa?

--Varianta1
SELECT last_name, job_id, salary    
FROM   employees e
WHERE  5>=(SELECT COUNT(*)             -- se numara cati salariati au salariul mai mare decat cel de pe linia curenta        
           FROM   employees            -- daca numarul este mai mic sau egal cu 5 => se afla in top 5 si este afisata
           WHERE  salary > e.salary)   -- subcererea este sincronizata cu cererea principala => se executa pentru fiecare inregistrare intoarsa de
ORDER BY salary DESC;                 --     cererea principala

-- este afisat si numarul de ordine al inregistrarii
SELECT rownum, last_name, job_id, salary   --rownum este o pseudocoloana care mentine numarul curent al inregistrarii intoarse de cerere 
FROM   employees e
WHERE  5>=(SELECT  COUNT(*)             -- se numara cati salariati au salariul mai mare decat cel de pe linia curenta        
           FROM    employees            -- daca numarul este mai mic sau egal cu 5 => se afla in top 5 si este afisata
           WHERE   salary > e.salary)   -- subcererea este sincronizata cu cererea principala => se executa pentru fiecare inregistrare intoarsa de
ORDER BY salary DESC;   


-- BONUS cu raspuns trimis pe mail:  
--     Gasiti o modalitate prin care sa precizati si pozitia din top pentru fiecare inregistrare.?
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

--Varianta2
SELECT  *     
FROM  (SELECT last_name, job_id, salary  
       FROM   employees
       ORDER BY salary DESC) 
WHERE ROWNUM<=5;

-- Observatie 1: 
-- Cele doua cereri nu obtin acelasi rezultat mereu.
-- Prima cerere intoarce mereu topul (2 inregistrari cu aceeasi valoare sunt pe aceesi pozitie in top), 
--     iar a doua cerere limiteaza rezultatul la un numar fix de linii fara a utiliza alt criteriu

-- Observatie 2:
-- cererea urmatoare obtine rezultat eronat
-- se obtin primele 5 inregistrari din tabela si apoi se ordoneaza rezultatul descendent dupa salariu

SELECT rownum, last_name, job_id, salary  
FROM   employees
WHERE ROWNUM<=5
ORDER BY salary DESC; 

-- Observatie 3:
-- Pentru a intelege mai bine cand se aplica ROWNUM rulati si urmariti rezultatele urmatoarelor cereri.
select rownum, last_name, salary
from   employees;

select rownum, last_name, salary
from   employees
order by salary desc;

select rownum, last_name, salary
from employees
where rownum<=5
order by salary desc;

select *
from (select last_name, job_id, salary
      from employees
      order by salary desc)
where rownum<=5;

select rownum, last_name, salary
from  employees
where rownum=1; --merge

select rownum, last_name, salary
from   employees
where  rownum between 3 and 5; --nu merge; puteti utiliza doar ROWNUM=1 sau ROWNUM < x sau ROWNUM <= x

select rownum, last_name, salary
from   employees
where  rownum >= 5; --nu merge; puteti utiliza doar ROWNUM=1 sau ROWNUM < x sau ROWNUM <= x

-- BONUS cu raspuns trimis pe mail:  
--     Cum se poate obtine echivalentul pentru ROWNUM BETWEEN 3 AND 5 sau pentru ROWNUM >= 5?
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.

--6. Afisati numele, job-ul si salariul celor mai prost platiti angajati din fiecare departament.
-- Fara sincronizare   
	SELECT last_name, salary, job_id, department_id  
	FROM   employees
	WHERE (department_id, salary) IN (SELECT department_id, MIN(salary)   --subcererea se executa o singura data
                                  	  FROM   employees                    --datorita utilizarii perechii (department_id, salary) nu este nevoie 
                                      GROUP BY department_id);            --    de sincronizarea dintre subcerere cu cererea principala
-- Cu sincronizare
	SELECT last_name, salary, job_id, department_id  
	FROM   employees e 
	WHERE  salary = (SELECT MIN(salary)    --subcererea este sincronizata cu cererea principala => se executa pentru fiecare inregistrare
                     FROM   employees      --    intoarsa de cererea principala
                     WHERE  department_id=e.department_id);


--7. Obtineti pentru fiecare job, numele si salariul angajatilor care sunt cel mai bine platiti pe jobul respectiv.
--   Rezolvati problema cu sincronizare si fara sincronizare.

--fara sincronizare
select job_id, last_name, salary
from   employees
where (job_id, salary) in (select job_id, max(salary)  --angajatii cel mai bine platiti pe jobul lor au cel mai mare salariu acordat angajatilor 
                           from   employees            --    care lucreaza pe acel job
                           group by job_id)
order by job_id;
                           
--cu sincronizare
select job_id, last_name, salary
from   employees e
where  salary = (select max(salary)  
                 from   employees
                 where  job_id=e.job_id);  -- condiitia de sincronizare cu cererea principala

--8. Modificati cererea anterioara astfel incat sa afisati pentru fiecare job top 3 angajati din punct de vedere al salariului primit.
select job_id, last_name, salary
from   employees e
where  3>=(select count(*)
           from   employees
           where  job_id=e.job_id and salary>e.salary)
order by job_id, salary desc;

--9. Obtineti codurile si numele departamentelor in care nu lucreaza nimeni. Pentru rezolvare utilizati operatorul NOT IN.
select department_id, department_name
from   departments
where  department_id not in (select nvl(department_id,0)  -- atentie la  subcererile care intorc si valori null
                             from employees);

--verificati rezultatul urmatoarelor cereri
select department_id, department_name
from   departments
where  department_id not in (select department_id  -- atentie la  subcererile care intorc si valori null
                             from   employees);
                             
select department_id, department_name
from departments
--where department_id in (10,null)                   --cele 2 predicate sunt echivalente
where department_id = 10 or department_id = null;    --al doilea predicat este "not true"

select department_id, department_name
from departments
where department_id = 10 or department_id is null;


select department_id, department_name
from departments
--where department_id not in (10,null)                --cele 2 predicate sunt echivalente
where department_id <> 10 and department_id <> null;  --al doilea predicat este "not true"
                             
select department_id, department_name
from departments
where department_id <> 10 and department_id is not null;  --al doilea predicat este inutil pentru ca prima contitie il include deoarece "null<>10" 
                                                          --   este "not true"
select department_id, department_name
from departments
where department_id <> 10; 

--10. Folosind operatorul ALL, afisati angajatii care castiga mai mult decat oricare functionar (CLERK). 
--    Ce rezultat este obtinut daca se inlocuieste ALL cu ANY? 

select last_name, job_id
from   employees
where  salary > all (select salary                       -- >all = mai mare decat toate elementele din multime
                    from employees
                    where job_id like upper('%clerk'));

-- cerere echivalenta
select last_name, job_id
from   employees
where  salary >    (select max(salary)                       
                    from employees
                    where job_id like upper('%clerk'));
                    
                    
-- BONUS cu raspuns trimis pe mail:  
--     Care dintre cele doua variante este recomandata/optima? 
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii.                    
                    
    
--daca inlocuim all cu any obtinem toti angajatii care au salariul mai mare sau egal decat unul dintre functionari
select last_name, job_id
from   employees
where  salary > any (select salary                       -- >any = mai mare decat un element din multime
                     from employees
                     where job_id like upper('%clerk'));

--cerere echivalenta
select last_name, job_id
from   employees
where  salary >     (select min(salary)                       -- >any = mai mare decat un element din multime
                     from   employees
                     where  job_id like upper('%clerk'));

-- BONUS cu raspuns trimis pe mail:  
--     Care dintre cele doua variante este recomandata/optima? 
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii. 
                     
                     
--11. Afisati numele si salariul angajatilor al caror salariu este mai mare decat salariile medii din toate departamentele. 
--    Rezolvati problema in doua variante.

select last_name, salary
from   employees
where  salary > all (select avg(salary)
                     from   employees
                     group by department_id);

--sau

select last_name, salary
from employees
where salary > (select max(avg(salary))
                from   employees
                group by department_id);


--12. Obtineti numarul total de angajati ai companiei, respectiv numarul celor care au fost angajati in anul 1997. Afisati informatiile cerute in urmatoarea forma:
--    a) pe linii (rezultatul va contine doua linii si o coloana);
--       Indicatie: Utilizati operatorul UNION.
--       NUMAR                                               
--       ---------------- 
--       Numar total: 107  
--       Numar 1997:  28

select 'numar total: ' || count(*) numar  
from    employees
union                                          -- permite reuninea multimilor de inregistrari; scoate duplicatele din multimea rezultat
select 'numar 1997: ' || count(*)              -- cererile tb sa contina in lista SELECT acelasi numar de expresii, de acelasi tip de date
from    employees
where   to_char(hire_date,'yyyy') = '1997';

select 'numar total: ' || count(*) numar
from    employees
union  all                                     -- permite reuninea multimilor de inregistrari; nu scoate duplicatele din multimea rezultat
select 'numar 1997: ' || count(*)              -- in acest caz este util pentru ca nu avem duplicare in multimea rezultat
from    employees
where   to_char(hire_date,'yyyy') = '1997';


--    b) pe coloane (rezultatul va contine doua coloane si o linie).
--       Numar total            Numar 1997             
--       --------------------- ---------------------- 
--       107                    28
  
select count(*) "numar total", 
       sum(decode(to_char(hire_date,'yyyy'),1997,1,0)) "numar 1997" 
from   employees;
 
                
--13. Pentru fiecare angajat obtineti urmatoarele informatii despre job-ul prezent, respectiv joburile sale anterioare: numele job-ului, 
--    numele departamentului, respectiv data la care a inceput sa lucreze pe job-ul respectiv. Ordonati rezultatul dupa codul angajatului.  

select e.employee_id, j.job_title, d.department_name, e.hire_date     --hire_date reprezinta data angajarii in companie
from   employees e, jobs j, departments d
where  e.job_id = j.job_id
and    e.department_id = d.department_id
union
select jh.employee_id, j.job_title, d.department_name, jh.start_date  --start_date reprezinta data la care a inceput sa lucreza pe acel job   
from   job_history jh, departments d, jobs j                          
where  jh.job_id = j.job_id
and    jh.department_id = d.department_id
order by 1, 4;


--14. Folosind operatorul INTERSECT, obtineti angajatii care au salariul cel mult 3000 si lucreaza in departamentul 50.

SELECT employee_id, last_name
FROM   employees 
WHERE  salary<3000
INTERSECT                             
SELECT employee_id, last_name
FROM   employees 
WHERE  department_id = 50;

-- cerere echivalenta
SELECT employee_id, last_name
FROM   employees 
WHERE  salary<3000 AND department_id = 50;

--15. Obtineti codul, job-ul si departamentul angajatilor care in trecut au mai lucrat pe acelasi job si in acelasi departament ca in prezent. 
--    Utilizati operatorul INTERSECT.

select employee_id, job_id, department_id
from   employees
intersect
select employee_id, job_id, department_id
from   job_history;

--16. Modificati cererea anterioara astfel incat sa obtineti numele angajatilor care indeplinesc conditia impusa.
select employee_id, last_name, job_id, department_id
from   employees
intersect
select jh.employee_id, e.last_name, jh.job_id, jh.department_id
from   job_history jh, employees e
where  jh.employee_id = e.employee_id;

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
WHERE  EXISTS (SELECT 1                      -- nu conteaza ce informatie este intoarsa de subcerere
               FROM   employees 		     -- la prima inregistrare intoarsa de subcerere cautarea se opreste deoarece EXISTS va 
               WHERE  employee_id = 200      --     intoarce valoarea TRUE
               AND    e.salary >salary);

--cereri echivalenta
SELECT employee_id, last_name
FROM   employees e
WHERE  EXISTS (SELECT 'x'                    -- nu conteaza ce informatie este intoarsa de subcerere
               FROM   employees 		     -- la prima inregistrare intoarsa de subcerere cautarea se opreste deoarece EXISTS va 
               WHERE  employee_id = 200      --     intoarce valoarea TRUE
               AND    e.salary >salary);


SELECT employee_id, last_name
FROM   employees e
WHERE  EXISTS (SELECT employee_id            -- nu conteaza ce informatie este intoarsa de subcerere
               FROM   employees 		     -- la prima inregistrare intoarsa de subcerere cautarea se opreste deoarece EXISTS va 
               WHERE  employee_id = 200      --     intoarce valoarea TRUE
               AND    e.salary >salary);
               
--19. Dati o alta metoda de rezolvare pentru problema anterioara, utilizand subcereri si operatorul „>”.
SELECT employee_id, last_name 
FROM   employees 
WHERE  salary > (SELECT salary       
                 FROM   employees
                 WHERE  employee_id = 200);


--20. Folosind operatorul EXISTS determinati numele departamentelor in care lucreaza cel putin un angajat.
SELECT department_id, department_name                     -- permite implementarea operatorului SEMI-JOIN
FROM   departments d
WHERE  EXISTS (SELECT 'x'                                 -- nu conteaza ce informatie este intoarsa de subcerere
               FROM   employees                           -- la prima inregistrare intoarsa de subcerere cautarea se opreste deoarece EXISTS va 
               WHERE  department_id = d.department_id);   --     intoarce valoarea TRUE
               


--21.	Dati o alta metoda de rezolvare pentru problema anterioara, utilizand subcereri si operatorul IN.

SELECT department_id, department_name
FROM   departments d
WHERE  department_id IN (SELECT department_id                         
                         FROM   employees);

-- BONUS cu raspuns trimis pe mail:  
--     Care dintre cele doua variante este recomandata/optima (EXISTS sau IN)? 
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii. 

--rezolvare cu join
select distinct e.department_id, department_name 
from   departments d, employees e
where  e.department_id = d.department_id;

-- BONUS cu raspuns trimis pe mail:  
--     Care dintre cele trei variante este recomandata/optima (EXISTS sau IN sau JOIN)? 
--     Dati exemple de cereri care se pot implementa folosind NOT EXISTS / NOT IN si precizati care este mai eficenta.
-- Toate raspunsurile aferente laboratorului 5 vor fi incluse intr-un fisier doc de forma nume_prenume_lab5_bonus.
-- Specificati cererile insotite de comentariile voastre si de print-screen-uri in care sa se vada si rezultatul rularii. 




