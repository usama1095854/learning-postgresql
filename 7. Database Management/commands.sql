-- In cmd
psql -U postgres Employees
password - root

CREATE DATABASE myblockeddb;

-- If we also run template1 and Employees CREATE DATABASE myblockeddb2 will not work
psql -U postgres template1
CREATE DATABASE myblockeddb2;

-- Now it will work
CREATE DATABASE myblockeddb2 WITH TEMPLATE template0;

psql -U postgres postgres

CREATE DATABASE ztm;
DROP DATABASE ztm;

CREATE DATABASE ztm;

-- show schemas
\dn

-- Create Schema
CREATE SCHEMA sales;
-- Delete Schema
DROP SCHEMA sales;

-- Show List of roles 
-- Attributes
\du

-- Create a role
CREATE role test_role_with_login WITH LOGIN ENCRYPTED PASSWORD 'password';

-- Create User
CREATE USER test_user_with_login WITH ENCRYPTED PASSWORD 'password';

show hba_file;

-- search for (pg_hba.conf) file
C:\Program Files\PostgreSQL\15\data

show config_file;
-- search for (postgresql.conf)
C:/Program Files/PostgreSQL/15/data

psql -U privilegetest Employees

CREATE role privilegetest WITH LOGIN ENCRYPTED PASSWORD 'password';
-- user (privilegetest) does not have permission to do anything in database 
--ERROR:  permission denied for table titles
-- Super user have to grant access

-- postgres is a super user
psql -U postgres Employees
GRANT SELECT ON titles TO privilegetest;

-- superuser can Revoke privilege
REVOKE SELECT ON titles FROM privilegetest;

-- Now (privilegetest) role can not SELECT FROM tables
-- ERROR:  permission denied for table titles
SELECT * FROM titles;

-- super can GRANT ALL PRIVILIGES ON ALL TABLES to (privilegetest)
-- Now privilegetest role can do every thing in database EMPLOYEES
GRANT ALL ON ALL TABLES IN SCHEMA public TO privilegetest;

SELECT * FROM departments;

-- superuser can REVOKE ALL PRIVILEGES FROM (privilegetest)
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM privilegetest;

-- Create new role
CREATE ROLE employee_read;

-- GRANT only select
GRANT SELECT ON ALL TABLES IN SCHEMA public TO employee_read;

-- now we can't select
SELECT * FROM departments;

-- employee_read granted to privilegetest
GRANT employee_read TO privilegetest;

-- now we can select
SELECT * FROM departments;

-- employee_read revoked from privilegetest
REVOKE employee_read FROM privilegetest;

--=============================================================================================

-- DATA TYPES

-- ------------------------------
-- working with text
CREATE TABLE test_text (
    fixed char(4),
    variable VARCHAR(20),
    unlimited text
);

INSERT INTO test_text VALUES ('mo', 'mo', 'I have unlimited space!');
-- we canot insert (momomo)
INSERT INTO test_text VALUES ('momomo', 'mo', 'I have unlimited space!');

SELECT * from test_text;

-- -----------------------------
--  Working with numbers
CREATE TABLE test_number (
    four float4,
    eight float8,
    big decimal
);

insert into test_number VALUES (
    1.1234567676, 	
    1.123456789123456,
    1.123456789123451234567891234512345678912345123456789123451234567891234512345678912345123456789123451234567891234512345678912345123456789123451234567891234512345678912345
);

SELECT * from test_number;
-- ----------------------------
-- Working with Array
CREATE TABLE test_array (
    four char(2)[],
    eight text[],
    big float4[]
);

INSERT INTO test_array VALUES ( 
    ARRAY['mo', 'm', 'm', 'd'],
    ARRAY['test', 'long text', 'longer text'],
    ARRAY[1.23, 2.11, 3.23, 5.3245345234525]
);

SELECT * FROM test_array;


-- ============================================================================================

-- Create Tables in Command Line

psql -U postgres ztm

\conninfo
-- You are connected to database "ztm" as user "postgres" on host "localhost" (address "::1") at port "5432".

