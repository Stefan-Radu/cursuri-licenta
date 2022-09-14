-- Stefan-Octavian Radu - grupa 131 - tema 3

-- 23

select first_name, last_name, manager_id
from employees
where manager_id = (
select manager_id
from employees
where employee_id = 140
)
/

-- 24

select department_name
from departments d, locations l, countries c
where d.location_id = l.location_id
and   l.country_id = c.country_id
and   upper(c.country_name) = 'UNITED STATES OF AMERICA'
/

-- 25

select a.first_name angajat, boss.first_name sefu, boss_de_boss.first_name sefu_lu_sefu
from employees a, employees boss, employees boss_de_boss
where a.manager_id = boss.employee_id
and   boss.manager_id = boss_de_boss.employee_id
/

-- 26

select e.first_name, e.last_name, e.hire_date, j.job_title
from employees e, jobs j
where e.job_id = j.job_id
and   to_char(e.hire_date, 'mm') = '03'
/

-- 27

select e.first_name, e.last_name, e.salary + (e.salary * nvl(0, e.commission_pct)) total_salary, d.department_name
from employees e, departments d
where e.department_id = d.department_id
and   e.salary + (e.salary * nvl(0, e.commission_pct)) > 12000
/

-- 28

select e.employee_id, j.job_title, jh.start_date, jh.end_date
from employees e, job_history jh, jobs j
where jh.employee_id = e.employee_id
and   jh.job_id = j.job_id
/

-- 29

select e.employee_id, e.first_name || ' ' || e.last_name name, e.job_id now_job_id, j.job_title past_job_title, jh.start_date, jh.end_date
from employees e, job_history jh, jobs j
where jh.employee_id = e.employee_id
and   jh.job_id = j.job_id
/
-- 30

select e.employee_id, e.first_name || ' ' || e.last_name name,
       e.job_id now_job_id, jn.job_title now_job_title,
       j.job_title past_job_title, jh.start_date, jh.end_date
from employees e, job_history jh, jobs j, jobs jn
where jh.employee_id = e.employee_id
and   jh.job_id = j.job_id
and   jn.job_id = e.job_id

-- 31/

select e.employee_id, e.first_name || ' ' || e.last_name name,
       e.job_id now_job_id, jn.job_title now_job_title,
       j.job_title past_job_title, j.job_id, jh.start_date, jh.end_date
from employees e, job_history jh, jobs j, jobs jn
where jh.employee_id = e.employee_id
and   jh.job_id = j.job_id
and   jn.job_id = e.job_id
and   e.job_id in (
select job_id
from job_history
where employee_id = e.employee_id)
/

-- 32 

select e.employee_id, e.first_name || ' ' || e.last_name name,
       e.job_id now_job_id, jn.job_title now_job_title, d_now.department_name,
       j.job_title past_job_title, j.job_id, d_then.department_name, jh.start_date, jh.end_date
from employees e,
     job_history jh, jobs j, jobs jn,
     departments d_now, departments d_then
where jh.employee_id = e.employee_id
and   jh.job_id = j.job_id
and   jn.job_id = e.job_id
and   e.job_id in (
select job_id
from job_history
where employee_id = e.employee_id)
and   d_now.department_id = e.department_id
and   jh.department_id = d_then.department_id
/
-- 33

select e.employee_id, e.first_name || ' ' || e.last_name name,
       e.job_id now_job_id, jn.job_title now_job_title, d_now.department_name,
       j.job_title past_job_title, j.job_id, d_then.department_name, jh.start_date, jh.end_date
from employees e,
     job_history jh, jobs j, jobs jn,
     departments d_now, departments d_then
where jh.employee_id = e.employee_id
and   jh.job_id = j.job_id
and   jn.job_id = e.job_id
and   e.job_id in (
select job_id
from job_history
where employee_id = e.employee_id
and   department_id <> e.department_id
)
and   d_now.department_id = e.department_id
and   jh.department_id = d_then.department_id
/
