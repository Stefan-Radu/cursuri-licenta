-- 1.Afisati pentru fiecare angajat numele, codul si numele departamentului in care lucreaza.
    
    SELECT last_name, e.department_id, department_name --coloana department_id apare in ambele tabele => tb utilizat alias
    FROM   employees e, departments d                  --sunt accesate 2 tabele, fiecare avand cate un alias
    WHERE  e.department_id = d.department_id;          --conditia de join
    
    --recomandarea este sa utilizam aliasuri pentru toate coloanele
    SELECT e.last_name, e.department_id, d.department_name --coloana department_id apare in ambele tabele => tb utilizat alias
    FROM   employees e, departments d                      --sunt accesate 2 tabele, fiecare avand cate un alias
    WHERE  e.department_id = d.department_id;              --conditia de join: cheie primara tabela parinte = cheie externa tabela copil

--2.Afisati numele angajatului, numele departamentului pentru toti angajatii care castiga comision.
    SELECT e.last_name, e.department_id, d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id  --conditia de join
    AND    e.COMMISSION_PCT is not null;      --predicat de selectie; 
     
--3.Afisati numele job-urile care exista in departamentul 30. 
    select j.job_title             --mai multi angajati din departamentul 30 au acelasi job => avem duplicate in rezultat
    from   jobs j, employees e
    where  j.job_id = e.job_id    
    and    e.department_id = 30;
    
    select distinct j.job_title    --eliminam duplicatele din rezultat
    from   jobs j, employees e
    where  j.job_id = e.job_id
    and    e.department_id = 30;

--4.Afisati numele, job-ul si numele departamentului pentru toti angajatii care lucreaza in Seattle.
    SELECT e.last_name, e.job_id, d.department_name  --lista select: datorita ei trebuie accesate tabelele employees si departments
    FROM   employees e, departments d, locations s   --tabelele accesate
    WHERE  d.department_id = e.department_id         --conditia de join 1 (departments cu employees)
    AND    s.location_id = d.location_id             --conditia de join 2 (locations cu departments)
    AND    l.city = 'Seattle';                       --predicat de selectie: datorita lui trebuie accesata si tabela locations

--5.Afisati numele, salariul, data angajarii si numele departamentului pentru toti programatorii (numele jobului este Programmer) 
--  care lucreaza in America de Nord sau in America de Sud (numele regiunii este Americas).
    select e.last_name,e.hire_date,d.department_name   --lista select: datorita ei trebuie accesate tabelele employees si departments
    from employees e,departments d, locations a,       --tabelele accesate
         countries c, regions r, jobs j
    where e.department_id=d.department_id  --conditia de join 1 (employees cu departments)
    and  e.job_id=j.job_id                 --conditia de join 2 (employees cu jobs)
    and  d.location_id=a.location_id       --conditia de join 3 (departments cu locations)
    and  a.country_id=c.country_id         --conditia de join 4 (locations cu countries)
    and  c.region_id=r.region_id           --conditia de join 5 (countries cu regions)
    and  j.job_title='Programmer'          --predicat de selectie: datorita lui trebuie accesata tabela jobs
    and  r.region_name='Americas';         --predicat de selectie: datorita lui trebuie accesate tabelele locations, countries, regions 
                                           --ATENTIE: predicatul utilizeaza o coloana din tabela regions pe care nu o pot accesa direct
                                                      --trebuie sa se urmeze relatiile din diagrama pe traseul 
                                                      -- departments -> locations -> countries -> regions


--6.Afisati numele salariatilor si numele departamentelor in care lucreaza. 
-- Se vor afisa si salariatii al caror departament nu este cunoscut (left outher join).
    SELECT e.last_name, d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id(+); -- pentru angajatii al caror departament este necunoscut (are valoare null)
                                                 -- operatorul extern va completa cu null informatia lipsa din tabela departments

    --in lista select mai adaug inca o coloana din tabela departments => inca o valoare null generata de operatorul extern pentru 
    --inregistrarile din tabele employees care nu au corespondent in tabela departments
    SELECT e.last_name, d.department_name, d.manager_id
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id(+); -- pentru angajatii al caror departament este necunoscut (are valoare null)
                                                 -- operatorul extern va completa cu null informatia lipsa din tabele departments
                                                 -- informatia completa o doresc din employees care in predicat apare in partea stanga => este un left outer join
    --rezultatul contine urmatoarele inregistrari:
    --106 inregistrari care respecta conditia de join e.department_id = d.department_id
    --1 inregistrare (un angajat cu departament necunoscut) care este adusa suplimentar prin outer join: e.department_id = d.department_id(+)
    --total: 106+1=107 inregistrari

    --aceeasi cerere cu right outer join
    SELECT e.last_name, d.department_name, d.manager_id
    FROM   employees e, departments d
    WHERE  d.department_id (+) = e.department_id;  -- informatia completa este din employees care in predicat apare in partea dreapta => este un right outer join
   
    