create table student (
    student_id UUID primary key DEFAULT uuid_generate_v4(),
    first_name varchar(255) not null,
    last_name VARCHAR(255) not null,
    email varchar(255) not null,
    date_of_birth Date not null
); 
-- ERROR:  function uuid_generate_v4() does not exist

-- We have to create extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Now we can create table with (uuid_generate_v4())

-- Check tables in database
\dt

-- Check table fields
\d student

-- ============================================================================================
-- Create Tables

-- Create Domain Rating
CREATE DOMAIN Rating SMALLINT 
    CHECK (VALUE > 0 AND VALUE <= 5);

-- Create Type Feedback
CREATE TYPE Feedback as (
    student_id UUID,
    rating Rating,
    feedback text
);

-- Create Table student
CREATE TABLE student (
    student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) not NULL,
    last_name varchar(255) not null,
    date_of_birth Date not null
);

-- Add coloumn in student table
ALTER TABLE student
add COLUMN email text;


CREATE TABLE subject (
    subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject TEXT not NULL,
    description text
);

CREATE TABLE teacher (
    teacher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) not NULL,
    last_name VARCHAR(255) not NULL,
    email TEXT,
    date_of_birth Date
);

CREATE TABLE course (
    course_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "name" text not NULL,
    description text,
    subject_id UUID REFERENCES subject(subject_id),
    teacher_id UUID REFERENCES teacher(teacher_id),
    feedback feedback[]
);

CREATE TABLE enrollment (
    course_id UUID REFERENCES course(course_id),
    student_id UUID REFERENCES student(student_id),
    enrollment_date Date not NULL,
    CONSTRAINT pk_enrollment PRIMARY key (course_id, student_id)
);

-- ============================================================================================

-- Adding students and teachers in tables
INSERT INTO student (
    first_name,
    last_name,
    email,
    date_of_birth
) VALUES (
    'Mo',
    'Binni',
    'mo@binni.io',
    '1992-11-13'::DATE
);

INSERT INTO teacher (
    first_name,
    last_name,
    email,
    date_of_birth
) VALUES (
    'Mo',
    'Binni',
    'mo@binni.io',
    '1992-11-13'::DATE
);

INSERT INTO subject (
    subject,
    description
) VALUES (
    'SQL Zero To Mastery',
    'The art of SQL mastery'
);

DELETE from subject where subject = 'SQL Zero To Mastery';

INSERT INTO subject (
    subject,
    description
) VALUES (
    'SQL',
    'A database managment language'
);

INSERT INTO course (
    "name",
    description
) VALUES (
    'SQL Zero To Mastery',
    'The #1 resourse for SQL mastery'
);

update course
set subject_id = '3b6b0c3c-0443-4888-ac5a-c04d6c954db7'
where subject_id is null;

alter TABLE course ALTER COLUMN subject_id set not null;

-- we also have to add subject id because it is not set to (not null)
INSERT INTO course (
    "name",
    description
) VALUES (
    'Name',
    'Description'
);

update course
set teacher_id = '5960357a-af73-4737-8545-daa43da2d69f'
where teacher_id is null;

alter TABLE course ALTER COLUMN teacher_id set not null;

INSERT INTO enrollment (
    student_id,
    course_id,
    enrollment_date
) VALUES (
    '632cf7a9-bd44-4ea5-88f3-34f4ae9059bd',
    '37496e31-a86c-4447-becf-b9a99829d9c3',
    NOW()::DATE
);

UPDATE course
set feedback = array_append( 
    feedback,
    ROW(
        '632cf7a9-bd44-4ea5-88f3-34f4ae9059bd',
        5,
        'Great course!'
    )::feedback
)
WHERE course_id = '37496e31-a86c-4447-becf-b9a99829d9c3';

create TABLE feedback (
    student_id UUID not null REFERENCES student(student_id),
    course_id UUID not null REFERENCES course(course_id),
    feedback TEXT,
    rating rating,
    CONSTRAINT pk_feedback PRIMARY key (student_id, course_id)
)

INSERT INTO feedback (
    student_id,
    course_id,
    feedback,
    rating
) VALUES (
    '632cf7a9-bd44-4ea5-88f3-34f4ae9059bd',
    '37496e31-a86c-4447-becf-b9a99829d9c3',
    'well this was great!',
    4
); 