# Salary-per-Hour
This is a project to find out salary per hour based on the number of employees that work for that branch each month.

In this repo, there are some files:
Source data:
- ### employees.csv
- ### timesheets.csv

Transformation and Load data:
- ### PythonTask_M.Zahid.ipynb
- ### sql_task_M.Zahid.sql

Evidence after load data:
- ### Tables Created.png
- ### sample_results.png
- ### result_salary_per_hour.csv
 
    
In Transformation and Load data step, there are steps that I do:
- Extract data from csv files
- Check extracted data if there are duplicate rows
- Drop one of duplicate rows to make unique rows
- Get diff time from checkin and checkout time
- If there are null data from different time column, or diff time have negative values, change the diff time to '07:00:00'
- Aggregation table to get unique salary per employee id and total working hours
- Aggregating to get detail salary per hour
- Load to table salary_per_hours or load to csv







