-- EARLY CHECK AND TRANSFORMATION

-- -- check duplicate value
-- select employee_id, count(employee_id) from mekari.employees e 
-- group by employee_id 
-- having COUNT(employee_id) > 1;
-- 
-- -- employee_id have duplicate values
-- select * from mekari.employees e 
-- where employee_id = '218078';
-- 
-- -- drop one that have lower salary
-- delete from mekari.employees 
-- where employee_id = '218078' and salary = 10500000;
-- 
-- -- check duplicate value timesheet
-- select timesheet_id , count(timesheet_id) from timesheets t  
-- group by timesheet_id  
-- having COUNT(timesheet_id) > 1;

-- STEP TRANSFORMATION ABOVE EASIER TO TRANSFORM IN ETL TOOLS SUCH AS PENTAHO / SSIS



											-- ETL STEP AFTER DUPLICATE ISSUE SOLVE -- 

-- drop table if exists salary_per_hours;
create table salary_per_hours 

with cte_1 as (select 
*, 
			-- transformation to time_diff
case when time_diff is null then '07:00:00'         -- set to 7 hours a null time_diff
	when time_diff < '00:00:00' then '07:00:00'		-- set to 7 hours that have negative time_diff
	else time_diff 
end as time_diff_clean

from (
		-- get time_diff
select * ,
TIMEDIFF(checkout,checkin) as time_diff
from timesheets t 
where 
 (checkin is not null 								-- to solve problem that one timesheet have no checkin or checkout
or checkout is not null)
) a ),

-- join with employees
join_employees as (
select 
year (date_ts) as year,
month(date_ts) as month,
branch_id,
e.employee_id,
max(e.salary) as salary, 			
SEC_TO_TIME(sum(TIME_TO_SEC(time_diff_clean))) as total_hours			-- to get hours in time diff

from cte_1 a inner join employees e on a.employee_id = e.employee_id
group by 
year(date_ts),
month(date_ts), 
branch_id,
employee_id
order by year,month, branch_id, e.employee_id )


-- GET SUMMARY salary_per_hour
select year,month, branch_id, 
(sum(salary)/sum(hour(total_hours))) as salary_per_hour
from join_employees
group by year,month,branch_id
;
