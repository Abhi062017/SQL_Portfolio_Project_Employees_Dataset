-- 29th Oct : 3:33am
/*
Dive Into SQL Data Analysis: Full Portfolio Project
All of the queries available at : https://github.com/shubhamringole/employees/blob/main/SQL%20Data%20Analyst%20Project%201.sql
*/
-- Note : A quick way to load a heavy database/dataset on MySQl WB is using the command (in cmd.exe) : "mysql -u [username] -p < employees.sql". This employees dataset was also downloaded using that same command.

use employees;
show tables;
show grants for root@localhost;

-- 1. List of Employees by Department
-- Question: Write a query to list all employees along with their respective department names. Include employee number, first name, last name, department number, and department name.
desc employees;  -- emp_no, first name, last name
desc current_dept_emp;  -- emp_no and dept_no
desc departments;  -- dept_no and dept_name

select * from
employees  -- emp_no, first name, last name
limit 10;

select * from
current_dept_emp  -- emp_no and dept_no
limit 10;

select * from
departments  -- dept_no and dept_name
limit 10;

select e.emp_no, e.first_name, e.last_name, c.dept_no, d.dept_name
from employees e
join current_dept_emp c on e.emp_no=c.emp_no
join departments d on c.dept_no=d.dept_no
limit 10;

-- 2. Current and Past Salaries of an Employee
-- Question: Write a query to retrieve all the salary records of a given employee (by employee number). Include employee number, salary, from_date, and to_date.

SELECT *
FROM salaries
where emp_no=10001;  -- given employee (could be any, not just emp_no 10001

-- 3. Employees with Specific Titles
-- Question: Write a query to find all employees who have held a specific title (e.g., 'Engineer'). Include employee number, first name, last name, and title.

desc titles;
select * from titles limit 10;

select e.emp_no, e.first_name, e.last_name, t.title
from employees e
join titles t on e.emp_no=t.emp_no
where t.title like '%Engineer%';  -- using wildcard because the question asks "employees who have held a specific title" and not "employees who are a specific title"

-- 4. Departments with Their Managers
-- Question: Write a query to list all departments along with their current managers. Include department number, department name, Manager's employee number, first name, and last name.

select * from departments  -- dept_no, dept_name
limit 10;

select *
from titles
where title='Manager';  -- emp_no, title:Manager. That is, this table will give us the Manager's emp_no. Note, there are 24 managers in this dataset.

select *
from dept_manager;  -- emp_no, dept_no

select *
from employees
limit 10;  -- emp_no, first_name, last_name

select d.dept_no,d.dept_name,t.emp_no,e.first_name,e.last_name
from titles t
join dept_manager dm on t.emp_no=dm.emp_no
join departments d on dm.dept_no=d.dept_no
join employees e on dm.emp_no=e.emp_no
group by d.dept_no,d.dept_name,t.emp_no,e.first_name,e.last_name;

-- 5. Employee Count by Department
select *
from dept_emp  -- emp_no, dept_no
limit 10;

select * 
from departments;  -- dept_no and dept_name

select d.dept_name, count(de.emp_no) total_emp
from departments d
join dept_emp de on d.dept_no=de.dept_no
group by d.dept_name
order by count(de.emp_no) desc;

--  6. Employees' Birthdates in a Given Year
-- Question: Write a query to find all employees born in a specific year (e.g., 1953). Include employee number, first name, last name, and birth date.

select *
from employees  --  employee number, first name, last name, and birth date.
limit 10; 

select emp_no, first_name, last_name, birth_date
from employees
where year(birth_date) = '1953';

-- 7. Employees Hired in the Last 50 Years
-- Question: Write a query to find all employees hired in the last 50 years. Include employee number, first name, last name, and hire date.

select emp_no, first_name, last_name, hire_date
from employees
where hire_date between date_sub(curdate(), interval 50 year) and curdate();

select date_sub(curdate(), interval 50 year);  -- 1974-10-29
select curdate();  -- 2024-10-29

-- 8. Average Salary by Department
-- Question: Write a query to calculate the average salary for each department. Include department number, department name, and average salary.

select *
from salaries  -- emp_no and salary
limit 10;

select * 
from departments;  -- dept_no and dept_name

select *
from dept_emp  -- emp_no, dept_no
limit 10;

select d.dept_no, d.dept_name, round(avg(s.salary),2) avg_sal
from departments d
join dept_emp de on d.dept_no=de.dept_no
join salaries s on de.emp_no=s.emp_no
group by d.dept_name, d.dept_no
order by round(avg(s.salary),2) desc;

-- 9.Gender Distribution in Each Department
-- Question: Write a query to find the gender distribution (number of males and females) in each department. Include department number, department name, count of males, and count of females.

select *
from employees  --  emp_no, gender
limit 10; 

select *
from departments;  --  dept_no, dept_name

select *
from dept_emp  -- emp_no, dept_no
limit 10;

select d.dept_no, d.dept_name, e.gender,
SUM(case when e.gender='M' then 1 else 0 end) count_of_males,
SUM(case when e.gender='F' then 1 else 0 end) count_of_females
from departments d
join dept_emp de on d.dept_no=de.dept_no
join employees e on de.emp_no=e.emp_no
group by d.dept_no, d.dept_name, e.gender;

-- 10. Longest Serving Employees
-- Question: Write a query to find the employees who have served the longest in the company. Include employee number, first name, last name, and number of years served.

help datediff;  -- returns the difference in 2 dates in no. of days and not years/months

-- Method#1
select emp_no, first_name, last_name,
round(datediff('2024-10-29',hire_date)/365,2) years_served  -- dividing by 365 to calculate the difference in years
from employees
order by years_served desc;

-- Method#2
SELECT emp_no,first_name,last_name,
timestampdiff(YEAR,hire_date, curdate()) as years_served
FROM employees
ORDER By years_served desc;
