Title: SchoolManagementSystem

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
    AssignmentName VARCHAR(255),
    Score INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

=== END FILE ===

=== FILE: populate_data.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Address, GradeLevel) VALUES
(1, 'John', 'Doe', '2005-03-15', '123 Main St', 9),
(2, 'Jane', 'Smith', '2004-11-20', '456 Oak Ave', 10),
(3, 'Peter', 'Jones', '2006-05-10', '789 Pine Ln', 8);

INSERT INTO Courses (CourseID, CourseName, InstructorID, Credits) VALUES
(1, 'Mathematics', 1, 3),
(2, 'Science', 2, 4),
(3, 'History', 3, 3);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Department) VALUES
(1, 'Alice', 'Brown', 'Mathematics'),
(2, 'Bob', 'Davis', 'Science'),
(3, 'Charlie', 'Evans', 'History');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 1, 2, 'B'),
(3, 2, 1, 'C'),
(4, 2, 3, 'A'),
(5, 3, 2, 'B');


INSERT INTO Grades (GradeID, StudentID, CourseID, AssignmentName, Score) VALUES
(1, 1, 1, 'Midterm Exam', 90),
(2, 1, 1, 'Final Exam', 85),
(3, 1, 2, 'Midterm Exam', 78),
(4, 2, 1, 'Midterm Exam', 65),
(5, 2, 3, 'Final Exam', 95);

=== END FILE ===


=== FILE: queries.sql ===
--Students with grades above 80 in Math
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Mathematics' AND e.Grade = 'A';

--Average grade for each course
SELECT c.CourseName, AVG(CASE WHEN e.Grade = 'A' THEN 4 WHEN e.Grade = 'B' THEN 3 WHEN e.Grade = 'C' THEN 2 ELSE 1 END) AS AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

--Top 3 students with highest average grades
SELECT s.FirstName, s.LastName, AVG(CASE WHEN e.Grade = 'A' THEN 4 WHEN e.Grade = 'B' THEN 3 WHEN e.Grade = 'C' THEN 2 ELSE 1 END) AS AverageGrade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FirstName, s.LastName
ORDER BY AverageGrade DESC
LIMIT 3;

--Students enrolled in more than one course
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FirstName, s.LastName
HAVING COUNT(DISTINCT e.CourseID) > 1;


--All assignments and scores for a specific student
SELECT a.AssignmentName, a.Score
FROM Grades a
WHERE a.StudentID = 1;


--List of instructors and the courses they teach
SELECT i.FirstName || ' ' || i.LastName AS InstructorName, c.CourseName
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID;

--Number of students in each grade level
SELECT GradeLevel, COUNT(*) AS NumberOfStudents
FROM Students
GROUP BY GradeLevel;

--Students who haven't received a grade yet in a specific course
SELECT s.FirstName, s.LastName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = 1 AND e.Grade IS NULL;


--Update a student's address
UPDATE Students SET Address = '101 New Street' WHERE StudentID = 1;

--Delete a course
DELETE FROM Courses WHERE CourseID = 3;


=== END FILE ===

=== FILE: stored_procedures.sql ===
CREATE OR REPLACE PROCEDURE AddStudent (
    p_FirstName VARCHAR(255),
    p_LastName VARCHAR(255),
    p_DateOfBirth DATE,
    p_Address VARCHAR(255),
    p_GradeLevel INT
)
AS $$
DECLARE
    v_StudentID INT;
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, Address, GradeLevel)
    VALUES (p_FirstName, p_LastName, p_DateOfBirth, p_Address, p_GradeLevel)
    RETURNING StudentID INTO v_StudentID;
    RAISE NOTICE 'Student added with ID: %', v_StudentID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE GetStudentGrades(
    p_StudentID INT
)
AS $$
BEGIN
    SELECT c.CourseName, g.AssignmentName, g.Score
    FROM Grades g
    JOIN Courses c ON g.CourseID = c.CourseID
    WHERE g.StudentID = p_StudentID;
END;
$$ LANGUAGE plpgsql;

CALL AddStudent('Alice', 'Johnson', '2007-02-10', '500 Park Ave', 10);
CALL GetStudentGrades(1);

=== END FILE ===