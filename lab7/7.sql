-- 1: полный список фоновых процессов
select count(*) from v$bgprocess;
select * from v$bgprocess;

-- 2: фоновые процессы, которые запущены и работают в насто€щий момент
select sid, process, description, program 
    from v$session s join v$bgprocess using (paddr) 
    where s.status = 'ACTIVE';

-- 3: сколько процессов DBWn работает в насто€щий момент
show parameter db_writer_processes;
select count(*) 
    from v$session s join v$bgprocess using (paddr) 
    where s.status = 'ACTIVE' and description like '%writer%';

-- 4: перечень текущих соединений с инстансом
select username, sid, serial#, paddr, status from v$session where username is not null;

-- 5: их режимы
select username, server from v$session where username is not null;

-- 6: определить сервисы (точки подключени€ экземпл€ра)
select name, network_name, pdb from v$services;

-- 7: получить известные вам параметры диспетчера и их значений
show parameter dispatcher;

-- 9: перечень текущих соединений с инстансом. (dedicated, shared)
select process from v$session where username is not null;
select * from v$process;

-- 10: содержимое файла LISTENER.ORA
-- cat ./opt/oracle/product/21c/dbhomeXE/network/admin/samples/listener.ora
-- cat ./oradata/dbconfig/XE/listener.ora

--LISTENER =
--  (DESCRIPTION_LIST =
--    (DESCRIPTION =
--      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC_FOR_XE))
--      (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
--    )
--  )

-- 11: запустить утилиту lsnrctl и по€сните ее основные команды
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

-- 12: список служб инстанса, обслуживаемых процессом LISTENER
-- lsnrctl -> services