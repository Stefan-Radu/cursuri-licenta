-- Radu Stefan-Octavian - 131 - tema 1

-- 1

select denumire, (
  select count(*)
  from imprumuta, carte, domeniu d2
  where cod_carte = id_carte
  and   cod_domeniu = id_domeniu
  and   d1.denumire = d2.denumire
  and   dataef is null
) cnt
from domeniu d1;

-- 2

select id_cititor, nume, (
  select count(cod_cititor)
  from imprumuta
  where id_cititor = cod_cititor 
  and (
    (dataef is not null and dataef > datares)
    or (dataef is null and sysdate > datares)
  )
) cnt
from cititor
where (
  select count(cod_cititor)
  from imprumuta
  where id_cititor = cod_cititor 
  and (
    (dataef is not null and dataef > datares)
    or (dataef is null and sysdate > datares)
  )
) > 1; 

-- 3

select denumire
from domeniu
where not exists (
  select *
  from carte
  where cod_domeniu = id_domeniu
);

-- 4

select denumire, nvl(titlu, 'Nu are carti') carte
from domeniu
left join carte on id_domeniu = cod_domeniu; 

-- 5

with 
pr as (
  select pret
  from carte
  where titlu = 'CarteInfo4'
  and   autor = 'Autor3'
)
select titlu, carte.pret
from carte, pr
where carte.pret > pr.pret;

-- 6

select distinct cod_cititor, nume
from imprumuta, cititor
where cod_cititor = id_cititor
and   dataef is null
and   sysdate > datares
order by cod_cititor;

-- 7

select distinct nume, nvl(titlu, 'Nu a citit') titlu
from cititor, imprumuta, domeniu, carte
where id_cititor (+) = cod_cititor
and   cod_domeniu = id_domeniu
and   denumire = 'Informatica'
and   cod_carte = id_carte;

-- 8

select titlu
from carte, domeniu
where autor is null
and   cod_domeniu = id_domeniu
and   denumire = 'Informatica'

-- 9

select nume
from cititor
where not exists (
  select id_carte
  from carte
  where autor = 'Autor5'
  minus
  select id_carte
  from carte, imprumuta
  where cod_carte = id_carte
  and   cod_cititor = id_cititor
  and   autor = 'Autor5'
);

-- 10

delete from imprumuta_aux;

select * from imprumuta_aux;

insert into imprumuta_aux
select * from imprumuta;

select * from imprumuta_aux;

rollback;

select * from imprumuta_aux;

-- 11

-- a

create table carte_info as select * from carte where 1 = 0;
create table carte_lit as select * from carte where 1 = 0;

-- b

insert first
  when cod_domeniu = (
    select id_domeniu
    from domeniu
    where denumire = 'Informatica'
  ) then
    into carte_info
  when cod_domeniu = (
    select id_domeniu
    from domeniu
    where denumire = 'Literatura'
  ) then
    into carte_lit
  select *
  from carte
;

-- c

create carte_rest as 
select *
from carte, domeniu
where cod_domeniu = id_domeniu
and (denumire = 'Informatica' or denumire = 'Literatura')
and not exists (
  select *
  from imprumuta
  where cod_carte = id_carte
);

-- 12

variable var_id_carte number;

insert into carte_aux
values(&v_id_carte, '&v_titlu_carte', '&v_autor', &v_pret, &v_nrex, &v_cod_domeniu)
returning id_carte
into :var_id_carte;

print var_id_carte;

-- 13

variable var_titlu varchar2(20);

select * from carte_aux;

delete from carte_aux
where id_carte = 20
returning titlu
into :var_titlu;

select * from carte_aux;

print var_titlu;
undefine var_titlu;

-- 14

variable var_titlu varchar2(20);

select * from carte_aux;

update carte_aux
set pret = pret + 10
where id_carte = 101
returning titlu
into :var_titlu;

select * from carte_aux;

print var_titlu;

undefine var_titlu;

-- 15

update carte_aux
set nrex = nrex * 2
where id_carte in (
  select id_carte
  from carte
  where (
    select count(*)
    from imprumuta
    where cod_carte = id_carte
  ) = (
    select max(count(*))
    from imprumuta
    group by cod_carte
  )
);
