-- 1: ������ ������ ������� ���������
select count(*) from v$bgprocess;
select * from v$bgprocess;

-- 2: ������� ��������, ������� �������� � �������� � ��������� ������
select sid, process, description, program 
    from v$session s join v$bgprocess using (paddr) 
    where s.status = 'ACTIVE';

-- 3: ������� ��������� DBWn �������� � ��������� ������
show parameter db_writer_processes;
select count(*) 
    from v$session s join v$bgprocess using (paddr) 
    where s.status = 'ACTIVE' and description like '%writer%';

-- 4: �������� ������� ���������� � ���������
select username, sid, serial#, paddr, status from v$session where username is not null;

-- 5: �� ������
select username, server from v$session where username is not null;

-- 6: ���������� ������� (����� ����������� ����������)
select name, network_name, pdb from v$services;

-- 7: �������� ��������� ��� ��������� ���������� � �� ��������
show parameter dispatcher;

-- 9: �������� ������� ���������� � ���������. (dedicated, shared)
select process from v$session where username is not null;
select * from v$process;

-- 10: ���������� ����� LISTENER.ORA
-- cat ./opt/oracle/product/21c/dbhomeXE/network/admin/samples/listener.ora
-- cat ./oradata/dbconfig/XE/listener.ora

--LISTENER =
--  (DESCRIPTION_LIST =
--    (DESCRIPTION =
--      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC_FOR_XE))
--      (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
--    )
--  )

-- 11: ��������� ������� lsnrctl � �������� �� �������� �������
-- lsnrctl:
    --start
    --stop
    --status
    --services
    --servacls
    --version
    --reload
    --save_config     
    --trace
    --quit
    --exit            
    --set
    --show

-- 12: ������ ����� ��������, ������������� ��������� LISTENER
-- lsnrctl -> services