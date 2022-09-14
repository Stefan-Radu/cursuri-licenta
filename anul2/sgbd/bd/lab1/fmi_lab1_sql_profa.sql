--lab 1 SQL

--8
SELECT employee_id, last_name,
       salary * 12 salariu_anual
       --salary * 12 "salariu anual"
       --salary * 12 "Salariu Anual"
FROM employees;

--9-12
desc employees

select * 
from   employees;

select *
from   tab;

desc user_tables

select table_name
from   user_tables;

--13
select employee_id, last_name, job_id, hire_date
from   employees;

--14
select job_id
from   employees;

select distinct job_id
from   employees;

select distinct job_id, department_id
from   employees;

--15
select rowid, rownum, last_name || ' ' ||first_name as "Nume si prenume"
from   employees;

--16
select first_name, salary
from   employees
where  salary >= 10000;

--17
select first_name, salary
from   employees
--where  salary between 5000 and 10000;
where salary >=5000 and salary<=10000;

--18
select last_name, first_name, salary sal
from   employees
--where  department_id in (10,30)
--where  department_id = 10 or department_id=30
--where  department_id in (10,30,null)
--where  department_id not in (10,30,null)
where  department_id not in (10,30)
--order by first_name;
--order by 1;
--order by sal; 
--order by salary;
--order by 3;
--order by salary ASC;
order by salary DESC;

--19

--20
desc dual
select * from dual;

select sysdate
from   dual;

SELECT SYSTIMESTAMP, CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM dual;

--21
select to_char(sysdate,'dd.mm.yyyy hh24:mi:ss')
from   dual;

--22
SELECT first_name, last_name, hire_date
FROM employees
--WHERE hire_date LIKE ('%87');
WHERE hire_date LIKE '%87';
--WHERE hire_date LIKE '%1987';

SELECT first_name, last_name, hire_date
FROM employees
--WHERE TO_CHAR(hire_date,'YYYY')= '1987';
--WHERE TO_CHAR(hire_date,'YYYY')= 1987;
--WHERE TO_CHAR(hire_date,'YYYY')= to_char(1987);
--WHERE extract(year from hire_date)= 1987;
WHERE TO_CHAR(hire_date,'mm.YYYY')= '06.1987';

--23
SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN to_date('10-FEB-1987') AND to_date('10-FEB-1990')
ORDER BY hire_date;

--24
SELECT last_name, job_id, salary
FROM   employees
--WHERE  manager_id IS NULL;
--WHERE  manager_id=NULL;
WHERE  manager_id IS not NULL;

--25
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
--ORDER BY salary DESC, commission_pct ASC;
ORDER BY salary DESC, commission_pct DESC;

--26
SELECT DISTINCT last_name
FROM employees
WHERE last_name LIKE '__a%';

--27
SELECT 'Suntem in' ||
       --TO_CHAR(sysdate, ' "Anul" YYYY "Luna" fmMONTH "Ziua" DD') data
       TO_CHAR(sysdate, ' "Anul" YYYY "Luna" MONTH "Ziua" DD') AS data
FROM DUAL;