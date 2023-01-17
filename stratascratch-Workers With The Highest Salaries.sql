--Question link : https://platform.stratascratch.com/coding/10353-workers-with-the-highest-salaries?code_type=1

 --Ans
 
 
select 
worker_title
from worker w
join title t
on w.worker_id= t.worker_ref_id
where salary= (select max(salary) from worker );
