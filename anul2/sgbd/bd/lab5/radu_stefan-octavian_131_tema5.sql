-- Stefan-Octavian Radu - gr 131 - tema 5

-- 5 bonus

with
salaries as (
select distinct(salary)
from employees
order by salary desc
) -- toate salriile in ordine descrescatoare

select rownum, first_name || ' ' || last_name name, salary
from employees
where salary in
  (select salary
  from salaries
  where rownum <= 5) -- le selectez pe primele 5
/

-- 6

with 
worst_salaries as (
select d.department_id, min(salary)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id
)
select first_name, last_name, job_id, salary
from employees e
where (department_id, salary) in (select * from worst_salaries) 
-- where (department_id, salary) in (select * from worst_salaries) 
-- de ce nu pot face asa ?

-- 9

with 
non_empty_dep as(
select d.department_id
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id
having count(*) > 0
)
select department_name, department_id
from departments
where department_id not in (select * from non_empty_dep)
/

-- 10 

SELECT first_name, last_name, job_id, salary
FROM employees
WHERE salary > ALL (select salary
                   from employees
                   where job_id like '%' || 'CLERK')
/

-- daca inlocuiesc ALL cu ANY, atuci vor fi afisati cei care au salariul
-- mai mare dacat cel al cel putin unui CLERK 

-- 11

SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
select max(avg(salary))
from employees
group by department_id
)
/* SELECT first_name, last_name, salary */
/* FROM employees */
/* WHERE salary > ALL ( */
/* select avg(salary) */
/* from employees */
/* group by department_id */
/* ) */
/

-- 12 -- a

SELECT 'Total: ' || COUNT(*) NUMAR
FROM employees
where to_char(hire_date, 'yyyy') = '1997'
UNION
SELECT 'From 1997: ' || COUNT(*)  
FROM employees
/

-- 12 -- b

WITH 
all_empl AS (
SELECT COUNT(*) cnt
FROM employees),
few_empl AS (
SELECT COUNT(*) cnt
FROM employees
WHERE to_char(hire_date, 'yyyy') = '1997')
select a.cnt total, f.cnt "1997"
from all_empl a, few_empl f 
/

-- 13

select employee_id, job_title, department_name, hire_date
from employees e, jobs j, departments d
where e.job_id = j.job_id and e.department_id = d.department_id
UNION
select employee_id, job_title, department_name, start_date
from job_history jh, jobs j, departments d
where jh.job_id = j.job_id and jh.department_id = d.department_id
order by employee_id
/

-- 14

/* select first_name || ' ' || last_name, salary, department_id */
/* from employees */
/* where salary <= 3000 and department_id = 50 */
/* / */

select first_name || ' ' || last_name, salary, department_id
from employees
where salary <= 3000
INTERSECT
select first_name || ' ' || last_name, salary, department_id
from employees
where department_id = 50
/

-- 15

SELECT employee_id, job_id, department_id
FROM employees
INTERSECT
SELECT employee_id, job_id, department_id
FROM job_history
/

-- 16

with
empl as (
SELECT employee_id, job_id, department_id
FROM employees
INTERSECT
SELECT employee_id, job_id, department_id
FROM job_history)
SELECT employee_id, first_name || ' ' || last_name name, job_id, department_id
from employees
where employee_id in (select employee_id from empl)
/

-- 19

select rownum, employee_id, first_name || ' ' || last_name name
from employees
where salary > (select salary from employees where employee_id = 200)
/

-- 20

select department_name
from departments d
where exists (
select *
from employees e
where e.department_id = d.department_id
)
/

-- 21

select department_name
from departments
where department_id in (
select department_id
from employees
)
/

-- 22 

select job_id, salary
from (
select distinct job_id, avg(salary) salary
from employees
group by job_id
order by salary
)
where rownum <= 3
/

-- 23

with 
counted as (
select department_id, count(job_id) cnt
from employees
group by department_id
order by count(job_id) desc)
select department_id, cnt
from counted
where rownum <= 5
/

-- 24

select first_name || ' ' || last_name name
from employees e1
where not exists (
select job_id
from employees e2
where e2.manager_id = e1.employee_id)
/

-- 25

select first_name || ' ' || last_name name, hire_date
from employees
where (department_id, hire_date) in ( 
select department_id, min(hire_date)
from employees
group by department_id)
/

-- 26

