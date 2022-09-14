-- Lab 3

SELECT last_name, department_name, location_id, e.department_id
FROM employees e, departments d
WHERE e.department_id = d.department_id;

SELECT last_name, salary, grade_level
FROM employees, job_grades
WHERE salary BETWEEN lowest_sal AND highest_sal;

SELECT last_name, department_name,location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);