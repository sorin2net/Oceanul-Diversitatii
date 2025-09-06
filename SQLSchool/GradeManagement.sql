Title: SchoolManagement

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    DateOfBirth DATE,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(255)
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
    Department VARCHAR(255),
    Email VARCHAR(255)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    Grade VARCHAR(2),
    GradePoint INT
);


=== END FILE ===

=== FILE: populate_tables.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, PhoneNumber, Email) VALUES
(1, 'John', 'Doe', '2002-05-10', '123 Main St', '555-1234', 'john.doe@example.com'),
(2, 'Jane', 'Smith', '2001-11-15', '456 Oak Ave', '555-5678', 'jane.smith@example.com'),
(3, 'Peter', 'Jones', '2003-02-20', '789 Pine Ln', '555-9012', 'peter.jones@example.com');


INSERT INTO Courses (CourseID, CourseName, Credits, InstructorID) VALUES
(1, 'Introduction to Programming', 3, 1),
(2, 'Calculus I', 4, 2),
(3, 'Linear Algebra', 3, 2);


INSERT INTO Instructors (InstructorID, FirstName, LastName, Department, Email) VALUES
(1, 'David', 'Lee', 'Computer Science', 'david.lee@example.com'),
(2, 'Sarah', 'Williams', 'Mathematics', 'sarah.williams@example.com');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 1, 2, 'B'),
(3, 2, 1, 'C'),
(4, 3, 3, 'A');

INSERT INTO Grades (GradeID, Grade, GradePoint) VALUES
(1,'A',4),
(2,'B',3),
(3,'C',2),
(4,'D',1),
(5,'F',0);

=== END FILE ===


=== FILE: queries.sql ===
-- List all students with their enrolled courses
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

-- List all courses and their instructors
SELECT c.CourseName, i.FirstName, i.LastName
FROM Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID;

-- Find the average grade for each course.
SELECT c.CourseName, AVG(g.GradePoint) AS AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Grades g ON e.Grade = g.Grade
GROUP BY c.CourseName;


-- Find students who have enrolled in more than one course.
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID
HAVING COUNT(e.CourseID) > 1;


--List students with grades below average.
WITH CourseAverage AS (
  SELECT c.CourseID, AVG(g.GradePoint) AS AverageGrade
  FROM Courses c
  JOIN Enrollments e ON c.CourseID = e.CourseID
  JOIN Grades g ON e.Grade = g.Grade
  GROUP BY c.CourseID
)
SELECT s.FirstName, s.LastName, e.Grade, ca.AverageGrade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Grades g ON e.Grade = g.Grade
JOIN CourseAverage ca ON e.CourseID = ca.CourseID
WHERE g.GradePoint < ca.AverageGrade;

=== END FILE ===

=== FILE: procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddStudent (
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DateOfBirth DATE,
    @Address VARCHAR(255),
    @PhoneNumber VARCHAR(20),
    @Email VARCHAR(255)
)
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, Address, PhoneNumber, Email)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Address, @PhoneNumber, @Email);
END;

--Stored procedure to update student grade
CREATE PROCEDURE UpdateStudentGrade (
    @StudentID INT,
    @CourseID INT,
    @NewGrade VARCHAR(2)
)
AS
BEGIN
    UPDATE Enrollments
    SET Grade = @NewGrade
    WHERE StudentID = @StudentID AND CourseID = @CourseID;
END;


--Stored procedure to get student's transcript
CREATE PROCEDURE GetStudentTranscript (@StudentID INT)
AS
BEGIN
    SELECT c.CourseName, e.Grade
    FROM Courses c
    JOIN Enrollments e ON c.CourseID = e.CourseID
    WHERE e.StudentID = @StudentID;
END;

=== END FILE ===