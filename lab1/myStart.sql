--9 создаем таблицу
create table AEV_t(x number(3), s varchar2 (50));
--11 добавляем 3 строки в таблицу
insert into AEV_t values (1,'q');
insert into AEV_t values (2,'w');
insert into AEV_t values (3,'e');
select * from AEV_t;
commit;
--12 
update AEV_t set x = x * 2 where x<3;
select * from AEV_t;
commit;
--13 исп оператор select 
select * from AEV_t where x = 3;
select count(*) from AEV_t;
--14 исп оператор delete
delete from AEV_t where x = 3;
commit;
--15 создаем еще доп таблицу со связью
create table AEV_t1(x1 number(3),s varchar2 (10),constraint AEV_t_xkey foreign key(x1) references AEV_t(x));
--добавляем данные
insert into AEV_t1 values(2,'Q');
insert into AEV_t1 values(4,'W');
select * from AEV_t;
commit;
--16 исп select
--внутреннее соединение
select * from AEV_t inner join AEV_t1 on AEV_t.x = AEV_t1.x; 
--левое соединение
select * from AEV_t left outer join AEV_t1 on AEV_t.x = AEV_t1.x; 
--правое соединение
select * from AEV_t right outer join AEV_t1 on AEV_t.x = AEV_t1.x; 
-- соединение 
select * from AEV_t full outer join AEV_t1 on AEV_t.x = AEV_t1.x; 
-- перекрестное соединение 
select * from AEV_t cross join AEV_t1; 
--18 исп drop
drop table AEV_t; 
drop table AEV_t1; 