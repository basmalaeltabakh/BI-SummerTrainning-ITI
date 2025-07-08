use Company_SD
GO
-- 1. Department ID, name, and manager details
SELECT D.DNUM AS Dept_ID, D.DNAME AS Dept_Name, E.SSN AS Manager_SSN, E.FNAME + ' ' + E.LNAME AS Manager_Name
FROM DEPARTMENTs D
JOIN EMPLOYEE E ON D.MGRSSN = E.SSN;

-- 2. Department names and project names
SELECT D.DNAME AS Dept_Name, P.PNAME AS Project_Name
FROM DEPARTMENTs D
JOIN PROJECT P ON D.DNUM = P.DNUM;

-- 3. Full data about dependents with their employee's name
SELECT D.*, E.FNAME + ' ' + E.LNAME AS Employee_Name
FROM DEPENDENT D
JOIN EMPLOYEE E ON D.ESSN = E.SSN;

-- 4. Project ID, name, location in Cairo or Alex
SELECT PNUMBER, PNAME, PLOCATION
FROM PROJECT
WHERE PLOCATION LIKE '%Cairo%' OR PLOCATION LIKE '%Alex%';

-- 5. Projects with name starting with 'a'
SELECT *
FROM PROJECT
WHERE PNAME LIKE 'a%';

-- 6. Employees in department 30 with salary from 1000 to 2000
SELECT *
FROM EMPLOYEE
WHERE DNO = 30 AND SALARY BETWEEN 1000 AND 2000;

-- 7. Employees in department 10 working >=10 hours on 'AL Rabwah'
SELECT E.FNAME + ' ' + E.LNAME AS Employee_Name
FROM EMPLOYEE E
JOIN WORKS_FOr W ON E.SSN = W.ESSN
JOIN PROJECT P ON W.PNO = P.PNUMBER
WHERE E.DNO = 10 AND W.HOURS >= 10 AND P.PNAME = 'AL Rabwah';

-- 8. Employees supervised directly by 'Kamel Mohamed'
SELECT E2.FNAME + ' ' + E2.LNAME AS Employee_Name
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON E2.SUPERSSN = E1.SSN
WHERE E1.FNAME = 'Kamel' AND E1.LNAME = 'Mohamed';

-- 9. Employees and project names sorted by project name
SELECT E.FNAME + ' ' + E.LNAME AS Employee_Name, P.PNAME AS Project_Name
FROM EMPLOYEE E
JOIN WORKS_for W ON E.SSN = W.ESSN
JOIN PROJECT P ON W.PNO = P.PNUMBER
ORDER BY P.PNAME;

-- 10. Projects in Cairo, their department name, manager last name, address, and birthdate
SELECT P.PNUMBER, D.DNAME, M.LNAME AS Manager_LastName, M.ADDRESS, M.BDATE
FROM PROJECT P
JOIN DEPARTMENTs D ON P.DNUM = D.DNUM
JOIN EMPLOYEE M ON D.MGRSSN = M.SSN
WHERE P.PLOCATION LIKE '%Cairo%';

-- 11. All data of managers
SELECT *
FROM EMPLOYEE
WHERE SSN IN (SELECT MGRSSN FROM DEPARTMENTs);

-- 12. All employees and their dependents (even if no dependents)
SELECT 
  E.SSN,
  E.FNAME,
  E.LNAME,
  E.SALARY,
  E.DNO,
  D.DEPENDENT_NAME,
  D.SEX,
  D.BDATE
FROM Employee E
LEFT JOIN Dependent D ON E.SSN = D.ESSN;


-- 13. Insert your data as new employee in department 30
INSERT INTO EMPLOYEE (FNAME, LNAME, SSN, SALARY, SUPERSSN, DNO)
VALUES ('Basmala', 'Eltabakh', 102672, 3000, 112233, 30);

-- 14. Insert friend without salary or supervisor
INSERT INTO Employee (SSN, FNAME, LNAME, BDATE, ADDRESS, SEX, DNO)
VALUES (102660, 'Aml', 'AShraf', '2003-05-01', 'Sharkia', 'F', 30);

-- 15. Upgrade your salary by 20%
UPDATE EMPLOYEE
SET SALARY = SALARY * 1.2
WHERE SSN = 102672;
