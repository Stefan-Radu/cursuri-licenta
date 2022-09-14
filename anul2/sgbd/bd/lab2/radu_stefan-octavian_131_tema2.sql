-- Radu Stefan-Octavian - 131 - tema2

-- 18

select to_char(to_date(to_char(sysdate, 'mm'), 'mm'), 'DAY dd-mm-yyyy') as first_day_of_month,
       to_char(to_date(to_char(add_months(sysdate, 1), 'mm'), 'mm') - 1, 'DAY dd-mm-yyyy') as last_day_of_month
from dual
/

-- 19

select first_name, last_name, hire_date, next_day(add_months(hire_date, 6), 2) as negociere
from employees
/
-- 20

select first_name, last_name, nvl(department_id, 0)
from employees
/

-- 21

select first_name, last_name
from employees
where manager_id is null
/

-- 22

select first_name, last_name,
  case when manager_id is null then 'NU ARE BOSS'
    else to_char(manager_id)
  end manager
from employees
/

-- 23

select first_name, last_name, salary,
case when months_between(hire_date, sysdate) >= 200 then 1.20 * salary
     when months_between(hire_date, sysdate) >= 150 then 1.15 * salary
     when months_between(hire_date, sysdate) >= 100 then 1.10 * salary
     else 1.05 * salary
end REV_SALARY
from employees
/
