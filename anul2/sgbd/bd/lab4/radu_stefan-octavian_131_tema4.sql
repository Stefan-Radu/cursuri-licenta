-- Radu Stefan-Octavian - 131 - tema 4

-- 13

select count(employee_id) nr_of_employees
from employees
group by department_id
having department_id = 50
/

-- 14

select count(employee_id)
from employees
where commission_pct is not null
group by department_id
having department_id = 80
/
-- 15

select job_id, avg(salary) avg, sum(salary) total
from employees
group by job_id
-- having job_id = 'SA_MAN' or job_id = 'SA_REP'
having job_id in ('SA_MAN', 'SA_REP') -- ma gandeam eu ca merge si asa
/
-- 16

select department_id,
       min(salary) min, max(salary) max,
       round(avg(salary), 0) avg, sum(salary) total
from employees
where department_id is not null
group by department_id
/
-- 17

select department_id, sum(salary) sum, max(commission_pct)
from employees
where commission_pct is not null
group by department_id
having count(*) > 5
order by sum(salary)
/
-- 18

select first_name || ' ' || last_name name, aux.cnt 
from employees e, (select count(job_id) cnt, employee_id
                 from job_history
                 group by employee_id) aux
where e.employee_id = aux.employee_id 
      and aux.cnt >= 2
/
-- 19

select max(avg_sal.sal)
from (select avg(salary) sal
      from employees
      group by department_id) avg_sal
/
-- 20

select tabel1.cnt "1997",
       tabel2.cnt "1998",
       tabel3.cnt "1999",
       tabel4.cnt "2000",
       tabel_total.cnt total
from (select count(to_char(hire_date, 'yyyy')) cnt
     from employees
     group by to_char(hire_date, 'yyyy')
     having to_char(hire_date, 'yyyy') = '1997') tabel1,
     (select count(to_char(hire_date, 'yyyy')) cnt
     from employees
     group by to_char(hire_date, 'yyyy')
     having to_char(hire_date, 'yyyy') = '1998') tabel2,
     (select count(to_char(hire_date, 'yyyy')) cnt
     from employees
     group by to_char(hire_date, 'yyyy')
     having to_char(hire_date, 'yyyy') = '1999') tabel3,
     (select count(to_char(hire_date, 'yyyy')) cnt
     from employees
     group by to_char(hire_date, 'yyyy')
     having to_char(hire_date, 'yyyy') = '2000') tabel4,
     (select sum(count(to_char(hire_date, 'yyyy'))) cnt
     from employees
     group by to_char(hire_date, 'yyyy')
     having to_char(hire_date, 'yyyy') in ('1997', '1998', '1999', '2000')) tabel_total

-- am aflat ca merge si cu decode (putin) mai simplu
/
select tabel1.1997, tabel2."1998", tabel3."1999", tabel4."2000", tabel_total.total
from (select sum(decode(to_char(hire_date, 'yyyy'), 1997, 1, 0)) "1997"
     from employees) tabel1, 
     (select sum(decode(to_char(hire_date, 'yyyy'), 1998, 1, 0)) "1998"
     from employees) tabel2, 
     (select sum(decode(to_char(hire_date, 'yyyy'), 1999, 1, 0)) "1999"
     from employees) tabel3, 
     (select sum(decode(to_char(hire_date, 'yyyy'), 2000, 1, 0)) "2000"
     from employees) tabel4,
     (select sum(decode(to_char(hire_date, 'yyyy'), 1997, 1, 1998, 1, 1999, 1, 2000, 1, 0)) total
     from employees) tabel_total
/

-- apoi mi-am dat deama ca nu e nevoie chiar de 5 tabele in plus

select ext."1997", ext."1998", ext."1999", ext."2000", ext.total
from (select
     sum(decode(to_char(hire_date, 'yyyy'), 1997, 1, 0)) "1997",
     sum(decode(to_char(hire_date, 'yyyy'), 1998, 1, 0)) "1998",
     sum(decode(to_char(hire_date, 'yyyy'), 1999, 1, 0)) "1999",
     sum(decode(to_char(hire_date, 'yyyy'), 2000, 1, 0)) "2000",
     sum(decode(to_char(hire_date, 'yyyy'), 1997, 1, 1998, 1, 1999, 1, 2000, 1, 0)) total
     from employees) ext
/
