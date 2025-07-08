CREATE DATABASE [Employee DataBase];
GO

-- Use the database
USE [Employee DataBase];
GO

-- Create Department table
CREATE TABLE Department (
    DNAME VARCHAR(50),
    DNUMBER INT PRIMARY KEY,
    MGRSSN INT,
    MGRSTARTDATE DATE
);

-- Create Employee table
CREATE TABLE Employee (
    FNAME VARCHAR(30),
    LNAME VARCHAR(30),
    SSN INT PRIMARY KEY,
    BDATE DATE,
    ADDRESS VARCHAR(100),
    SEX CHAR(1),
    SALARY DECIMAL(10,2),
    SUPERSSN INT NULL,
    DNO INT,
    FOREIGN KEY (DNO) REFERENCES Department(DNUMBER)
);

-- Create DEPT_LOCATIONS table
CREATE TABLE DEPT_LOCATIONS (
    DNUMBER INT,
    DLOCATION VARCHAR(50),
    FOREIGN KEY (DNUMBER) REFERENCES Department(DNUMBER)
);

-- Create Project table
CREATE TABLE Project (
    PNAME VARCHAR(50),
    PNUMBER INT PRIMARY KEY,
    PLOCATION VARCHAR(50),
    DNUM INT,
    FOREIGN KEY (DNUM) REFERENCES Department(DNUMBER)
);

-- Create WORKS_ON table
CREATE TABLE WORKS_ON (
    ESSN INT,
    PNO INT,
    HOURS DECIMAL(4,1),
    FOREIGN KEY (ESSN) REFERENCES Employee(SSN),
    FOREIGN KEY (PNO) REFERENCES Project(PNUMBER)
);

-- Create Dependent table
CREATE TABLE Dependent (
    ESSN INT,
    DEPENDENT_NAME VARCHAR(50),
    SEX CHAR(1),
    BDATE DATE,
    RELATIONSHIP VARCHAR(30),
    FOREIGN KEY (ESSN) REFERENCES Employee(SSN)
);

----------------------------------------------------------

-- Insert Departments
INSERT INTO Department VALUES ('IT', 10, 123456, '2020-01-01');
INSERT INTO Department VALUES ('HR', 20, 789012, '2019-06-15');

-- Insert Employees
INSERT INTO Employee VALUES ('Ali', 'Omar', 123456, '1990-02-15', 'Cairo', 'M', 5000, NULL, 10);
INSERT INTO Employee VALUES ('Sara', 'Ahmed', 789012, '1995-07-22', 'Alex', 'F', 4500, 123456, 20);

-- Insert Dept_Locations
INSERT INTO DEPT_LOCATIONS VALUES (10, 'Cairo');
INSERT INTO DEPT_LOCATIONS VALUES (20, 'Alex');

-- Insert Projects
INSERT INTO Project VALUES ('ERP System', 1001, 'Cairo', 10);
INSERT INTO Project VALUES ('Hiring Portal', 1002, 'Alex', 20);

-- Insert WORKS_ON
INSERT INTO WORKS_ON VALUES (123456, 1001, 20);
INSERT INTO WORKS_ON VALUES (789012, 1002, 15);

-- Insert Dependents
INSERT INTO Dependent VALUES (123456, 'Lina', 'F', '2012-04-10', 'Daughter');
INSERT INTO Dependent VALUES (789012, 'Youssef', 'M', '2010-09-01', 'Son');
