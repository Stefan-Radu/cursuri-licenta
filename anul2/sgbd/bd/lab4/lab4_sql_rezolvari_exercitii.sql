--LAB4 SQL 

--1. Afisati cel mai mare salariu, cel mai mic salariu, suma si media salariilor tuturor angajatilor. 
--   Etichetati coloanele Maxim, Minim, Suma, respectiv Media. 
	
SELECT MIN(salary) "Minim",       -- obtine valoarea minima 
       MAX(salary) "Maxim",       -- obtine valoarea maxima 
       SUM(salary) "Suma",        -- obtine suma valorilor
       ROUND(AVG(salary)) "Media" -- obtine media valorilor; rezultatul este rotunjit folosind functia ROUND
FROM   employees;                 -- multime pe care se aplica funtiile grup: intrega tabela EMPLOYEES pentru ca nu am nicio uun filtru (nicio 
                                  -- clauza WHERE)

--multimea pe care se aplica functiile grup este data de urmatoarea cerere
select salary
from   employees;
 
--2. Utilizand functia grup COUNT determinati:
--  a. numarul total de angajati; 
select count(*) nr_total_ang     -- obtine numarul de inregistrari intors de comanda select; pentru aceasta cerere intoarce numarul de inregistrari din
                                 -- din tabela EMPLOYEES, adica numarul de angajati
from   employees;

-- Observatie: multimea pe care se aplica functia grup este data de urmatoarea cerere
select *
from   employees;
       
--  b. numarul de angajati care au manager;
select count(manager_id) ang_cu_mgr  -- obtine numarul de valori nenule ale coloanei manager_id, adica numarul de angajati care au manager_id setat 
from   employees;

-- Observatie: multimea pe care se aplica functia grup este data de urmatoarea cerere
select manager_id
from   employees
where  manager_id is not null;

--cerere echivalenta
select count(*) ang_cu_mgr     --obtine numarul de inregistrari pentru care manager_id este nenul
from   employees
where  manager_id is not null;
       
--  c. numarul de manageri. 
select count(distinct manager_id) nr_mgr --obtine numarul de valori distincte din coloana manager_id; adica numarul de manageri
from   employees;

-- Observatie: multimea pe care se aplica functia grup este data de urmatoarea cerere
select distinct manager_id
from   employees
where  manager_id is not null;


-- 3. Afisati diferenta dintre cel mai mare si cel mai mic salariu. Etichetati coloana Diferenta. 
select max(salary)-min(salary) diferenta
from   employees;

-- Observatie: multimea pe care se aplica functia grup este data de urmatoarea cerere
select salary
from   employees;

-- 4. a. Selectati data angajarii primei persoane care a fost angajata de companie (tinand cont si de istoricul angajatilor).
SELECT MIN(hire_date)
FROM   employees;

-- Observatie: multimea pe care se aplica functia grup este data de urmatoarea cerere
select salary
from   employees;
      
--    b. Selectati numele persoanelor care au fost angajate primele in companie.
SELECT last_name, hire_date
FROM   employees
WHERE  hire_date = (SELECT MIN(hire_date)  -- conditia: data angajarii este cea mai mica data inregistrata
                    FROM employees);       -- subcerere se executa prima, o singura data
    
-- Cerere gresita
SELECT last_name, hire_date
FROM   employees
WHERE  hire_date = MIN(hire_date);  -- functia grup se aplica pe o multime; in acest caz, multimea este data de subcerere

--5. Afisati numarul de angajati pentru fiecare job.
SELECT job_id, COUNT(employee_id) nr_angajati
FROM   employees
GROUP BY job_id;  -- "pentru fiecare job" => se grupeaza datele la nivel de job si se aplica functia grup pentru fiecare grup astfel format
                  -- clauza group by determina divizarea multimii in submultimi si aplicarea functiilor grup la nivel de submultime
                  -- numarul de submultimi create = numarul de valori distincte din coloana de grupare (cea care apare in clauza group by)
                  -- regula: in lista select pot sa apara doar expresiile/coloanele din group by si functii grup

-- cerere este corecta, dar informatiile afisate nu pot fi interpretate
SELECT COUNT(employee_id) nr_angajati
FROM   employees
GROUP BY job_id; 

--cerere gresita
SELECT job_id, last_name, COUNT(employee_id) nr_angajati --last_name nu apare in clauza group by, dar nici nu are sens sa apara pentru aceasta cerinta
                                                         --in schimb, are sens sa apara job_title de exemplu
FROM   employees                                         --regula: coloanele/expresiile care se pun in lista select identifica grupul
GROUP BY job_id;

