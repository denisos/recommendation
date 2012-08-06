/*
MySql scripts to: 
- create referrals database and users, events and attendees tables.
    I commented out the foreign keys in attendees for now since loading unloading data but would be uncommented in a final update
- create getrecommendations stored procedure
- commands to load the data files (commented out currently). Note for c:\\attendees-csv.csv I had to terminate line with '\r\n'.

Using InnoDB since I assume these tables will be updated in future and need to support transactions.
*/

CREATE DATABASE IF NOT EXISTS referrals CHARACTER SET utf8;

USE referrals;

DROP TABLE IF EXISTS attendees, users, events;

CREATE TABLE users (
  user_id varchar(50) NOT NULL,
  email varchar(254) NOT NULL,
  PRIMARY KEY (user_id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Users table' ;

CREATE TABLE events (
  event_id varchar(50) NOT NULL,
  event_date datetime NOT NULL,
  PRIMARY KEY (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Events table' ;

CREATE TABLE attendees (
  user_id varchar(50) NOT NULL,
  event_id varchar(50) NOT NULL,
--  FOREIGN KEY (user_id) REFERENCES users (user_id),
--  FOREIGN KEY (event_id) REFERENCES events (event_id),
  INDEX event_id_idx (event_id),
  INDEX user_id_idx (user_id)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Events to Users relationship table' ;

/* Create stored procedure to retrieve recommendations */
DROP PROCEDURE IF EXISTS referrals.getrecommendations ;

DELIMITER $$
CREATE PROCEDURE referrals.getrecommendations(IN email VARCHAR(254), IN dateToUse VARCHAR(10))
BEGIN
	select DISTINCT a1.event_id
	from events e1
	inner join attendees a1 on e1.event_id = a1.event_id
	where a1.user_id IN (
	  select u1.user_id
	  from users u1
	  inner join attendees a1 on a1.user_id = u1.user_id
	  where a1.event_id
	  IN (
		select e1.event_id
		from events e1
		inner join attendees a1 on a1.event_id = e1.event_id
		inner join users u1 on a1.user_id = u1.user_id
		where u1.email = email  AND e1.event_date < dateToUse)
	) and e1.event_date >= dateToUse;
END $$
DELIMITER ;

/* 
mysql to load events csv data:
load data local infile 'c:\\events-csv.csv' into table events fields terminated by ',' lines terminated by '\n' (event_id, @var1) set event_date = STR_TO_DATE(@var1, '%m/%d/%Y %H:%i');

mysql to load users csv data:
load data local infile 'c:\\users-csv.csv' into table users fields terminated by ',' lines terminated by '\n';

mysql to load attendees csv:
mysql> load data local infile 'c:\\attendees-csv.csv' into table attendees fields terminated by ',' lines terminated by '\r\n';
*/

