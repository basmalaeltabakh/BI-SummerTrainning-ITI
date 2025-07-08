---Lab 6
--1
USE ITI
GO

CREATE PROCEDURE GetStudentsPerDepartment
AS
BEGIN
    SELECT d.Dept_Name, COUNT(s.St_ID) AS StudentCount
    FROM Department d
    inner JOIN Student s ON d.Dept_ID = s.Dept_Id
    GROUP BY d.Dept_Name
END
--test
EXEC GetStudentsPerDepartment

--2
USE Company_SD
GO

CREATE PROCEDURE CheckEmployeesInP1
AS
BEGIN
    DECLARE @EmpCount INT;

    SELECT @EmpCount = COUNT(*)
    FROM Works_for
    WHERE Pno = 'p1';

    IF @EmpCount >= 3
        PRINT 'The number of employees in the project p1 is 3 or more';
    ELSE
    BEGIN
        PRINT 'The following employees work for the project p1:';

        SELECT E.Fname, E.Lname
        FROM Employee E
        JOIN Works_for W ON E.SSN = W.Essn
        WHERE W.Pno = 'p1';
    END
END

GO
-- Test 
EXEC sp_CheckP1Employees;


--3
SELECT * FROM Works_for WHERE Pno = 'P1'

USE Company_SD
GO

CREATE PROCEDURE ReplaceEmployeeInProjectt
    @OldEmpNo CHAR(9),
    @NewEmpNo CHAR(9),
    @ProjectNo VARCHAR(10)
AS
BEGIN
    UPDATE Works_For
    SET ESSN = @NewEmpNo
    WHERE ESSN = @OldEmpNo AND Pno = @ProjectNo
END
--test
EXEC ReplaceEmployeeInProject '123456789', '987654321', 'P1'


--4

USE Company_SD 
GO

-- 1. Add Budget column to Project table
ALTER TABLE Project ADD Budget INT;
GO

UPDATE Project SET Budget = 95000 WHERE Pnumber = 'p2';
UPDATE Project SET Budget = 100000 WHERE Pnumber = 'p1';
UPDATE Project SET Budget = 150000 WHERE Pnumber = 'p3';
GO

-- 3. Create the Audit table with exact structure specified
CREATE TABLE Project_Audit (
    ProjectNo CHAR(2),        -- Changed to CHAR(2) to match Pnumber in Project table
    UserName SYSNAME,         -- System username who made the change
    ModifiedDate DATETIME,    -- When the change occurred
    Budget_Old INT,           -- Previous budget value
    Budget_New INT            -- New budget value
);
GO

-- 4. Create the trigger to audit budget changes

CREATE TRIGGER trg_AuditBudgetChanges
ON Project
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Budget)
    BEGIN
        
        INSERT INTO Project_Audit (ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
        SELECT 
            d.Pnumber,              -- Project number
            SUSER_SNAME(),          -- Current user
            GETDATE(),              -- Current date/time
            d.Budget,               -- Old budget value (from deleted table)
            i.Budget                -- New budget value (from inserted table)
        FROM deleted d
        INNER JOIN inserted i ON d.Pnumber = i.Pnumber
        WHERE d.Budget <> i.Budget OR (d.Budget IS NULL AND i.Budget IS NOT NULL) OR (d.Budget IS NOT NULL AND i.Budget IS NULL);
    END
END
GO

-- Verify the audit record was created
SELECT * FROM Project_Audit;
SELECT * FROM sys.triggers WHERE name = 'trg_AuditBudgetChanges';

--5
USE ITI
GO

CREATE TRIGGER PreventDepartmentInsert
ON Departments
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'You can’t insert a new record in the Department table'
END
--test 
INSERT INTO Departments (Dnum, DName) VALUES (999, 'Test')

--6
USE Company_SD
GO

-- Drop any existing INSTEAD OF INSERT trigger on Employee table
DECLARE @existingTrigger NVARCHAR(100);

SELECT @existingTrigger = name
FROM sys.triggers
WHERE parent_id = OBJECT_ID('Employee') AND type_desc = 'INSTEAD_OF_TRIGGER';

IF @existingTrigger IS NOT NULL
BEGIN
    EXEC('DROP TRIGGER ' + @existingTrigger);
END
GO

-- Create the new trigger
CREATE TRIGGER trg_PreventInsertInMarch
ON Employee
INSTEAD OF INSERT
AS
BEGIN
    IF MONTH(GETDATE()) = 3
    BEGIN
        PRINT 'Insertion not allowed in March';
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO Employee (SSN, Fname, Lname, Bdate, Address, Sex, Salary, Superssn, Dno)
        SELECT SSN, Fname, Lname, Bdate, Address, Sex, Salary, Superssn, Dno
        FROM inserted;
    END
END
GO

--Ensure a valid Department exists (with Dnum = 1)
IF NOT EXISTS (SELECT * FROM Departments WHERE Dnum = 1)
BEGIN
    INSERT INTO Departments (Dnum, DName)
    VALUES (1, 'Test Department');
END
GO

--  Test
INSERT INTO Employee (SSN, Fname, Lname, Bdate, Address, Sex, Salary, Superssn, Dno)
VALUES ('888888889', 'Test', 'User', '2000-01-01', 'Test Address', 'F', 3000, NULL, 1);
GO

--  Confirm trigger exists
SELECT name 
FROM sys.triggers 
WHERE parent_id = OBJECT_ID('Employee');

--7
USE ITI
GO
--create table
CREATE TABLE Student_Audit (
    Server_UserName SYSNAME,
    ActionDate DATETIME,
    Note NVARCHAR(200)
)
--create trigger
CREATE TRIGGER LogStudentInsert
ON Student
AFTER INSERT
AS
BEGIN
    INSERT INTO Student_Audit (Server_UserName, ActionDate, Note)
    SELECT 
        SUSER_SNAME(),
        GETDATE(),
        'Inserted New Row with Key = ' + CAST(i.St_ID AS NVARCHAR(10)) + ' in table Student'
    FROM inserted i
END
--test
INSERT INTO Student_Audit (Server_UserName, ActionDate, Note) VALUES ('Basmala', 20, 10)

SELECT * FROM Student_Audit

--8
CREATE TRIGGER LogStudentDelete
ON Student
INSTEAD OF DELETE
AS
BEGIN
    INSERT INTO Student_Audit (Server_UserName, ActionDate, Note)
    SELECT 
        SUSER_SNAME(),
        GETDATE(),
        'Try to delete Row with Key = ' + CAST(d.St_ID AS NVARCHAR(10))
    FROM deleted d
END
--test
DELETE FROM Student WHERE St_ID = 5

SELECT * FROM Student_Audit
