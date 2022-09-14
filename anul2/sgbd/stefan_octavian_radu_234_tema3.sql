-- Stefan-Octavian Radu - Tema 3

--2

CREATE TABLE octombrie_sor (
	id int,
	borrow_date DATE,
	borrow_count int
);

EXTRACT DAY FROM last_day(sysdate) FROM dual;

SET SERVEROUTPUT ON;
DECLARE
    rentals NUMBER(3) := 0;
    last_oct_day NUMBER(3) := extract(day FROM last_day(sysdate));
BEGIN
    FOR i IN 1..d LOOP
        select count(*) into rentals FROM rental 
        where extract(day FROM book_date) = i
        	and extract(month FROM book_date) = extract(month from sysdate);
        
        INSERT INTO octombrie_sor VALUES (i, TO_DATE(i ||' 10'||' 2020', 'DD MM YYYY'), rentals);
    END LOOP;
END;