Title: SchoolManagementSystem

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Address VARCHAR(100),
    PhoneNumber VARCHAR(20)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Credits INT,
    InstructorID INT
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50)
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
    DepartmentName VARCHAR(50)
);

ALTER TABLE Instructors
ADD COLUMN DepartmentID INT,
ADD CONSTRAINT FK_Instructors_Departments FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);

=== END FILE ===

=== FILE: insert_data.sql ===
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics');

INSERT INTO Instructors (InstructorID, FirstName, LastName, DepartmentID) VALUES
(1, 'John', 'Doe', 1),
(2, 'Jane', 'Smith', 2),
(3, 'David', 'Lee', 3);

INSERT INTO Courses (CourseID, CourseName, Credits, InstructorID) VALUES
(1, 'Introduction to Programming', 3, 1),
(2, 'Calculus I', 4, 2),
(3, 'Classical Mechanics', 3, 3);

INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, PhoneNumber) VALUES
(1, 'Alice', 'Brown', '2002-05-10', '123 Main St', '555-1212'),
(2, 'Bob', 'Johnson', '2001-11-20', '456 Oak Ave', '555-3434'),
(3, 'Charlie', 'Williams', '2003-03-15', '789 Pine Ln', '555-5656');


INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 2, 2, 'B'),
(3, 3, 3, 'C'),
(4,1,2,'B+');

=== END FILE ===


=== FILE: queries.sql ===
-- Find all students enrolled in "Introduction to Programming"
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Introduction to Programming';


-- Find the average grade for each course.
SELECT c.CourseName, AVG(CASE WHEN Grade = 'A' THEN 4.0 WHEN Grade = 'B+' THEN 3.5 WHEN Grade = 'B' THEN 3.0 WHEN Grade = 'C+' THEN 2.5 WHEN Grade = 'C' THEN 2.0 ELSE 0 END) AS AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

--List students who haven't enrolled in any courses.
SELECT FirstName, LastName
FROM Students
EXCEPT
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID;

--Find instructors who teach more than one course.
SELECT i.FirstName, i.LastName
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
GROUP BY i.FirstName, i.LastName
HAVING COUNT(*) > 1;

--Show the number of students in each department. (Requires additional joins)
SELECT d.DepartmentName, COUNT(DISTINCT s.StudentID) AS StudentCount
FROM Departments d
JOIN Instructors i ON d.DepartmentID = i.DepartmentID
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Students s ON e.StudentID = s.StudentID
GROUP BY d.DepartmentName;

=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddStudent (
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DateOfBirth DATE,
    @Address VARCHAR(100),
    @PhoneNumber VARCHAR(20)
)
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, Address, PhoneNumber)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Address, @PhoneNumber);
END;

-- Stored procedure to update a student's grade in a course.
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


-- Stored procedure to get all students from a specific course
CREATE PROCEDURE GetStudentsByCourse (@CourseID INT)
AS
BEGIN
  SELECT s.FirstName, s.LastName
  FROM Students s
  JOIN Enrollments e ON s.StudentID = e.StudentID
  WHERE e.CourseID = @CourseID;
END;

-- Stored procedure to find the top 3 students with the highest GPA
CREATE PROCEDURE GetTop3Students()
AS
BEGIN
  WITH StudentGPA AS (
    SELECT s.StudentID, s.FirstName, s.LastName, AVG(CASE WHEN Grade = 'A' THEN 4.0 WHEN Grade = 'B+' THEN 3.5 WHEN Grade = 'B' THEN 3.0 WHEN Grade = 'C+' THEN 2.5 WHEN Grade = 'C' THEN 2.0 ELSE 0 END) AS GPA
    FROM Students s
    JOIN Enrollments e ON s.StudentID = e.StudentID
    GROUP BY s.StudentID, s.FirstName, s.LastName
  )
  SELECT FirstName, LastName, GPA
  FROM StudentGPA
  ORDER BY GPA DESC
  FETCH FIRST 3 ROWS ONLY;
END;

=== END FILE ===