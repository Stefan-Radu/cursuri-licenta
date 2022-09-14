alter user hr account unlock;

alter user hr identified by oracle;

create user bd identified by oracle;

grant connect to bd;
grant resource to bd;
grant create table to bd;
grant create view to bd;
grant create sequence to bd;
grant create synonym to bd;
grant unlimited tablespace to bd;
grant select any dictionary to bd;