--7.Afisati numele departamentelor si numele salariatilor care lucreaza in acestea. 
-- Se vor afisa si departamentele care nu au salariati (right outher join).
    SELECT d.department_name, e.last_name
    FROM   employees e, departments d
    WHERE  e.department_id(+) = d.department_id; -- pentru departamentele in care nu lucreaza nimeni (apar in departments, dar nu si in employees)
                                                 -- operatorul extern va completa cu null informatia lipsa din tabela employees
                                                 -- informatia completa este din departments care in predicat apare in partea dreapta => este un right outer join
    --rezultatul contine urmatoarele inregistrari:
    --106 inregistrari care respecta conditia de join e.department_id = d.department_id
    --16 inregistrari (departamentele in care nu lucreaza angajati) care sunt aduse suplimentar prin outer join: e.department_id = d.department_id(+)
    --total: 106+16=122 inregistrari

    --aceeasi cerere cu left outer join
    SELECT d.department_name, e.last_name
    FROM   employees e, departments d
    WHERE  d.department_id = e.department_id(+); -- informatia completa este din departments care in predicat apare in partea stanga => este un left outer join

--8.Afisati numele departamentelor si numele salariatilor care lucreaza in acestea. 
--  Se vor afisa si salariatii al caror departament nu este cunoscut, respectiv si departamentele care nu au salariati (full outher join).
--  Observatie: full outer join = left outer join UNION right outer join
    
    --cererea urmatoare va genera o eroare 
    SELECT d.department_name, e.last_name
    FROM   employees e, departments d
    WHERE  d.department_id (+) = e.department_id(+); --intr-un predicat de join se poate specifica o singura tabela ca fiind outer 
   
    --se utilizeaza sql standard (solutie eficienta)
    SELECT d.department_name, e.last_name
    FROM   employees e full outer join departments d on d.department_id = e.department_id; 
    
    --cerere echivalenta
    SELECT d.department_name, e.last_name
    FROM   employees e full outer join departments d using (department_id); --se specifica doar coloana de join 
                                                                            --optiunea este permisa daca denumirea coloanei este aceeasi in ambele tabele
    
    --se utilizeaza operatorul UNION (solutie ineficienta): operatorul UNION implica o operatie de sortare si eliminarea duplicatelor,
    --care in acest caz sunt toate inregistrariele ce respecta conditia de join
    SELECT e.last_name, d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id(+) = d.department_id
    UNION
    SELECT e.last_name, d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id(+);
    
    --rezultatul contine urmatoarele inregistrari:
    --106 inregistrari care respecta conditia de join e.department_id = d.department_id (se duplica in rezultat sunt eliminate de operatorul UNION)
    --1 inregistrare (un angajat cu departament necunoscut) care este adusa suplimentar prin outer join 
    --16 inregistrari (exista 16 departamente in care nu lucreaza nimeni) care sunt aduse suplimentar prin outer join
    --total: 106+1+16=123
    
    --rezultat eronat: se utilizeza operarorul UNION ALL care nu elimina duplicatele 
    SELECT e.last_name, d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id(+) = d.department_id
    UNION ALL
    SELECT e.last_name, d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id(+);
    --total inregistrari in rezultat: (106+1) + (106+16) = 107+122=229
    
--9.Afisati numele, job-ul, numele departamentului, salariul si grila de salarizare pentru toti angajatii.
   select e.last_name, e.job_id, d.department_name, jg.grade_level
   from   employees e, departments d, job_grades jg
   where  e.department_id=d.department_id(+)   --toti angajatii, inclusiv pe cei care nu au departament asociat/cunoscut
   and    e.salary between jg.lowest_sal and jg.highest_sal;

