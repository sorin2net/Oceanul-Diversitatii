Title: SchoolManagementSystem

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    DateOfBirth DATE,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20)
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
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(255)
);

ALTER TABLE Instructors
ADD CONSTRAINT FK_InstructorDepartment
FOREIGN KEY (Department) REFERENCES Departments(DepartmentName);

=== END FILE ===

=== FILE: populate_tables.sql ===
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics');

INSERT INTO Instructors (InstructorID, FirstName, LastName, Department) VALUES
(1, 'John', 'Doe', 'Computer Science'),
(2, 'Jane', 'Smith', 'Mathematics'),
(3, 'Peter', 'Jones', 'Physics');

INSERT INTO Courses (CourseID, CourseName, InstructorID, Credits) VALUES
(1, 'Introduction to Programming', 1, 3),
(2, 'Calculus I', 2, 4),
(3, 'Classical Mechanics', 3, 3);

INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, PhoneNumber) VALUES
(1, 'Alice', 'Johnson', '2002-05-10', '123 Main St', '555-1234'),
(2, 'Bob', 'Williams', '2001-11-20', '456 Oak Ave', '555-5678'),
(3, 'Charlie', 'Brown', '2003-03-15', '789 Pine Ln', '555-9012');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 2, 2, 'B'),
(3, 3, 3, 'C'),
(4, 1, 2, 'A-');

=== END FILE ===


=== FILE: queries.sql ===
-- Find all students enrolled in "Introduction to Programming"
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Introduction to Programming';

-- Find the average grade for each course.
SELECT c.CourseName, AVG(CASE WHEN Grade = 'A' THEN 4.0 WHEN Grade = 'A-' THEN 3.7 WHEN Grade = 'B+' THEN 3.3 WHEN Grade = 'B' THEN 3.0 WHEN Grade = 'B-' THEN 2.7 WHEN Grade = 'C+' THEN 2.3 WHEN Grade = 'C' THEN 2.0 WHEN Grade = 'C-' THEN 1.7 ELSE 0 END) AS AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

-- Find instructors who teach more than one course.
SELECT i.FirstName, i.LastName
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
GROUP BY i.FirstName, i.LastName
HAVING COUNT(*) > 1;

--List all students and their enrolled courses.
SELECT s.FirstName || ' ' || s.LastName AS StudentName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

--Find students who have not enrolled in any courses.
SELECT FirstName, LastName
FROM Students
EXCEPT
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID;

=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddStudent (
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DateOfBirth DATE,
    @Address VARCHAR(255),
    @PhoneNumber VARCHAR(20)
)
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, Address, PhoneNumber)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Address, @PhoneNumber);
END;

-- Stored procedure to update student grade
CREATE PROCEDURE UpdateStudentGrade (
    @EnrollmentID INT,
    @NewGrade VARCHAR(2)
)
AS
BEGIN
    UPDATE Enrollments
    SET Grade = @NewGrade
    WHERE EnrollmentID = @EnrollmentID;
END;

-- Stored procedure to get student information by ID
CREATE PROCEDURE GetStudentInfo (@StudentID INT)
AS
BEGIN
  SELECT * FROM Students WHERE StudentID = @StudentID;
END;

--Stored procedure to find courses with less than 3 students enrolled.
CREATE PROCEDURE FindUnderEnrolledCourses
AS
BEGIN
  SELECT c.CourseName
  FROM Courses c
  LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
  GROUP BY c.CourseName
  HAVING COUNT(e.StudentID) < 3;
END;


=== END FILE ===