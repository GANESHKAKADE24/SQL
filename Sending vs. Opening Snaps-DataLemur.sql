#Question Link
https://datalemur.com/questions/time-spent-snaps

# Question 
/*Assume you are given the tables below containing information on Snapchat users, their ages, and their time spent sending and opening snaps. Write a query to obtain a breakdown of the time spent sending vs. opening snaps (as a percentage of total time spent on these activities) for each age group.

Output the age bucket and percentage of sending and opening snaps. Round the percentage to 2 decimal places.

Notes:

You should calculate these percentages:
time sending / (time sending + time opening)
time opening / (time sending + time opening)
To avoid integer division in percentages, multiply by 100.0 and not 100.
activities Table:
Column Name	Type
activity_id	integer
user_id	integer
activity_type	string ('send', 'open', 'chat')
time_spent	float
activity_date	datetime
activities Example Input:
activity_id	user_id	activity_type	time_spent	activity_date
7274	123	open	4.50	06/22/2022 12:00:00
2425	123	send	3.50	06/22/2022 12:00:00
1413	456	send	5.67	06/23/2022 12:00:00
1414	789	chat	11.00	06/25/2022 12:00:00
2536	456	open	3.00	06/25/2022 12:00:00
age_breakdown Table:
Column Name	Type
user_id	integer
age_bucket	string ('21-25', '26-30', '31-25')
age_breakdown Example Input:
user_id	age_bucket
123	31-35
456	26-30
789	21-25
Example Output:
age_bucket	send_perc	open_perc
26-30	65.40	34.60
31-35	43.75	56.25
Explanation
For the age bucket 26-30, the time spent sending snaps was 5.67 and opening 3. The percent of time sending snaps was 5.67/(5.67+3)=65.4%, and the percent of time
opening snaps was 3/(5.67+3)=34.6%.*/


# Solution
WITH total_time AS
(
SELECT age_bucket, SUM(time_spent) AS total
FROM activities a
JOIN age_breakdown ab
ON a.user_id = ab.user_id
WHERE activity_type IN ('open', 'send')
GROUP BY age_bucket
),

send_time AS
(
SELECT age_bucket, SUM(time_spent) AS send
FROM activities a
JOIN age_breakdown ab
ON a.user_id = ab.user_id
WHERE activity_type = 'send'
GROUP BY age_bucket
),

open_time AS
(
SELECT age_bucket, SUM(time_spent) AS open
FROM activities a
JOIN age_breakdown ab
ON a.user_id = ab.user_id
WHERE activity_type = 'open'
GROUP BY age_bucket
)

SELECT t.age_bucket,
ROUND((s.send/t.total)*100.0, 2) AS send_perc,
ROUND((o.open/t.total)*100.0, 2) AS open_perc
FROM total_time t
JOIN send_time s
ON t.age_bucket = s.age_bucket
JOIN open_time o
ON o.age_bucket = s.age_bucket;