--10.Afisati codul angajatului si numele acestuia, impreuna cu numele si codul sefului sau direct. 
--  Etichetati coloanele CodAng, NumeAng, CodMgr, NumeMgr. 
    SELECT a.employee_id "CodAng", a.last_name "NumeAng", 
           b.employee_id "CodMgr", b.last_name "NumeMgr" 
    FROM   employees a, employees b        --daca in clauza FROM pun de mai multe ori aceeasi tabela => aliasurile sunt obligatorii
    WHERE  a.manager_id = b. employee_id;  --selfjoin: tabela intra in join cu ea insasi
    --rezultatul contine 106 linii pentru ca un angajat (employee_id = 100) nu are sef => pentru acesta manager_id are valoarea null

    --vreau si seful sefului
   SELECT a.employee_id "CodAng", a.last_name "NumeAng",
          b.employee_id "CodMgr1", b.last_name "NumeMgr1",
          c.employee_id "CodMgr2", c.last_name "NumeMgr2"
   FROM  employees a, employees b, employees c
   WHERE a.manager_id = b. employee_id 
   AND   b.manager_id = c. employee_id;

--11.Modificati cererea anterioara astfel incat sa afisati toti salariatii, inclusiv pe cei care nu au sef. 
    SELECT a.employee_id "CodAng", a.last_name "NumeAng", 
           b.employee_id "CodMgr", b.last_name "NumeMgr" 
    FROM   employees a, employees b        
    WHERE  a.manager_id = b. employee_id (+);  
    
    --vreau si seful sefului => outer join in tot lantul
    SELECT a.employee_id "CodAng", a.last_name "NumeAng",
           b.employee_id "CodMgr1", b.last_name "NumeMgr",
           c.employee_id "CodMgr2", c.last_name "NumeMgr2"
    FROM  employees a, employees b,employees c
    WHERE a.manager_id = b. employee_id(+)
    AND   b.manager_id=c.employee_id(+);  
    
--12.Afisati numele salariatului si data angajarii impreuna cu numele si data angajarii sefului direct pentru salariatii care 
-- au fost angajati inaintea sefilor lor.
    select ang.last_name "NumeAng",ang.hire_date "DataAng", sef.last_name "NumeSef",sef.hire_date "DataAngSef"
    from   employees ang, employees sef     --recomandare: pentru selfjoin-uri folositi aliasurile sugesive 
    where  ang.manager_id=sef.employee_id
    and    ang.hire_date<sef.hire_date;
   
--13.Pentru fiecare angajat din departamentele 20 si 30 afisati numele, codul departamentului si toti colegii sai 
-- (salariatii care lucreaza in acelasi departament cu el). 
    select ang1.last_name,ang1.department_id,ang2.last_name
    from   employees ang1, employees ang2
    where  ang1.department_id in (20,30) 
    and    ang2.department_id in (20,30)
    and    ang1.employee_id<>ang2.employee_id;

--14.Afisati numele si data angajarii pentru salariatii care au fost angajati dupa Fay.
    SELECT last_name, hire_date
    FROM   employees
    WHERE  hire_date > (SELECT hire_date           --se utilizeaza o subcerere care intoarce informatia necesara
                        FROM   employees
                        WHERE  last_name = 'Fay');
    --subcererea nu este sincronizata cu cererea principala => se executa o singura data, prima, se obtine multimea rezultat si
    --apoi se executa cererea principala
    --Observatie: daca subcererea ar fi intors mai multe linii, atunci cererea principala ar fi returnat eroare deoarece  
    --            este utilizat operatorul scalar ">"    
    
    --cerere gresita (subcerera intoarce mai mult de o inregistrare)
    SELECT last_name, hire_date
    FROM   employees
    WHERE  hire_date > (SELECT hire_date           
                        FROM   employees
                        WHERE  last_name = 'King');  
    
    --exista 2 angajati cu acelasi nume
    SELECT hire_date, employee_id           
    FROM   employees
    WHERE  last_name = 'King';
    
    --trebuie sa identificam angajatul dupa o valoare unica (cheie primara, email etc)
    --cerere corecta
    SELECT last_name, hire_date
    FROM   employees
    WHERE  hire_date > (SELECT hire_date           
                        FROM   employees
                        WHERE  employee_id = 156); 
                                 
--15.Rezolvati exercitiul anterior utilizand join-uri.
    SELECT a.last_name, a.hire_date
    FROM   employees a, employees b
    WHERE  UPPER(b.last_name)= 'FAY'   --atentie la fuctia UPPER aplicata pe coloana
    AND    a.hire_date>b.hire_date; 
       
    --alternativa: utilizam formatul sirului de caractere asa cum este stocat in BD
    SELECT a.last_name, a.hire_date
    FROM   employees a, employees b
    WHERE  b.last_name= 'Fay' 
    AND    a.hire_date>b.hire_date; 
  
