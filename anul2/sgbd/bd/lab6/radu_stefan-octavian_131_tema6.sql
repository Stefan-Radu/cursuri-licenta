-- Stefan-Octavian Radu - grupa 131 - tema 6

-- 6
insert into emp
select * from employees
where commission_pct >= 0.25
/

-- 7

insert first
  when salary <= 6000 then
  into emp1
  when salary < 10000 then
  into emp2
  else
  into emp3
select * from employees
/

-- 8

insert first
  when department_id = 80 then
  into emp0
  when salary <= 6000 then
  into emp1
  when salary <= 10000 then
  into emp2
  else
  into emp3
select * from employees

-- 19

delete from emp
where employee_id not in (
  select distinct employee_id
  from job_history
  union
  select distinct nvl(manager_id, 0)
  from departments
);

select * from emp;

rollback;

-- 20

variable empl_name varchar2(20);

delete from emp
where employee_id = &emp_id
returning first_name || ' ' || last_name into :empl_name;

print empl_name;

rollback;

-- 21

select first_name, salary, commission_pct
from emp
where department_id = 80;

update emp
set salary = salary + salary * nvl(commission_pct, 0),
    commission_pct = 0
where department_id = 80;

select first_name, salary, commission_pct
from emp
where department_id = 80;

rollback;

-- 22

update emp
set salary = (select avg(salary) from emp)
where employee_id in (
  select employee_id
  from emp e
  where (hire_date) = (
    select min(e2.hire_date)
    from emp e2
    where e.department_id = e2.department_id
    group by e2.department_id
  )
);

select first_name, salary
from emp;

rollback;

-- 23

update emp e1
set email = substr(last_name, 1, 1) || '_' || first_name
where salary = (
  select max(salary)
  from emp e2
  where e2.department_id = e1.department_id
  group by department_id
);

select first_name || ' ' || last_name, email
from emp;

rollback;

-- 24

variable name varchar2(20);
variable email varchar2(20);

update emp e1
set email = substr(last_name, 1, 1) || '_' || first_name
where employee_id = 200
returning first_name || ' ' || last_name, email
into :name, :email;

print name;
print email;

undefine name;
undefine email;

select first_name || ' ' || last_name, email
from emp;

rollback;

-- 25

accept emp_id;

select salary
from emp
where employee_id = &emp_id;

update emp
set salary = salary + 1000
where employee_id = &emp_id;

select salary
from emp
where employee_id = &emp_id;

rollback;