--6. Afisati codul departamentului si media salariilor pentru fiecare job din cadrul acestuia.
SELECT department_id, job_id, round(AVG(salary),2)
FROM   employees
GROUP BY department_id, job_id;  -- multimea este divizata in submultimi la nivel de departamente, iar o submultime a unui departament este 
                                 -- divizata in submultimi la nivel de joburi
                                 -- functia grup se calculeaza pentru fiecare job din cadrul unui departament
                                 -- numarul de inregistrari intoarse = numarul de valori distincte ale concatenarii department_id || job_id

--7.a. Afisati codul departamentelor pentru care salariul minim depaseste 5000$.
SELECT   department_id, MIN(salary)
FROM     employees
GROUP BY department_id     -- mutimea este divizata in submultimi la nivel de departamente
HAVING MIN(salary)>5000;   -- este filtru pentru grupuri (asa cum clauza WHERE este filtru pentru inregistrarile unei cereri)
                           -- in rezultat nu trebuie sa apara toate grupurile, ci doar acele grupuri pentru care este adevarat predicatul din clauza HAVING
                           -- in clauza having se pot pune conditii care implica functii grup sau coloane/expresii ce apar in clauza GROUP BY

--b. Modificati cererea anterioara astfel incat sa afisati numele acestor departamente.  
SELECT   e.department_id, department_name, MIN(salary) salariu_minim
                                            --department_id devine coloana "ambiguu definita" deoarece apare in ambele tabele din clauza FROM => 
                                            --                   sunt necesare aliasuri
FROM     employees e, departments d         --numele departamentului este in tabela departments
where    e.department_id=d.department_id(+) -- conditia de join: outer join pt ca in rezultat sa ramana si inregistrarea pentru care department_id 
                                            --                   este null
GROUP BY e.department_id, department_name   -- este obligatoriu sa apara exact aceleasi coloane care apare in lista select; d.department_id genereaza eroare   
HAVING MIN(salary)>5000;

-- doar denumirea departamentului
SELECT   department_name, MIN(salary) salariu_minim
FROM     employees e, departments d         -- numele departamentului este in tabela departments
where    e.department_id=d.department_id(+) -- conditia de join: outer join pt ca in rezultat sa ramana si inregistrarea pentru care department_id 
                                           --                   este null
GROUP BY department_name   -- este obligatoriu sa apara exact aceleasi coloane care apare in lista select; d.department_id genereaza eroare   
HAVING MIN(salary)>5000;

--c. Modificati cererea anterioara astfel incat sa afisati si orasul in care functioneaza departamentele.
SELECT   department_name, city, MIN(salary) salariu_minim  
FROM     employees e, departments d, locations s   --city este coloana in tabela locations
where    e.department_id=d.department_id(+) -- conditia de join: outer join pt ca in rezultat sa ramana si inregistrarea pentru care department_id 
                                            --                   este null
and      d.location_id = s.location_id(+)   -- conditia ramane un outer join din acelasi motiv cu cel de mai sus
GROUP BY department_name, city   -- este obligatoriu sa apara exact aceleasi coloane care apare in lista select  
HAVING MIN(salary)>5000;

--8. a. Obtineti codul departamentelor si numarul de angajati al acestora pentru departamentele in care lucreaza  cel putin 10 angajati.
SELECT department_id, COUNT(employee_id) nr   -- in acest caz COUNT(employee_id) = COUNT(*) pt ca employee_id este cheie primara => este not null
FROM   employees
GROUP BY department_id
HAVING   COUNT(*) > =10;

--   b.	Cate departamente au cel putin 10 angajati?
SELECT COUNT(COUNT(employee_id)) nr    -- se pot aplica maxim 2 functii grup una peste alta
                                       -- restrictia: nu se mai pot afisa alte expresii/coloane in plus
FROM   employees
GROUP BY department_id
HAVING   COUNT(*) > =10;

--cerere exchivalenta
SELECT COUNT(*)
FROM   (SELECT COUNT(*)                   -- o subcerere poate sa apara in clauza FROM, caz in care se numeste view inline
                                          -- mutimea rezultat a subcererii este folosit ca si cand ar fi o tabela 
        FROM   employees           
        GROUP BY department_id
        HAVING   COUNT(*) > =10);

--9. Afisati job-ul pentru care salariul mediu este minim.
SELECT job_id  
FROM   employees
GROUP BY job_id    -- pentru fiecare job trebuie sa se calculeze salariu mediul => grupare dupa job_id
HAVING AVG(salary) = (SELECT MIN(AVG(salary))  --salariul mediu trebuie sa fie cel mai mic salariu mediu
                      FROM   employees
                      GROUP BY job_id);

