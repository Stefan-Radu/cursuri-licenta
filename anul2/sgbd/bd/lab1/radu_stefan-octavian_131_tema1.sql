-- Radu Stefan-Octavian - 131 - tema 1

-- 28
select to_char(sysdate, '"Ziua de azi:" fmDAY, fmD, fmDD, fmDDD') as current_date
from dual
/

-- 29

select department_name
from departments
where location_id = 1700 and department_id is not null
/

-- 30

select distinct department_id
from employees
where department_id is not null
/

-- 31

select first_name, last_name
from employees
where to_char(hire_date, 'mm-yyyy') = '06-1987'
/

-- 32 ??

-- 33

select first_name, hire_date
from employees
where department_id = 80 and to_char(hire_date, 'mm-yyyy') = '03-1997'
/

-- 34

select job_title
from jobs
where max_salary > 8000
/

-- 35

select *
from employees
where manager_id = 123

/

-- 36

select first_name, salary, commission_pct, salary + (salary * commission_pct) as total_revenue
from employees
where commission_pct is not null and commission_pct <= 0.25
/
