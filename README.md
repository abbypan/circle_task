# circle_task
circle task, alloc worker

for simple circle task, such as detect ip loc

no task fail check

no worker auto clean

## install 

    apt-get install cpanminus ansible
    cpanm SimpleDBI

    perl circle_task.pl

## database 

    MariaDB [dns]> desc ip_loc_task;
    +--------+-------------+------+-----+-------------------+-----------------------------+
    | Field  | Type        | Null | Key | Default           | Extra                       |
    +--------+-------------+------+-----+-------------------+-----------------------------+
    | time   | timestamp   | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
    | task   | varchar(20) | YES  |     | NULL              |                             |
    | worker | varchar(50) | YES  |     | NULL              |                             |
    +--------+-------------+------+-----+-------------------+-----------------------------+
    3 rows in set (0.00 sec)

    MariaDB [dns]> select * from ip_loc_task order by time asc limit 1;
    +---------------------+------+--------+
    | time                | task | worker |
    +---------------------+------+--------+
    | 2016-09-26 02:49:58 | 71   | NULL   |
    +---------------------+------+--------+
    1 row in set (0.00 sec)


    MariaDB [dns]> desc task_worker;
    +--------+-------------+------+-----+-------------------+-----------------------------+
    | Field  | Type        | Null | Key | Default           | Extra                       |
    +--------+-------------+------+-----+-------------------+-----------------------------+
    | time   | timestamp   | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
    | task   | varchar(20) | YES  |     | NULL              |                             |
    | worker | varchar(50) | YES  |     | NULL              |                             |
    +--------+-------------+------+-----+-------------------+-----------------------------+
    3 rows in set (0.00 sec)


    MariaDB [dns]> select * from task_worker where task='ip_loc';
    +---------------------+--------+-------------------+
    | time                | task   | worker            |
    +---------------------+--------+-------------------+
    | 2017-11-27 12:17:18 | ip_loc | task2.xxxxxx.com  |
    | 2017-11-27 12:17:36 | ip_loc | task.xxxxxx.com   |
    +---------------------+--------+-------------------+
    2 rows in set (0.00 sec)

