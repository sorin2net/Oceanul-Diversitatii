Title: SchoolManagement

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
    Credits INT,
    InstructorID INT
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
ADD FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);


=== END FILE ===

=== FILE: insert_data.sql ===
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics');

INSERT INTO Instructors (InstructorID, FirstName, LastName, DepartmentID) VALUES
(1, 'John', 'Doe', 1),
(2, 'Jane', 'Smith', 2),
(3, 'Peter', 'Jones', 3);

INSERT INTO Courses (CourseID, CourseName, Credits, InstructorID) VALUES
(1, 'Introduction to Programming', 3, 1),
(2, 'Calculus I', 4, 2),
(3, 'Classical Mechanics', 3, 3);

INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, PhoneNumber) VALUES
(1, 'Alice', 'Johnson', '2002-05-10', '123 Main St', '555-1234'),
(2, 'Bob', 'Williams', '2001-11-15', '456 Oak Ave', '555-5678'),
(3, 'Charlie', 'Brown', '2003-02-20', '789 Pine Ln', '555-9012');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 2, 1, 'B'),
(3, 3, 2, 'C'),
(4, 1, 2, 'A');

=== END FILE ===


=== FILE: queries.sql ===
-- List all students enrolled in "Introduction to Programming"
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Introduction to Programming';

-- List all courses taught by John Doe
SELECT c.CourseName
FROM Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID
WHERE i.FirstName = 'John' AND i.LastName = 'Doe';


-- Find the average grade for each course.
SELECT c.CourseName, AVG(CASE WHEN e.Grade = 'A' THEN 4 WHEN e.Grade = 'B' THEN 3 WHEN e.Grade = 'C' THEN 2 WHEN e.Grade = 'D' THEN 1 ELSE 0 END) AS AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;


-- Find students who have enrolled in more than one course.
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(DISTINCT e.CourseID) > 1;

--List all students and the courses they are enrolled in, even if they haven't enrolled in any course.
SELECT s.FirstName, s.LastName, COALESCE(c.CourseName, 'Not Enrolled') as CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;


=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddNewStudent (
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

--Stored procedure to update student's grade
CREATE PROCEDURE UpdateStudentGrade (@EnrollmentID INT, @NewGrade VARCHAR(2))
AS
BEGIN
    UPDATE Enrollments
    SET Grade = @NewGrade
    WHERE EnrollmentID = @EnrollmentID;
END;

-- Stored procedure to get the number of students in each department
CREATE PROCEDURE GetNumberOfStudentsPerDepartment
AS
BEGIN
    SELECT d.DepartmentName, COUNT(DISTINCT s.StudentID) AS NumberOfStudents
    FROM Departments d
    JOIN Instructors i ON d.DepartmentID = i.DepartmentID
    JOIN Courses c ON i.InstructorID = c.InstructorID
    JOIN Enrollments e ON c.CourseID = e.CourseID
    JOIN Students s ON e.StudentID = s.StudentID
    GROUP BY d.DepartmentName;
END;

EXEC GetNumberOfStudentsPerDepartment;

=== END FILE ===