with
empl as (select employee_id, department_id, hire_date hr
from employees
union
select employee_id, department_id, start_date hr
from job_history),
dep as (select department_id, min(hd)
from(
select department_id, min(hire_date) hd
from employees
group by department_id
union
select department_id, min(start_date) hd
from job_history
group by department_id)
group by department_id)
select first_name || ' ' || last_name name, empl.department_id, hr
from employees e, empl 
where e.employee_id = empl.employee_id
and (empl.department_id, empl.hr) in (select * from dep) 
/

-- 27

with 
bounds as (
  select lowest_sal ls, highest_sal hs
  from job_grades
  where grade_level = 1
),
chosen_dep as (
  select department_id
  from employees
  where salary between (select ls from bounds) and (select hs from bounds)
  group by department_id
  having count(employee_id) >= 2
)
select department_id, first_name || ' ' || last_name name
from employees
where department_id in (select * from chosen_dep)
/

-- 28 -- a

SELECT DISTINCT employee_id no_prev_jobs
FROM employees
MINUS
SELECT DISTINCT employee_id
FROM job_history
/

-- 28 -- b

SELECT DISTINCT employee_id no_prev_jobs
FROM employees
WHERE employee_id NOT IN (
  SELECT DISTINCT employee_id
  FROM job_history
)
/

-- 29

with
matched as(
  select employee_id, job_id, department_id
  from job_history
  minus
  select jh.employee_id, jh.job_id, jh.department_id
  from job_history jh, employees e
  where jh.employee_id = e.employee_id and 
        jh.department_id = e.department_id and
        jh.job_id = e.job_id
)
select employee_id, job_id, department_id
from employees
where employee_id in (select employee_id from matched)
/

-- 30 -- a

select location_id
from locations
minus
select location_id
from locations l
where exists (
  select department_id
  from departments d
  where d.location_id = l.location_id
)
/

-- 30 -- b

select location_id
from locations l
where not exists (
  select department_id
  from departments d
  where d.location_id = l.location_id
)
/

-- 30 -- c -- a

with
loc as (
  select location_id
  from locations
  minus
  select location_id
  from locations l
  where exists (
    select department_id
    from departments d
    where d.location_id = l.location_id
  )
)
select distinct city
from locations
where location_id in (select * from loc)
/

-- 30 -- c -- b

with
loc as (
  select location_id
  from locations l
  where not exists (
    select department_id
    from departments d
    where d.location_id = l.location_id
  )
)
select distinct city
from locations
where location_id in (select * from loc)
/

-- 31

select department_id, department_name
from departments d
where not exists (
  select employee_id
  from employees e
  where e.department_id = d.department_id
)
/

-- 32 -- a

select distinct l.location_id, city
from departments d, locations l
where l.location_id = d.location_id and
      department_id not in (
        select distinct department_id
        from employees
        where department_id is not null
      )
/

-- 32 -- b

with
deps as (
select department_id
from departments
MINUS
select distinct department_id
from employees
where department_id is not null
)
select distinct l.location_id, city
from departments d, locations l, deps
where d.department_id = deps.department_id and d.location_id = l.location_id
/

-- 32 -- c

select distinct l.location_id, city
from departments d, locations l
where d.location_id = l.location_id and
not exists (
  select *
  from employees e
  where e.department_id = d.department_id
)
/

-- 32 -- d

select distinct l.location_id, city
from locations l
right outer join departments d
on d.location_id = l.location_id 
where not exists (
  select *
  from employees e
  where e.department_id = d.department_id
)
/

-- 33

with
projects_202 as (
  select distinct project_id
  from work
  where employee_id = 202
)
select distinct e.employee_id, first_name || ' ' || last_name name
from employees e, work w
where e.employee_id = w.employee_id and
(
  select * from projects_202
  minus
  select distinct w2.project_id
  from work w2
  where w2.employee_id = w.employee_id) is null
/

-- 34

with
projects_202 as (
  select distinct project_id
  from work
  where employee_id = 202
)
select distinct e.employee_id, first_name || ' ' || last_name name
from employees e, work w
where e.employee_id = w.employee_id and
(
  select distinct w2.project_id
  from work w2
  where w2.employee_id = w.employee_id
  minus
  select * from projects_202) is null
/

-- 35

with
projects_202 as (
  select distinct project_id
  from work
  where employee_id = 202
)
select distinct e.employee_id, first_name || ' ' || last_name name
from employees e, work w
where e.employee_id = w.employee_id and (
  select distinct w2.project_id
  from work w2
  where w2.employee_id = w.employee_id
  minus
  select * from projects_202) is null and (
  select * from projects_202
  minus
  select distinct w2.project_id
  from work w2
  where w2.employee_id = w.employee_id) is null
/
