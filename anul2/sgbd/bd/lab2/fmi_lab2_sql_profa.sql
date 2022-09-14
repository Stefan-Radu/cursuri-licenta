--lab2 sql

--1
select LOWER('AbCd')
from   dual;

--2
select 'Func?ia salariatului '|| initcap(first_name) || ' ' 
       || upper(last_name) || ' este ' || lower(job_id) as info
from employees
where  department_id = 20;

--3
select employee_id, last_name, department_id
from   employees
--where  UPPER(TRIM(last_name)) = 'HIGGINS';
--where  last_name = UPPER(TRIM('HIGGINS'));
where  last_name = initcap(TRIM(' HIGGINS    '));

--4

--5
select last_name, first_name, round(sysdate-hire_date+1) as nr_zile_lucrate
from   employees;

--6

--7
select to_char(sysdate+10,'dd-mm-yyyy hh12:mi:ss AM PM a.m. p.m.') data
--from   dual;
from  employees;

--8
select floor(to_date('31-12-2020','dd-mm-yyyy')-sysdate) nr_zile_ramase
from   dual;

--9
select to_char(sysdate+12/24,'dd-mm-yyyy hh12:mi:ss PM') data
from   dual;

select to_char(sysdate+5/1440,'dd-mm-yyyy hh12:mi:ss PM') data
from   dual;

--10
--11
select employee_id, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) "luni lucrate"
from   employees
order by ROUND(MONTHS_BETWEEN(SYSDATE, hire_date));

--12
SELECT last_name
FROM employees
WHERE TO_CHAR(hire_date,'yyyy')=1994;
--WHERE TO_CHAR(hire_date,'yyyy')='1994';


SELECT last_name
FROM   employees
--WHERE  hire_date='07-JUN-1994';
WHERE  hire_date=to_date('07-06-1994','dd-mm-yyyy');


--SELECT employee_id||' '||last_name||' '||hire_date
SELECT to_char(employee_id)||' '||last_name||' '||to_char(hire_date)
FROM employees
WHERE department_id=10;

--13
select last_name||' '||first_name
from   employees
--where  to_char(hire_date,'mm')='05';
--where  to_char(hire_date,'fmmm')='5';
--where  to_char(hire_date,'mm')=5;
--where  extract(month from hire_date)=5;
--where  to_char(hire_date,'month')='may';
--where  to_char(hire_date,'fmmonth')='may';
--where  trim(to_char(hire_date,'month'))='may';
where  to_char(hire_date,'mon')='may';

--15
select last_name, salary, commission_pct, salary+salary*nvl(commission_pct,0) venit
from   employees
--where  salary+salary*nvl(commission_pct,0)>=10000;
where  salary+salary* (case when commission_pct is null then 0
                            else commission_pct 
                            end) >=10000;


--17
SELECT last_name, job_id, salary,
       DECODE(job_id, 'IT_PROG',  salary*1.1,
                      'ST_CLERK', salary*1.15,
                      'SA_REP',   salary*1.2,
                                  salary ) "salariu revizuit"
FROM employees;


SELECT last_name, job_id, salary,
       CASE job_id WHEN 'IT_PROG' THEN salary* 1.1
                   WHEN 'ST_CLERK' THEN salary*1.15
                   WHEN 'SA_REP' THEN salary*1.2
                   ELSE salary
       END "salariu revizuit"
FROM employees;

SELECT last_name, job_id, salary,
       CASE WHEN job_id= 'IT_PROG' THEN salary* 1.1
            WHEN job_id='ST_CLERK' THEN salary*1.15
            WHEN job_id ='SA_REP' THEN salary*1.2
            ELSE salary
       END "salariu revizuit"
FROM employees;