-- cererea urmatoare obtine salariile medii pentru fiecare job
SELECT AVG(salary) 
FROM   employees
GROUP BY job_id;

--cererea urmatoare obtine cea mai mica medie
SELECT min(AVG(salary)) 
FROM   employees
GROUP BY job_id;
                      
--10. a. Afisati codul, numele departamentului si suma salariilor pe departamente.
SELECT d.department_id, department_name,a.suma
FROM   departments d, (SELECT department_id ,SUM(salary) suma   --aliasul este obligatoriu pt a putea sa fie referita coloana/expresia in cererea principala  
                       FROM   employees
                       GROUP BY department_id) a
WHERE  d.department_id =a.department_id
order by 1; --rezultatul este ordonat ascendent dupa coloana department_id pentru a putea verifica mai usor rezultatele celor 2 cereri

-- b. Dati o alta metoda de rezolvare a acestei probleme.
SELECT d.department_id, department_name, SUM(salary) suma
FROM   departments d, employees e               
WHERE  d.department_id =e.department_id
GROUP BY d.department_id, department_name
order by 1; --rezultatul este ordonat ascendent dupa coloana department_id pentru a putea verifica mai usor rezultatele celor 2 cereri

--11. a. Scrieti o cerere pentru a afisa numele departamentului, numarul de angajati si salariul mediu pentru angajatii din acel departament. Coloanele vor fi etichetate Departament, Nr. angajati, Salariu Mediu.

SELECT department_name "Departament ", 
       (SELECT COUNT(employee_id)        --subcererea apare in lista select => avem restrictii: trebuie sa intoarca o singura coloana si o singura inregistrare
        FROM   employees                 
        WHERE  department_id = d.department_id ) "Nr. angajati", --conditie de sincronizare cu cererea principala
       (SELECT round(AVG(salary))
        FROM   employees
        WHERE  department_id = d.department_id) "Salariu mediu"  --conditie de sincronizare cu cererea principala
        --ambele subcereri sunt sincronizate cu cererea principala => se executa pentru fiecare inregistrare intoarsa de cererea principala                                   
FROM   departments d;

-- b. Dati o alta metoda de rezolvare pentru problema anterioara.  
SELECT department_name, COUNT(employee_id), round(AVG(salary))         
FROM   employees e, departments d        
WHERE  e.department_id(+) = d.department_id  
GROUP BY department_name;


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
--    NU. Datorita sincronizarii clauza Group By este inutila pentru ca se pastreaza in rezultat un singur grup
SELECT DISTINCT job_id,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id =10 
        ) dep10,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id =20 
        ) dep20,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id =30 
        ) dep30,
       (SELECT SUM(salary) 
        FROM   employees 
        WHERE  job_id=e.job_id AND department_id IN (10, 20,30)
        ) total
FROM  employees e;

--    c. Este necesara o clauza GROUP BY in cererea principala?
--    NU. Datorita sincronizarii subcererilor cu cererea principala fiecare subcerere determina valoarea ceruta pentru fiecare job.

--    d. Clauza SELECT a cererii principale trebuie sa utilizeze optiunea DISTINCT?
--    DA. In tabela EMPLOYEES exista mai multi angajati care au acelasi job

--    e. Dati o alta metoda de rezolvare utilizand functia DECODE.
--        Indicatie: SUM(DECODE(department_id,10,salary)) 
SELECT job_id, SUM(DECODE(department_id,10,salary,0)) dept_10,   --in suma se introduce valoarea salariului dc angajatul lucreaza in departamentul 10 si 0 altfel => se obtine suma salariilor celor care lucreaza in departamentul 10, pe acel job
               SUM(DECODE(department_id,20,salary,0)) dept_20,   --in suma se introduce valoarea salariului dc angajatul lucreaza in departamentul 20 si 0 altfel => se obtine suma salariilor celor care lucreaza in departamentul 20, pe acel job 
               SUM(DECODE(department_id,30,salary,0)) dept_30,   --in suma se introduce valoarea salariului dc angajatul lucreaza in departamentul 30 si 0 altfel => se obtine suma salariilor celor care lucreaza in departamentul 30, pe acel job
               SUM(DECODE(department_id,10,salary,20,salary,30,salary,0)) total
                                                                 --in suma se introduce valoarea salariului dc angajatul lucreaza in departamentul 10, 20 sau 30 si 0 altfel => se obtine suma salariilor celor care lucreaza in departamentul 10,20 sau 30 pe acel job
FROM employees
GROUP BY job_id;