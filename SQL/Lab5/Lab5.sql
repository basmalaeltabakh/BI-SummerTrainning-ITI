--- Using ITI DB
-----------------------------------------------
--1
SELECT COUNT(*) AS StudentsWithAge
FROM Student
WHERE St_Age IS NOT NULL;

--2
SELECT DISTINCT Ins_Name
FROM Instructor;

--3

SELECT 
  St_Id AS [Student ID],
  ISNULL(St_Fname, '            ') + ' ' + ISNULL(St_Lname, '             ') AS [Student Full Name],
  ISNULL(Dept_Name, 'No Department') AS [Department Name]
FROM Student s
inner JOIN Department d ON s.Dept_Id = d.Dept_Id;


--4
SELECT 
    I.Ins_Name AS "Instructor Name",
    D.Dept_Name AS "Department Name"
FROM 
    Instructor I
    LEFT JOIN Department D ON I.Dept_Id = D.Dept_Id;


--5
SELECT 
    S.St_Fname + ' ' + S.St_Lname AS "Student Full Name",
    C.Crs_Name AS "Course Name"
FROM 
    Student S 
    JOIN Stud_Course SC ON S.St_Id = SC.St_Id
    JOIN Course C ON SC.Crs_Id = C.Crs_Id
WHERE 
    SC.Grade IS NOT NULL;


--6
SELECT 
    T.Top_Name AS "Topic Name",
    COUNT(C.Crs_Id) AS "Number of Courses"
FROM 
    Topic T inner JOIN Course C ON T.Top_Id = C.Top_Id
GROUP BY 
    T.Top_Name;


--7
SELECT 
    MAX(Salary) AS "Max Salary",
    MIN(Salary) AS "Min Salary"
FROM 
    Instructor;

SELECT * FROM Instructor WHERE Salary IS NOT NULL;

--8
SELECT 
    Ins_Name, 
    ISNULL(Salary, 0) AS Salary
FROM 
    Instructor
WHERE 
    ISNULL(Salary, 0) < (SELECT AVG(ISNULL(Salary, 0)) FROM Instructor);

--9
SELECT TOP 1 Dept_Name
FROM Instructor i
JOIN Department d ON i.Dept_Id = d.Dept_Id
ORDER BY Salary ASC;

--10

SELECT TOP 2
    Ins_Name, 
    Salary
FROM 
    Instructor
ORDER BY 
    Salary DESC;

--11
SELECT 
  Ins_Name,
  COALESCE(CAST(Salary AS VARCHAR), 'Bonus') AS SalaryOrBonus
FROM Instructor;


--12
SELECT 
    AVG(ISNULL(Salary, 0)) AS "Average Salary"
FROM 
    Instructor;

--13
SELECT 
    S1.St_Fname AS "Student Name",
    S2.St_Fname + ' ' + S2.St_Lname AS "Supervisor Name"
FROM 
    Student S1 inner JOIN Student S2 ON S1.St_super = S2.St_Id;

--14
CREATE VIEW V_PassedCourses AS
SELECT 
  s.St_Fname + ' ' + s.St_Lname AS [Student Name],
  c.Crs_Name AS [Course Name]
FROM Student s
JOIN Stud_Course sc ON s.St_Id = sc.St_Id
JOIN Course c ON sc.Crs_Id = c.Crs_Id
WHERE sc.Grade > 50;


--15
CREATE VIEW ManagerTopics AS
SELECT DISTINCT
    S.St_Fname + ' ' + S.St_Lname AS "Manager Name",
    T.Top_Name AS "Topic Name"
FROM 
    Department D
    JOIN Student S ON D.Dept_Manager = S.St_Id  
    JOIN Stud_Course SC ON S.St_Id = SC.St_Id    
    JOIN Course C ON SC.Crs_Id = C.Crs_Id        
    JOIN Topic T ON C.Top_Id = T.Top_Id;        


--16
CREATE VIEW SDJavaInstructors AS
SELECT 
    I.Ins_Name AS "Instructor Name",
    D.Dept_Name AS "Department Name"
FROM 
    Instructor I JOIN Department D ON I.Dept_Id = D.Dept_Id
WHERE 
    D.Dept_Name IN ('SD', 'Java');


---- -----------------------------------------------------------------------------------
--- Using  AdventureWorks DB
--------------------------------
--1
SELECT 
    SalesOrderID, 
    ShipDate
FROM 
    Sales.SalesOrderHeader
WHERE 
    OrderDate BETWEEN '2002-07-28' AND '2014-07-29';


--2
SELECT 
    ProductID, 
    Name
FROM 
    Production.Product
WHERE 
    StandardCost < 110.00;

--3
SELECT 
    ProductID, 
    Name
FROM 
    Production.Product
WHERE 
    Weight IS NULL;

--4
SELECT 
    ProductID, 
    Name, 
    Color
FROM 
    Production.Product
WHERE 
    Color IN ('Silver', 'Black', 'Red');

--5
SELECT 
    ProductID, 
    Name
FROM 
    Production.Product
WHERE 
    Name LIKE 'B%';


--6
-- the update
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3;

SELECT 
    ProductDescriptionID,
    Description
FROM 
    Production.ProductDescription
WHERE 
    Description LIKE '%\_%' ESCAPE '\';

--7
SELECT 
    OrderDate,
    SUM(TotalDue) AS TotalSales
FROM 
    Sales.SalesOrderHeader
WHERE 
    OrderDate BETWEEN '2001-07-01' AND '2014-07-31'
GROUP BY 
    OrderDate
ORDER BY 
    OrderDate;


--8
SELECT DISTINCT
    HireDate
FROM 
    HumanResources.Employee;
----
SELECT DISTINCT
    E.HireDate,
    P.FirstName + ' ' + P.LastName AS EmployeeName
FROM 
    HumanResources.Employee E
    JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
ORDER BY
    E.HireDate;

--9
SELECT 
    AVG(DISTINCT ListPrice) AS AvgUniqueListPrice
FROM 
    Production.Product
WHERE 
    ListPrice > 0;

--10
SELECT 
    'The ' + Name + ' is only! ' + CAST(ListPrice AS VARCHAR) AS ProductInfo
FROM 
    Production.Product
WHERE 
    ListPrice BETWEEN 100 AND 120
ORDER BY 
    ListPrice;