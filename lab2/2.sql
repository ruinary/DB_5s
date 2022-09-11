--1
create tablespace ts_AEV
datafile 'ts_AEV.dbf'
size 7 m
autoextend on next 5 m
maxsize 20 m
extent management local;

--2
create temporary tablespace ts_AEV_temp
tempfile 'ts_AEV_temp.dbf'
size 5 m
autoextend on next 3 m
maxsize 30 m
extent management local;

--3
select tablespace_name, status, 
contents logging 
from sys.dba_tablespaces;

select file_name, tablespace_name, 
status, maxbytes, user_bytes
from dba_data_files
union
select file_name, tablespace_name, 
status, maxbytes, user_bytes
from dba_temp_files;

--4
-- чинит ошибку ORA-65096 при создании юзеров/ролей/др. с нестандартными именами
alter session set "_ORACLE_SCRIPT"=true;

create role rl_AEVcore;
grant connect,
create table,
drop any table,
create view,
drop any view,
create procedure, 
drop any procedure
to rl_AEVcore;
commit;

--5
select * from sys.dba_roles;
select * from sys.dba_roles where role like '%AEV%';
select * from dba_sys_privs where grantee like '%AEV%';

--6
create profile pf_AEVcore limit
password_life_time 180
sessions_per_user 3
failed_login_attempts 7
password_lock_time 1
password_reuse_time 10
password_grace_time default 
connect_time 180
idle_time 30;
commit;

--7
select * from dba_profiles where profile like '%AEV%';
select * from dba_profiles where profile = 'DEFAULT';

--8
create user AEVcore 
identified by qqqq
default tablespace ts_AEV quota unlimited on ts_AEV
temporary tablespace ts_AEV_temp
profile pf_AEVcore
account unlock
password expire;
grant rl_AEVcore to AEVcore;

--10
create table AEVcore_table (i int, j int);

insert into AEVcore_table (i, j) values (1, 111);
insert into AEVcore_table (i, j) values (2, 222);
select * from AEVcore_table;

create view AEVcore_view as select * from AEVcore_table;
select * from AEVcore_view;
commit;

--11
create tablespace AEV_qdata
datafile 'AEV_qdata.dbf'
size 10m
autoextend on next 5m
maxsize 30m
offline;
alter tablespace AEV_qdata online;

alter user AEVcore quota 2m on AEV_qdata;

create table AEV_t1 (str varchar(50)) tablespace AEV_qdata;
insert into  AEV_t1 values ('1');
insert into  AEV_t1 values ('2');
insert into  AEV_t1 values ('3');
select * from  AEV_t1;

commit;