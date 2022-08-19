/* You vaguely remember that the crime was a ​murder​ 
	that occurred sometime on ​Jan.15, 2018​ and that 
	it took place in ​SQL City​. 
*/

select * from crime_scene_report
where type = 'murder'
and date = '20180115'
and city = 'SQL City';
            
--Security footage shows that there were 2 witnesses. 
--The first witness lives at the last house on "Northwestern Dr". 'Northwestern Dr',
--The second witness, named Annabel, lives somewhere on "Franklin Ave".


select *
from person
join interview on person.id = interview.person_id
where person.address_street_name in ('Franklin Ave')
and name like '%Annabel%';

--Annabel - person ID = 16371
--I saw the murder happen, and I recognized the killer from my gym 
--when I was working out last week on January the 9th.
            
		
select *
from person
join interview on person.id = interview.person_id
where person.address_street_name in ('Northwestern Dr')
and address_number = (select max(address_number) from person 
					  where address_street_name in ('Northwestern Dr'));
													
--Morty - person ID = 14887
--I heard a gunshot and then saw a man run out. 
--He had a "Get Fit Now Gym" bag. 
--The membership number on the bag started with "48Z". 
--Only gold members have those bags. 
--The man got into a car with a plate that included "H42W".	


select * 
from get_fit_now_member a 
join get_fit_now_check_in b on a.id = b.membership_id
join person c on a.person_id = c.id 
join drivers_license d on c.license_id = d.id 
where check_in_date =  20180109 --clue from annabel
and a.id like '48Z%' --clue from morty
and a.membership_status = 'gold' --clue from morty
and d.plate_number like '%H42W%' --clue from morty
;
--one person - Jeremy Bowers person_id = 67318

/* Insert guess */
insert into solution values(1,"Jeremy Bowers");

/* Check Solution */
select value from solution;

--Congrats, you found the murderer! 
--But wait, there's more... If you think you're up for a challenge, 
--try querying the interview transcript of the murderer to find the real villain behind this crime. 
--If you feel especially confident in your SQL skills, 
--try to complete this final step with no more than 2 queries. 
--Use this same INSERT statement with your new suspect to check your answer.

/* Checking his alibi */
select * from interview
where person_id in (67318);

--I was hired by a woman with a lot of money. 
--I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
--She has red hair and she drives a Tesla Model S. 
--I know that she attended the SQL Symphony Concert 3 times in December 2017.

/* Finding real mastermind */
SELECT
	*
from 
(select
	person_id,
	count(*) as events
from facebook_event_checkin
where lower(event_name) like '%sql%symphony%concert%'
and date between 20171201 and 20171231
group by 1) t1 
join person p on t1.person_id = p.id 
join drivers_license d on p.license_id = d.id 
left join income e on p.ssn = e.ssn
where events = 3
;

--1 woman fits the description, Miranda Priestly
-- $310K salary, 66in height, red hair, Tesla, attended concert 3 times

/* Making guess */
insert into solution values(1,"Miranda Priestly");

/* Checking solution */
select value from solution;

--Congrats, you found the brains behind the murder! 
--Everyone in SQL City hails you as the greatest SQL detective of all time. 
--Time to break out the champagne!