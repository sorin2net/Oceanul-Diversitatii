Title: SchoolManagement

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    DateOfBirth DATE,
    Address VARCHAR(255),
    GradeLevel INT
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

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    GradeLetter VARCHAR(2),
    GradePoints DECIMAL(4,2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


=== END FILE ===

=== FILE: insert_data.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, GradeLevel) VALUES
(1, 'John', 'Doe', '2005-03-15', '123 Main St', 10),
(2, 'Jane', 'Smith', '2004-11-20', '456 Oak Ave', 11),
(3, 'David', 'Lee', '2006-05-10', '789 Pine Ln', 9),
(4, 'Sarah', 'Jones', '2005-08-25', '1011 Maple Dr', 10),
(5, 'Michael', 'Brown', '2004-02-01', '1213 Birch Rd', 12);

INSERT INTO Courses (CourseID, CourseName, InstructorID, Credits) VALUES
(1, 'Mathematics', 1, 3),
(2, 'Science', 2, 4),
(3, 'English', 3, 3),
(4, 'History', 1, 3),
(5, 'Art', 4, 2);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Department) VALUES
(1, 'Dr. Robert', 'Peterson', 'Mathematics'),
(2, 'Ms. Emily', 'Wilson', 'Science'),
(3, 'Mr. David', 'Garcia', 'English'),
(4, 'Ms. Jessica', 'Rodriguez', 'Art');


INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 1, 2, 'B'),
(3, 2, 1, 'A'),
(4, 2, 3, 'C'),
(5, 3, 2, 'B');

INSERT INTO Grades (GradeID, StudentID, CourseID, GradeLetter, GradePoints) VALUES
(1, 1, 1, 'A', 4.0),
(2, 1, 2, 'B', 3.0),
(3, 2, 1, 'A', 4.0),
(4, 2, 3, 'C', 2.0),
(5, 3, 2, 'B', 3.0);


=== END FILE ===

=== FILE: queries.sql ===
-- Query 1: List all students and their enrolled courses.
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

-- Query 2: Find the average grade for each course.
SELECT c.CourseName, AVG(g.GradePoints) AS AverageGrade
FROM Courses c
JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseName;

-- Query 3: List all students who have a grade higher than 3.5 in at least one course.
SELECT DISTINCT s.FirstName, s.LastName
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.GradePoints > 3.5;

-- Query 4:  Find the number of students enrolled in each course.
SELECT c.CourseName, COUNT(e.StudentID) AS NumberOfStudents
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;


--Query 5: Find students who haven't enrolled in any courses.
SELECT FirstName, LastName
FROM Students
EXCEPT
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID;

--Query 6: Show the top 3 students with the highest GPA.
WITH StudentGPA AS (
  SELECT s.StudentID, s.FirstName, s.LastName, AVG(g.GradePoints) AS GPA
  FROM Students s
  JOIN Grades g ON s.StudentID = g.StudentID
  GROUP BY s.StudentID, s.FirstName, s.LastName
)
SELECT StudentID, FirstName, LastName, GPA
FROM StudentGPA
ORDER BY GPA DESC
LIMIT 3;


=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student.
CREATE PROCEDURE AddNewStudent (
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DateOfBirth DATE,
    @Address VARCHAR(255),
    @GradeLevel INT
)
AS
BEGIN
    DECLARE @NewStudentID INT;
    SET @NewStudentID = (SELECT ISNULL(MAX(StudentID), 0) + 1 FROM Students);
    INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, GradeLevel)
    VALUES (@NewStudentID, @FirstName, @LastName, @DateOfBirth, @Address, @GradeLevel);
    SELECT @NewStudentID;
END;

--Stored procedure to update student grade.
CREATE PROCEDURE UpdateStudentGrade (
    @StudentID INT,
    @CourseID INT,
    @NewGrade VARCHAR(2)
)
AS
BEGIN
    UPDATE Grades
    SET GradeLetter = @NewGrade
    WHERE StudentID = @StudentID AND CourseID = @CourseID;
END;

-- Stored procedure to get student's transcript.
CREATE PROCEDURE GetStudentTranscript (@StudentID INT)
AS
BEGIN
  SELECT c.CourseName, g.GradeLetter, g.GradePoints
  FROM Courses c
  JOIN Grades g ON c.CourseID = g.CourseID
  WHERE g.StudentID = @StudentID;
END;

=== END FILE ===