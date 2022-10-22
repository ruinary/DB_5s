--1 �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. ���������� �� ������� ���������.
select * from v$pdbs;

--2 ��������� ������ � ORA12W, ����������� �������� �������� �����������.
select * from v$instance;

--3 ��������� ������ � ORA12W, ����������� �������� �������� ������������� ����������� ���� Oracle 12c � �� ������ � ������. 
select * from product_component_version;

--4 �������� ����������� ��������� PDB � ������ XXX_PDB, ��� XXX � �������� ��������. 
create pluggable database AEV_pdb admin user AEV_pdb_admin identified by qwerty
    storage (maxsize 2 g)
    default tablespace ts_AEV_pdb
        datafile '/vrl_AEV/ts_AEV_pdb.dbf' size 250 m autoextend on
    path_prefix ='/vrl_AEV/'
    file_name_convert =('/pdbseed/','/vrl_pdb/');

--5 �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. ���������, ��� ��������� PDB-���� ������ ����������.
select * from dba_pdbs;

--6 ������������ � XXX_PDB. �������� ���������������� ������� (��������� ������������, ����, ������� ������������, ������������ � ������ U1_XXX_PDB).

-- sqlplus conn /as sysdba
alter pluggable database AEV_pdb open;

alter session set "_ORACLE_SCRIPT"=true;
commit;
--alter session set container = CDB$ROOT;
alter session set container = AEV_pdb;
--alter session set optimizer_dynamic_sampling=0;

create tablespace ts_AEV_pdb 
    datafile 'ts_AEV_pdb.dbf'
    size 7 m
    autoextend on next 5 m
    maxsize 20 m
    extent management local;
    
create temporary tablespace ts_AEV_pdb_temp
    tempfile 'ts_AEV_pdb_temp.dbf'
    size 5 m
    autoextend on next 3 m
    maxsize 30 m
    extent management local;
    
select tablespace_name, status, 
    contents logging 
    from sys.dba_tablespaces;

create role rl_AEV_pdb;

grant connect, 
create session, 
alter session, 
create any table, 
drop any table, 
create any view, 
drop any view, 
create any procedure, 
drop any procedure
to rl_AEV_pdb;
   
--grant SYSDBA to rl_AEV_pdb;
   
commit;

create profile pf_AEV_pdb limit
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default 
    connect_time 180
    idle_time 30;
    
commit;

create user user_AEV_pdb 
    identified by qwerty
    default tablespace ts_AEV_pdb quota unlimited on ts_AEV_pdb
    temporary tablespace ts_AEV_pdb_temp
    profile pf_AEV_pdb
    account unlock;
    
grant rl_AEV_pdb to user_AEV_pdb;

select * from dba_users where USERNAME like '%AEV%';

-- 7 ������������ � ������������ U1_XXX_PDB, � ������� SQL Developer, �������� ������� XXX_table, �������� � ��� ������, ��������� SELECT-������ � �������.

-- ����������� ���������� �� user_AEV_pdb � AEV_pdb
--conn user_AEV_pdb /as sysdba
create table AEV_pdb_table (i int, j int);
insert into AEV_pdb_table (i, j) values (1, 111);
insert into AEV_pdb_table (i, j) values (2, 222);
select * from AEV_pdb_table;

-- 8 �����������, ��� ��������� ������������, ���  ����� (������������ � ���������), ��� ���� (� �������� �� ����������), ������� ������������, ���� �������������  ���� ������ XXX_PDB �  ����������� �� ����.
select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_temp_files;
select * from dba_roles;
select grantee, privilege from dba_sys_privs;
select * from dba_profiles;
select * from all_users;

-- 9
alter session set container = CDB$ROOT;

create user c##AEV identified by qwerty;
grant connect, create session, alter session, create any table,
drop any table to c##AEV  container = all;

-- PDB Connection - 
alter session set container = AEV_pdb;
create table AEV_PDB (num number, str varchar(40));

select table_name, tablespace_name from ALL_TABLES where table_name Like '%AEV%';

-- CDB Connection - 
alter session set container = CDB$ROOT;
create table AEV_CDB (num number, str varchar(40));

select table_name, tablespace_name from ALL_TABLES where table_name Like '%AEV%';

--13
select * from DBA_PDBS;
alter pluggable database AEV_pdb close;
drop PLUGGABLE DATABASE AEV_pdb INCLUDING DATAFILES;
drop user c##AEV;
drop table AEV_pdb_table;

select * from dba_tablespaces where tablespace_name Like '%AEV%';
select * from dba_data_files where tablespace_name Like '%AEV%';
select * from dba_temp_files where tablespace_name Like '%AEV%';
select * from dba_roles where role Like '%AEV%';
select * from dba_profiles where profile Like '%AEV%';
select * from all_users where username Like '%AEV%';