--16.Scrieti o cerere pentru a afisa numele si salariul pentru toti colegii (din acelasi departament) lui Fay. Se va exclude Fay.
    SELECT  last_name, salary
    FROM    employees
    WHERE   last_name <> 'Fay'
    AND     department_id = (SELECT department_id      --subcererea intoarce o singura inregistrare
                             FROM employees
                             WHERE last_name = 'Fay'); 
    
    --cerere eronata
    SELECT  last_name, salary
    FROM    employees
    WHERE   last_name <> 'Fay'
    AND     department_id = (SELECT department_id      
                             FROM   employees
                             WHERE  last_name = 'King');    
    
    --cerere corecta                       
    SELECT  last_name, salary
    FROM    employees
    WHERE   last_name <> 'Fay'
    AND     department_id = (SELECT department_id      
                             FROM   employees
                             WHERE  employee_id = 156); 
                                                   
--17.Afisati numele si salariul angajatilor condusi direct de Steven King.
    SELECT last_name, salary
    FROM   employees
    WHERE  manager_id = (SELECT employee_id
                         FROM   employees
                         WHERE  last_name= 'King'       --in loc de UPPER(last_name) ='KING'   
                         AND    first_name= 'Steven');  -- in loc de UPPER(first_name) ='STEVEN');

--18.Afisati numele si job-ul tuturor angajatilor din departamentul 'Sales'.
    SELECT last_name, job_id
    FROM   employees 
    WHERE  department_id = (SELECT department_id
                            FROM   departments
                            WHERE  department_name ='Sales');
    
    --ATENTIE: subcererea intoarce o singura linie, dar nu am certitudine si in viitor pentru ca nu exista o constrangere de
    --de unicitate pe coloana department_name
    select constraint_name, constraint_type
    from   user_constraints
    where  table_name='DEPARTMENTS';
    
    --pentru a nu avea eroare in astfel de cazuri se poate folosi operatorul IN
    SELECT last_name, job_id
    FROM   employees 
    WHERE  department_id IN (SELECT department_id
                            FROM   departments
                            WHERE  department_name ='Sales');
                            
    --depinzand de date si aplicatie, de preferat este sa se adauge constrangerea de unicitate pentru a obtine beneficii 
    --pe partea de optimizare                        
                                                       
--19.Rezolvati exercitiul anterior utilizand join-uri.
    select last_name,job_id
    from   employees e,departments d
    where  e.department_id=d.department_id
    and    department_name='Sales';

--20.Afisati numele angajatilor, numarul departamentului si job-ul tuturor salariatilor al caror departament este 
-- localizat in Seattle.
    SELECT last_name, job_id, department_id
    FROM   employees  
    WHERE  department_id IN 
             (SELECT department_id --subcerere 2: se executa a doua
              FROM   departments
              WHERE  location_id = (SELECT location_id  -- subcerere 1: se executa prima
                                    FROM   locations 
                                    WHERE  city = 'Seattle')); 

--21.Rezolvati exercitiul anterior utilizand join-uri.
    select e.last_name,e.job_id,e.department_id
    from   employees e, departments d, locations a
    where  e.department_id=d.department_id
    and    d.location_id=a.location_id
    and    a.city='Seattle';

--22.Aflati daca exista angajati care nu lucreaza in departamentul Sales, dar au aceleasi castiguri (salariu si comision) 
-- ca si un angajat din departamentul Sales. 
--Observatie: Angajatul cu codul 178 indeplineste conditia (nu lucreaza in niciun departament), deci ar trebui afisat.
        
    SELECT last_name, salary, commission_pct, department_id
    FROM   employees 
    WHERE (salary, commission_pct) IN 
                                    (SELECT e.salary, e.commission_pct
                                     FROM   employees e, departments d
                                     WHERE  e.department_id = d.department_id
                                     AND    d.department_name = 'Sales')
    AND    department_id <> (SELECT department_id                   
                             FROM   departments 
                             WHERE  department_name = 'Sales');
   --angajatul 178 nu este afisat deoarece department_id este null
   
   --cerere corecta
    SELECT last_name, salary, commission_pct, department_id
    FROM   employees 
    WHERE (salary, commission_pct) IN 
                                    (SELECT e.salary, e.commission_pct
                                     FROM   employees e, departments d
                                     WHERE  e.department_id = d.department_id
                                     AND    d.department_name = 'Sales')
    AND    NVL(department_id,0) <> (SELECT department_id                   
                                    FROM   departments 
                                    WHERE  department_name = 'Sales');