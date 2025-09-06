Title: SchoolManagementSystem

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Grade INT,
    Email VARCHAR(255) UNIQUE
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(255),
    Instructor VARCHAR(255)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    GradeEarned INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Teachers (
    TeacherID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Subject VARCHAR(255)
);

CREATE TABLE Assignments (
    AssignmentID INT PRIMARY KEY,
    CourseID INT,
    AssignmentName VARCHAR(255),
    DueDate DATE,
    PointsPossible INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    AssignmentID INT,
    Score INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID)
);
=== END FILE ===

=== FILE: insert_data.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, Grade, Email) VALUES
(1, 'John', 'Doe', 10, 'john.doe@example.com'),
(2, 'Jane', 'Smith', 11, 'jane.smith@example.com'),
(3, 'Peter', 'Jones', 12, 'peter.jones@example.com'),
(4, 'Mary', 'Brown', 10, 'mary.brown@example.com'),
(5, 'David', 'Lee', 11, 'david.lee@example.com');

INSERT INTO Courses (CourseID, CourseName, Instructor) VALUES
(1, 'Mathematics', 'Dr. Albert Einstein'),
(2, 'Science', 'Ms. Marie Curie'),
(3, 'History', 'Mr. Abraham Lincoln'),
(4, 'English', 'Ms. Jane Austen');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, GradeEarned) VALUES
(1, 1, 1, NULL),
(2, 1, 2, NULL),
(3, 2, 1, NULL),
(4, 2, 3, NULL),
(5, 3, 2, NULL),
(6, 3, 4, NULL);

INSERT INTO Teachers (TeacherID, FirstName, LastName, Subject) VALUES
(1, 'Albert', 'Einstein', 'Mathematics'),
(2, 'Marie', 'Curie', 'Science'),
(3, 'Abraham', 'Lincoln', 'History'),
(4, 'Jane', 'Austen', 'English');

INSERT INTO Assignments (AssignmentID, CourseID, AssignmentName, DueDate, PointsPossible) VALUES
(1, 1, 'Midterm Exam', '2024-05-15', 100),
(2, 1, 'Homework 1', '2024-04-20', 20),
(3, 2, 'Lab Report', '2024-05-22', 50),
(4, 2, 'Quiz 1', '2024-04-27', 10);

INSERT INTO Grades (GradeID, StudentID, AssignmentID, Score) VALUES
(1, 1, 1, 85),
(2, 1, 2, 18),
(3, 2, 1, 92),
(4, 3, 3, 45);
=== END FILE ===

=== FILE: queries.sql ===
-- Find all students enrolled in Mathematics
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Mathematics';

-- Find the average grade for each course
SELECT c.CourseName, AVG(e.GradeEarned) AS AverageGrade
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

-- Find students with grades below 70 in a specific course
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = 1 AND e.GradeEarned < 70;


--Find all assignments for a particular course
SELECT * FROM Assignments WHERE CourseID = 1;


--List all students who haven't submitted a specific assignment.
SELECT s.FirstName, s.LastName
FROM Students s
LEFT JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.AssignmentID IS NULL AND s.StudentID IN (SELECT StudentID FROM Enrollments WHERE CourseID = 1);

-- Update a student's grade for a specific assignment
UPDATE Grades SET Score = 90 WHERE GradeID = 1;

-- Delete a student from the database
DELETE FROM Students WHERE StudentID = 5;

--Calculate the average grade for each student across all courses.
SELECT s.FirstName, s.LastName, AVG(e.GradeEarned) AS AverageGrade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FirstName, s.LastName;


--Find the top 3 students with the highest average grades across all courses.
SELECT s.FirstName, s.LastName, AVG(e.GradeEarned) AS AverageGrade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FirstName, s.LastName
ORDER BY AverageGrade DESC
LIMIT 3;

=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddStudent (
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @Grade INT,
    @Email VARCHAR(255)
)
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, Grade, Email)
    VALUES (@FirstName, @LastName, @Grade, @Email);
END;

-- Stored procedure to update student's grade in a course.
CREATE PROCEDURE UpdateStudentGrade (
    @StudentID INT,
    @CourseID INT,
    @NewGrade INT
)
AS
BEGIN
    UPDATE Enrollments
    SET GradeEarned = @NewGrade
    WHERE StudentID = @StudentID AND CourseID = @CourseID;
END;


-- Stored procedure to calculate the average grade for a student in a course
CREATE PROCEDURE CalculateAverageGrade (
    @StudentID INT,
    @CourseID INT,
    @AverageGrade FLOAT OUTPUT
)
AS
BEGIN
    SELECT @AverageGrade = AVG(GradeEarned)
    FROM Enrollments
    WHERE StudentID = @StudentID AND CourseID = @CourseID;
END;


--Stored Procedure to get all assignments for a student in a given course.
CREATE PROCEDURE GetStudentAssignments (@StudentID INT, @CourseID INT)
AS
BEGIN
    SELECT a.AssignmentName, a.DueDate, g.Score
    FROM Assignments a
    JOIN Grades g ON a.AssignmentID = g.AssignmentID
    WHERE g.StudentID = @StudentID AND a.CourseID = @CourseID;
END;

=== END FILE ===