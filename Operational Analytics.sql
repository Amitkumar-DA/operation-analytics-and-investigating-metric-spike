Create database Project3;
Use Project3;

# Case 1
Create table job_data (ds date, 
job_id int not null, 
actor_id int not null, 
event varchar(20) not null, 
language varchar(20) not null, 
time_spent int not null,
org char(2));

INSERT INTO job_data 
(ds, job_id, actor_id, event, language, time_spent, org)
VALUES 
('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
('2020-11-28', 24, 1005, 'transfer', 'Persian', 22, 'D'),
('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'A');

## Task1 (Jobs Reviewed Over Time)
Select AVG(t) AS 'avg jobs reviewed per day per hour',
AVG(p) AS 'avg jobs reviewed per day per second'
FROM (Select DS, ((COUNT(job_id)*3600)/SUM(time_spent)) AS t,
((COUNT(job_id))/SUM(time_spent)) AS p
FROM job_data
Where Month(ds)= 11
Group by ds) a;

##Task2 (Throughput Analysis):
Select Round(Count(event)/Sum(time_spent), 2) AS 'Weekly Throughput' FROM job_data;

Select ds as Dates, Round(Count(event)/Sum(time_spent),2) AS 'Daily Throughput' 
From job_data
Group by ds
Order by ds;

## Task3 (Language Share Analysis)
Select language as Languages, Round(100*Count(*)/total, 2) AS Percentage, sub.total
From job_data
Cross join (Select count(*) as total From job_data) AS sub
Group by language, sub.total;

##Task4 (Duplicate Rows Detection)
Select actor_id, Count(*) AS Duplicates
From job_data
Group by actor_id having Count(*)>1;



# Case 2

#Table1 - Users
Create table users(
user_id int,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50)
);

SHOW VARIABLES LIKE 'secure_file_priv';

Load Data Infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
Into Table users
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
ignore 1 rows;

Alter table users add column temp_created_at datetime;
SET SQL_SAFE_UPDATES = 0;
UPDATE users
SET temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
Alter Table users Drop column created_at;
Alter Table users Change Column temp_created_at created_at Datetime;

Select * From users;

# Table 2 events
Create Table events (
user_id int,
occured_at varchar(100),
event_type varchar(50),
event_name varchar(100),
location varchar(50),
device varchar(50),
user_type int
);

Load Data Infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
Into Table events
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
ignore 1 rows;

Select * from events;

Alter table events add column temp_occured_at datetime;
SET SQL_SAFE_UPDATES = 0;
UPDATE events
SET temp_occured_at = STR_TO_DATE(occured_at, '%d-%m-%Y %H:%i');
Alter Table events Drop column occured_at;
Alter Table events Change Column temp_occured_at occured_at Datetime;

# Case 3
Create table email_events(
user_id int,
occured_at varchar(100),
action varchar(100),
user_type int
);

Load Data Infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
Into Table email_events
Fields terminated by ','
Enclosed by '"'
Lines terminated by '\n'
ignore 1 rows;

Select * from email_events;

Alter table email_events add column temp_occured_at datetime;
SET SQL_SAFE_UPDATES = 0;
UPDATE email_events
SET temp_occured_at = STR_TO_DATE(occured_at, '%d-%m-%Y %H:%i');
Alter Table email_events Drop column occured_at;
Alter Table email_events Change Column temp_occured_at occured_at Datetime;

## Task 1 (Weekly User Engagement)
Select extract(week from occured_at) as week_number,
Count(distinct user_id) AS active_users
From events
Where event_type = 'engagement'
group by week_number
order by week_number;

## Task 2 (User Growth Analysis)
Select year, week_num, num_users, sum(num_users)
Over (order by year, week_num) as cum_users
From (
Select extract(year from created_at) as year, 
extract(week from created_at) as week_num , 
count(distinct user_id) as num_users
from users
group by year, week_num
order by year, week_num) sub;

## Task 3 (Weekly Retention Analysis)
With CTE1  as (
Select distinct user_id, extract(week from occured_at) as signup_week
from events
where event_type = 'signup_flow'
and event_name = 'complete_signup' and extract(week from occured_at) = 18),
CTE2 as (select distinct user_id, extract(week from occured_at) as engagement_week
from events
where event_type = 'engagement')
select count(user_id) as total_engaged_users,
sum(case when retention_week> 8 then 1 else 0 end) as retained_users
from (select a.user_id, a.signup_week, b.engagement_week, b.engagement_week-a.signup_week as retention_week
from CTE1 a
left join CTE2 b 
on a.user_id=b.user_id) sub;

## Task 4 (Weekly Engagement Per Device)
SELECT
    EXTRACT(YEAR FROM occured_at) AS year,
    EXTRACT(WEEK FROM occured_at) AS week_num,
    device,
    COUNT(DISTINCT user_id) AS engaged_users
FROM events
WHERE event_type = 'engagement'
  AND event_name = 'login'
GROUP BY
    EXTRACT(YEAR FROM occured_at),
    EXTRACT(WEEK FROM occured_at),
    device
ORDER BY
    year,
    week_num,
    device;
    
    
## Task 5 (Email Engagement Analysis)
SELECT
    EXTRACT(YEAR FROM occured_at) AS year,
    EXTRACT(WEEK FROM occured_at) AS week_num,

    COUNT(CASE
            WHEN action IN ('sent_weekly_digest',
                            'sent_reengagement_email')
            THEN 1
          END) AS emails_sent,

    COUNT(CASE
            WHEN action = 'email_open'
            THEN 1
          END) AS opens,

    COUNT(CASE
            WHEN action = 'email_clickthrough'
            THEN 1
          END) AS clicks

FROM email_events
GROUP BY
    EXTRACT(YEAR FROM occured_at),
    EXTRACT(WEEK FROM occured_at)
ORDER BY
    year,
    week_num;

SELECT
action,
COUNT(*) total_events,
ROUND(
COUNT(*)*100.0/
SUM(COUNT(*)) OVER(),
2
) percentage
FROM email_events
GROUP BY action;
