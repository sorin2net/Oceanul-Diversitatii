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
    EnrollmentDate DATE,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(255)
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
(1, 'Alice', 'Johnson', '2002-05-10', '123 Main St', '555-1234'),
(2, 'Bob', 'Williams', '2001-11-20', '456 Oak Ave', '555-5678'),
(3, 'Charlie', 'Brown', '2003-03-15', '789 Pine Ln', '555-9012');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, Grade) VALUES
(1, 1, 1, '2023-09-01', 'A'),
(2, 2, 2, '2023-09-01', 'B'),
(3, 3, 3, '2023-09-01', 'C'),
(4, 1, 2, '2023-09-01', 'B+');

=== END FILE ===


=== FILE: queries.sql ===
-- Query 1: List all students enrolled in "Introduction to Programming"
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Introduction to Programming';

-- Query 2: Find the average grade for Calculus I
SELECT AVG(CASE WHEN Grade = 'A' THEN 4.0 WHEN Grade = 'B+' THEN 3.5 WHEN Grade = 'B' THEN 3.0 WHEN Grade = 'C+' THEN 2.5 WHEN Grade = 'C' THEN 2.0 ELSE 0 END) AS AverageGrade
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Calculus I';

-- Query 3: List all instructors and the courses they teach
SELECT i.FirstName, i.LastName, c.CourseName
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID;

-- Query 4: Find the number of students enrolled in each course
SELECT c.CourseName, COUNT(e.StudentID) AS NumberOfStudents
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

--Query 5:  List students who haven't enrolled in any courses.
SELECT FirstName, LastName
FROM Students
EXCEPT
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID;


--Query 6: Show the top 3 students with the highest average grade.
WITH StudentAvgGrades AS (
  SELECT StudentID, AVG(CASE WHEN Grade = 'A' THEN 4.0 WHEN Grade = 'B+' THEN 3.5 WHEN Grade = 'B' THEN 3.0 WHEN Grade = 'C+' THEN 2.5 WHEN Grade = 'C' THEN 2.0 ELSE 0 END) as AvgGrade
  FROM Enrollments
  GROUP BY StudentID
)
SELECT s.FirstName, s.LastName, AvgGrade
FROM StudentAvgGrades sag
JOIN Students s ON sag.StudentID = s.StudentID
ORDER BY AvgGrade DESC
LIMIT 3;


=== END FILE ===


=== FILE: procedures.sql ===
-- Procedure 1: Add a new student
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

-- Procedure 2: Update student's address
CREATE PROCEDURE UpdateStudentAddress (
    @StudentID INT,
    @NewAddress VARCHAR(255)
)
AS
BEGIN
    UPDATE Students
    SET Address = @NewAddress
    WHERE StudentID = @StudentID;
END;

-- Procedure 3: Enroll a student in a course
CREATE PROCEDURE EnrollStudentInCourse (
    @StudentID INT,
    @CourseID INT,
    @EnrollmentDate DATE
)
AS
BEGIN
    INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
    VALUES (@StudentID, @CourseID, @EnrollmentDate);
END;

-- Procedure 4:  Get all courses for a given student
CREATE PROCEDURE GetStudentCourses (@StudentID INT)
AS
BEGIN
  SELECT c.CourseName
  FROM Courses c
  JOIN Enrollments e ON c.CourseID = e.CourseID
  WHERE e.StudentID = @StudentID;
END;

-- Procedure 5: Get all students in a department's courses.
CREATE PROCEDURE GetStudentsInDepartmentCourses (@DepartmentID INT)
AS
BEGIN
SELECT DISTINCT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Instructors i ON c.InstructorID = i.InstructorID
WHERE i.DepartmentID = @DepartmentID;
END;

=== END FILE ===