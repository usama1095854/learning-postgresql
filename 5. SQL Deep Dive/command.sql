-- Fetch all employees
SELECT * from employees;

-- Count the departments
SELECT count(dept_no) from departments;

-- count the salaries raises
SELECT count(emp_no) from salaries
where emp_no = 10001;

-- What title does 10001 have?
SELECT * from titles
where emp_no = 10001;

-- rename the column
SELECT emp_no as "Employee #", birth_date as "Birthday" from employees;

-- ===========================================================================================
-- Scaler function
-- 1 Count
-- concat the column
SELECT emp_no as "Employee #", concat(first_name, ' ', last_name) as "Name" from employees;

-- ============================================================================================
-- Aggregate Function 
-- 1 AVG()
-- 2 COUNT()
-- 3 MIN()
-- 4 MAX()
-- 5 SUM()

-- How many employees in the company
SELECT count(emp_no) from employees;

-- Get the highest salary available
SELECT max(salary) from salaries;

-- Get the total amount of salaries paid
SELECT sum(salary) from salaries

-- ============================================================================================
-- commenting the quries

-- for single line

/* for 
   multipl
   line */

-- Select the employe with the name Mayumi Schueller
SELECT * from employees
/*
filter on first name AND last name to limit amount of data returned
and focus the filtering on a single person
*/
where first_name = 'Mayumi' and last_name = 'Schueller';

-- =============================================================================================
-- Filtering Data

-- Get a list of all Female emloyees
SELECT * from employees
where gender = 'F';

-- AND
SELECT * from employees
where first_name = 'Georgi' or first_name = 'Bezalel';

SELECT first_name, last_name, hire_date from employees
where first_name = 'Georgi' and last_name = 'Facello' and hire_date = '1986-06-26'

-- OR
SELECT first_name, last_name, hire_date from employees
where first_name = 'Georgi' and last_name = 'Facello' and hire_date = '1986-06-26' 
or first_name = 'Bezalel';

SELECT first_name, last_name, hire_date from employees
where (first_name = 'Georgi' and last_name = 'Facello' and hire_date = '1986-06-26')
or (first_name = 'Bezalel' and last_name = 'Simmel');

-- (store) database
-- How many female customers do we have from the state of Origon (OR) AND new york (NK)
SELECT firstname, lastname, city, state, age, income, gender from customers
where (state = 'OR' or state = 'NY') 
and gender = 'F';

SELECT count(firstname) from customers
where (state = 'OR' or state = 'NY') and gender = 'F';

-- NOT
-- How to get female gender data (not using gender - 'F')   
SELECT firstname, gender from customers
where not gender = 'M';

-- How many customer aren't 55?
SELECT count(firstname) from customers
where not age = 55;

-- =============================================================================================
-- Comparison Operators

-- Who over the age of 44 has an income of 100000
SELECT firstname, lastname, city, state, age, income, gender from customers
where  age > 44 and income = 100000;

-- =============================================================================================

-- Order of Operations

-- 1 FROM
-- 2 WHERE
-- 3 SELECT

-- Operator Precedence

-- 1 Parentheses
-- 2 Multiplication/Division
-- 3 Subtraction/Addition
-- 4 NOT
-- 5 AND
-- 6 OR

-- =============================================================================================
-- NULL
-- Checking for empty values
-- When a record does not have a value it is consodered empty

SELECT * from customers
where state is null;

-- select all values except null values
SELECT * from customers
where state is not null;

-- When selecting null values of state replace with some values
SELECT COALESCE(state, 'No address avail able') as "State" from customers;

-- =============================================================================================
-- Three-Valued Logic
-- _________________
-- (true(null)false)
-- `````````````````

SELECT * from customers
where (state is null) or (state is not null);

-- =============================================================================================
-- BETWEEN AND

-- >= <=
-- find age between 20 and 30
SELECT firstname, state, age, income, gender  from customers
where age BETWEEN 20 and 30;

-- IN
SELECT * from employees
-- where emp_no = 10001 or emp_no = 10002 or emp_no = 10003
where emp_no in(10001, 10002, 10003);


-- =============================================================================================
-- =============================================================================================
-- =============================================================================================
-- =============================================================================================









