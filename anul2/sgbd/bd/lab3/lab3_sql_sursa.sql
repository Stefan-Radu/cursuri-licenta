-- 1.Afisati pentru fiecare angajat numele, codul si numele departamentului in care lucreaza.
    SELECT last_name, e.department_id, department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id; 

--2.Afisati numele angajatului, numele departamentului pentru toti angajatii care castiga comision.

--3.Afisati numele job-urile care exista in departamentul 30. 

--4.Afisati numele, job-ul si numele departamentului pentru toti angajatii care lucreaza in Seattle.
    SELECT last_name, job_id, department_name
    FROM   employees e, departments d, locations s
    WHERE  e.department_id = d.department_id
    AND    d.location_id = s.location_id
    AND    city = 'Seattle'; 
    
--5.Afisati numele, salariul, data angajarii si numele departamentului pentru toti programatorii (numele jobului este Programmer) care lucreaza in America de Nord sau in America de Sud (numele regiunii este Americas).

--6.Afisati numele salariatilor si numele departamentelor in care lucreaza. Se vor afisa si salariatii al caror departament nu este cunoscut (left outher join).
    SELECT last_name, department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id(+);

--7.Afisati numele departamentelor si numele salariatilor care lucreaza in acestea. Se vor afisa si departamentele care nu au salariati (right outher join).

--8.Afisati numele departamentelor si numele salariatilor care lucreaza in acestea. Se vor afisa si salariatii al caror departament nu este cunoscut, respectiv si departamentele care nu au salariati (full outher join).
--Observatie: full outer join = left outer join UNION right outer join

--9.Afisati numele, job-ul, numele departamentului, salariul si grila de salarizare pentru toti angajatii.
--10.Afisati codul angajatului si numele acestuia, impreuna cu numele si codul sefului sau direct. Etichetati coloanele CodAng, NumeAng, CodMgr, NumeMgr. 
    SELECT a.employee_id "CodAng", a.last_name "NumeAng", 
           b.employee_id "CodMgr", b.last_name "NumeMgr" 
    FROM   employees a, employees b
    WHERE  a.manager_id = b. employee_id;

--11.Modificati cererea anterioara astfel incat sa afisati toti salariatii, inclusiv pe cei care nu au sef. 

--12.Afisati numele salariatului si data angajarii impreuna cu numele si data angajarii sefului direct pentru salariatii care au fost angajati inaintea sefilor lor.

--13.Pentru fiecare angajat din departamentele 20 si 30 afisati numele, codul departamentului si toti colegii sai (salariatii care lucreaza in acelasi departament cu el). 

--14.Afisati numele si data angajarii pentru salariatii care au fost angajati dupa Fay.
    SELECT last_name, hire_date
    FROM   employees
    WHERE  hire_date > (SELECT hire_date
                        FROM   employees
                     WHERE  last_name = 'Fay');
--15.Rezolvati exercitiul anterior utilizand join-uri.
    SELECT a.last_name, a.hire_date
    FROM   employees a, employees b
    WHERE  UPPER(b.last_name)= 'FAY' 
    AND    a.hire_date>b.hire_date; 

--16.Scrieti o cerere pentru a afisa numele si salariul pentru toti colegii (din acelasi departament) lui Fay. Se va exclude Fay.
    SELECT  last_name, salary
    FROM    employees
    WHERE   last_name <> 'Fay'
    AND     department_id = (SELECT department_id
                             FROM employees
                             WHERE last_name = 'Fay');

--17.Afisati numele si salariul angajatilor condusi direct de Steven King.
    SELECT last_name, salary
    FROM   employees
    WHERE  manager_id = (SELECT employee_id
                         FROM   employees
                         WHERE  UPPER(last_name) ='KING'
                         AND    UPPER(first_name) ='STEVEN');

--18.Afisati numele si job-ul tuturor angajatilor din departamentul 'Sales'.
    SELECT last_name, job_id
    FROM   employees 
    WHERE  department_id = (SELECT department_id
                            FROM   departments
                            WHERE  department_name ='Sales');
--19.Rezolvati exercitiul anterior utilizand join-uri.

--20.Afisati numele angajatilor, numarul departamentului si job-ul tuturor salariatilor al caror departament este localizat in Seattle.
    SELECT last_name, job_id, department_id
    FROM   employees  
    WHERE  department_id IN 
             (SELECT department_id
              FROM   departments
              WHERE  location_id = (SELECT location_id
                                    FROM   locations 
                                    WHERE  city = 'Seattle')); 

--21.Rezolvati exercitiul anterior utilizand join-uri.

--22.Aflati daca exista angajati care nu lucreaza in departamentul Sales, dar au aceleasi castiguri (salariu si comision) ca si un angajat din departamentul Sales. 
--Observație: Angajatul cu codul 178 indeplinește condiția (nu lucreaza in niciun departament), deci ar trebui afișat.
    SELECT last_name, salary, commission_pct, department_id
    FROM   employees 
    WHERE (salary, commission_pct) IN 
          (SELECT salary, commission_pct
           FROM   employees e, departments d
           WHERE  e.department_id = d.department_id
           AND    department_name = 'Sales')
    AND    department_id <> (SELECT department_id
                             FROM   departments 
                             WHERE  department_name = 'Sales');
