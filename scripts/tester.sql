/* I include this script to illustrate how I progressively developed the final script 
I uncomment scripts as needed and run in mysql e.g. source c:\\tester.sql
*/


/* user supersize (id: d421fd74-b2bf-4a15-9984-7954233f13e6) went to 1 event (id: fc361414-c435-4a85-8be2-d03512c39973)
that event has event date of Nov 10 (after Nov 1st)
25 other users also attended the same event (id: fc361414-c435-4a85-8be2-d03512c39973)
	select * from attendees where event_id = 'fc361414-c435-4a85-8be2-d03512c39973'
	
	
/* Phase 1: get events supersize (id: d421fd74-b2bf-4a15-9984-7954233f13e6) went to: fc361414-c435-4a85-8be2-d03512c39973 */
/*
select a1.event_id
from attendees a1
inner join users u1 on a1.user_id =  u1.user_id
where u1.email = 'supersize@subrational.com' 
*/

/*
 Phase 2: join to event table to bring in date check to only look at past events
 
select e1.event_date, e1.event_id, a1.user_id
from events e1
inner join attendees a1 on a1.event_id = e1.event_id
inner join users u1 on a1.user_id = u1.user_id
where u1.email = 'supersize@subrational.com'  AND e1.event_date < '2011-11-11'
*/


/*
 Phase 3: find all users who went to same events 
*/
/*
select u1.user_id
from users u1
inner join attendees a1 on a1.user_id = u1.user_id
where a1.event_id IN (
	select e1.event_id
	from events e1
	inner join attendees a1 on a1.event_id = e1.event_id
	inner join users u1 on a1.user_id = u1.user_id
	where u1.email = 'supersize@subrational.com'  AND e1.event_date < '2011-11-11')
	
/* Phase 4: Find all events for users who also went to that event	

select DISTINCT (a1.event_id)
from attendees a1 where a1.user_id IN (
select u1.user_id
from users u1
inner join attendees a1 on a1.user_id = u1.user_id
where a1.event_id = 'fc361414-c435-4a85-8be2-d03512c39973')
*/


/* Phase 5: find all events for other users 
select DISTINCT a1.event_id
from attendees a1 where a1.user_id IN (
  select u1.user_id
  from users u1
  inner join attendees a1 on a1.user_id = u1.user_id
  where a1.event_id
  IN (
	select e1.event_id
	from events e1
	inner join attendees a1 on a1.event_id = e1.event_id
	inner join users u1 on a1.user_id = u1.user_id
	where u1.email = 'supersize@subrational.com'  AND e1.event_date < '2011-11-15')
)

*/

/* Final phase: only return recommendations after the date, i.e. don't recommend events  in the past
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
	where u1.email = 'supersize@subrational.com'  AND e1.event_date < '2011-11-11')
) and e1.event_date > '2011-11-11'
*/

/* the procedure

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

*/



