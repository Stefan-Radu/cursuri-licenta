--lab 1 SQL

--8
SELECT employee_id, last_name,
       --salary * 12 salariu_anual
       --salary * 12 "salariu anual"
       salary * 12 "Salariu Anual"
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

--20
desc dual

select * from dual;

select sysdate
from dual;

select systimestamp, current_timestamp, localtimestamp
from dual;

--21

select to_char(sysdate, 'dd.mm.yyy hh24:mi:ss')
from dual;

--22

select first_name, last_name, hire_date
from employees
where to_char(hire_date, 'YYYY') = '1987';
-- where hire_date like ('%87')
-- where to_char(hire_date 'YYYY') = to_char(1987) 
-- where to_char(hire_date 'YYYY') = 1987
-- where extract(year from hire_date) = 1987
-- wher eto_char(hire_date, 'mm.YYYY') = '06.1987'

--23

select first_name, last_name, job_id, hire_date
from employees
-- where hire_date between '10-FEB-1987' and '10-FEB-1990'
where hire_date between to_date('10-FEB-1987') and to_date('10-FEB-1990')
order by hire_date;

--24

select last_name, first_name
from employees
--where manager_id is null;
--where manager_id=null;
where manager_id is not null;

--25

select last_name, salary, commission_pct
from employees
where commission_pct is not null
order by salary desc, commission_pct desc;

--26 tema - daca caut '%' sau '_'

SELECT DISTINCT last_name
FROM employees
WHERE last_name LIKE '__a%';

-- 27 -- fm scoate spatiul de dupa

SELECT 'Suntem in' ||
--TO_CHAR(sysdate, ' "Anul" YYYY "Luna" fmMONTH "Ziua" DD') data
TO_CHAR(sysdate, ' "Anul" YYYY "Luna" MONTH "Ziua" DD') as data -- data e alias
FROM DUAL;

