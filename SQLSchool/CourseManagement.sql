Title: SchoolManagementSystem

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    DateOfBirth DATE,
    Address VARCHAR(255),
    Grade INT
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(255),
    InstructorID INT,
    Credits INT
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Department VARCHAR(255)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

=== END FILE ===

=== FILE: populate_tables.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, Grade) VALUES
(1, 'John', 'Doe', '2005-03-15', '123 Main St', 10),
(2, 'Jane', 'Smith', '2004-11-20', '456 Oak Ave', 11),
(3, 'Peter', 'Jones', '2006-05-10', '789 Pine Ln', 9),
(4, 'Mary', 'Brown', '2005-08-25', '1011 Maple Dr', 10);

INSERT INTO Courses (CourseID, CourseName, InstructorID, Credits) VALUES
(1, 'Mathematics', 1, 3),
(2, 'Science', 2, 4),
(3, 'History', 3, 3),
(4, 'English', 4, 3);


INSERT INTO Instructors (InstructorID, FirstName, LastName, Department) VALUES
(1, 'David', 'Lee', 'Mathematics'),
(2, 'Sarah', 'Kim', 'Science'),
(3, 'Michael', 'Garcia', 'History'),
(4, 'Jessica', 'Wilson', 'English');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 85),
(2, 1, 2, 92),
(3, 2, 1, 78),
(4, 2, 3, 88),
(5, 3, 2, 95),
(6, 3, 4, 75),
(7,4,1,90),
(8,4,3,80);

INSERT INTO Grades (GradeID, StudentID, CourseID, Grade) VALUES
(1,1,1,85),
(2,1,2,92),
(3,2,1,78),
(4,2,3,88),
(5,3,2,95),
(6,3,4,75),
(7,4,1,90),
(8,4,3,80);

=== END FILE ===

=== FILE: queries.sql ===
-- Students with grade above 90
SELECT * FROM Students WHERE Grade > 90;

-- Average grade for each course
SELECT CourseName, AVG(Grade) AS AverageGrade
FROM Courses c JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY CourseName;

-- Students enrolled in Mathematics
SELECT s.FirstName, s.LastName
FROM Students s JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Mathematics';

--Number of students in each grade
SELECT Grade, COUNT(*) AS NumberOfStudents
FROM Students
GROUP BY Grade
ORDER BY Grade;


--Top 3 students with highest average grade
SELECT s.FirstName, s.LastName, AVG(g.Grade) AS AverageGrade
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.FirstName, s.LastName
ORDER BY AverageGrade DESC
LIMIT 3;

--Courses with less than 2 students enrolled
SELECT c.CourseName
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName
HAVING COUNT(e.StudentID) < 2;


-- Update grade for a specific student in a specific course
UPDATE Grades
SET Grade = 95
WHERE StudentID = 1 AND CourseID = 1;


--Delete a student from the database
DELETE FROM Students WHERE StudentID = 4;

=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddNewStudent (
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DateOfBirth DATE,
    @Address VARCHAR(255),
    @Grade INT
)
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, Address, Grade)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Address, @Grade);
END;

-- Stored procedure to get all students in a specific grade
CREATE PROCEDURE GetStudentsByGrade (@Grade INT)
AS
BEGIN
    SELECT * FROM Students WHERE Grade = @Grade;
END;


-- Stored procedure to calculate the average grade for a student
CREATE PROCEDURE CalculateAverageGrade (@StudentID INT)
AS
BEGIN
    SELECT AVG(Grade) AS AverageGrade
    FROM Grades
    WHERE StudentID = @StudentID;
END;

-- Stored procedure to update student's address.
CREATE PROCEDURE UpdateStudentAddress (@StudentID INT, @NewAddress VARCHAR(255))
AS
BEGIN
    UPDATE Students
    SET Address = @NewAddress
    WHERE StudentID = @StudentID;
END;

-- Stored procedure to check if a student is enrolled in a course
CREATE PROCEDURE IsStudentEnrolled (@StudentID INT, @CourseID INT)
AS
BEGIN
    SELECT CASE WHEN EXISTS (SELECT 1 FROM Enrollments WHERE StudentID = @StudentID AND CourseID = @CourseID) THEN 1 ELSE 0 END AS IsEnrolled;
END;
=== END FILE ===