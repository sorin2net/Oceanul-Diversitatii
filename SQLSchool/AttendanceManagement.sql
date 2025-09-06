Title: SchoolManagementSystem

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    DateOfBirth DATE,
    GradeLevel INT
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(255),
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

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    AssignmentName VARCHAR(255),
    Grade INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)

);

=== END FILE ===

=== FILE: populate_tables.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, GradeLevel) VALUES
(1, 'John', 'Doe', '2005-05-10', 9),
(2, 'Jane', 'Smith', '2004-11-20', 10),
(3, 'Peter', 'Jones', '2006-02-15', 8),
(4, 'Mary', 'Brown', '2005-08-05', 9),
(5, 'David', 'Wilson', '2003-09-25', 11);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Department) VALUES
(1, 'Robert', 'Davis', 'Mathematics'),
(2, 'Linda', 'Garcia', 'Science'),
(3, 'Michael', 'Rodriguez', 'English');

INSERT INTO Courses (CourseID, CourseName, InstructorID) VALUES
(1, 'Algebra I', 1),
(2, 'Biology', 2),
(3, 'English Literature', 3),
(4, 'Geometry', 1),
(5, 'Chemistry', 2);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, Grade) VALUES
(1, 1, 1, '2023-09-01', 'A'),
(2, 1, 2, '2023-09-01', 'B'),
(3, 2, 1, '2023-09-01', 'B'),
(4, 2, 3, '2023-09-01', 'A'),
(5, 3, 2, '2023-09-01', 'C'),
(6, 4, 1, '2023-09-01', 'B'),
(7, 5, 4, '2023-09-01', 'A');


INSERT INTO Grades (GradeID, StudentID, CourseID, AssignmentName, Grade) VALUES
(1,1,1,'Midterm',85),
(2,1,1,'Final',92),
(3,2,1,'Midterm',78),
(4,2,1,'Final',88),
(5,1,2,'Project',95),
(6,1,2,'Quiz',80),
(7,2,3,'Essay',90),
(8,2,3,'Presentation',85);


=== END FILE ===

=== FILE: queries.sql ===
-- Students with highest average grade
SELECT s.FirstName, s.LastName, AVG(g.Grade) AS AverageGrade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.FirstName, s.LastName
ORDER BY AverageGrade DESC
LIMIT 1;

-- List of courses with number of students enrolled
SELECT c.CourseName, COUNT(e.StudentID) AS NumberOfStudents
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName
ORDER BY NumberOfStudents DESC;


-- Average grade for each course
SELECT c.CourseName, AVG(g.Grade) AS AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Grades g ON e.StudentID = g.StudentID AND e.CourseID = g.CourseID
GROUP BY c.CourseName;

-- Students enrolled in multiple courses
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FirstName, s.LastName
HAVING COUNT(DISTINCT e.CourseID) > 1;

-- Instructors and their courses
SELECT i.FirstName || ' ' || i.LastName AS InstructorName,
       GROUP_CONCAT(c.CourseName) AS CoursesTaught
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
GROUP BY InstructorName;

--Find students who have a grade below 70 in any assignment.
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.Grade < 70;


-- Update grade for a specific student in a specific course
UPDATE Grades
SET Grade = 88
WHERE StudentID = 1 AND CourseID = 1 AND AssignmentName = 'Midterm';

--Delete a course
DELETE FROM Courses WHERE CourseID = 5;

=== END FILE ===

=== FILE: stored_procedures.sql ===
CREATE PROCEDURE AddStudent (
    IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_DateOfBirth DATE,
    IN p_GradeLevel INT
)
BEGIN
    DECLARE v_StudentID INT;
    SET v_StudentID = (SELECT IFNULL(MAX(StudentID),0) + 1 FROM Students);
    INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, GradeLevel)
    VALUES (v_StudentID, p_FirstName, p_LastName, p_DateOfBirth, p_GradeLevel);
    SELECT v_StudentID;
END;


CREATE PROCEDURE GetStudentGrades(
  IN p_StudentID INT
)
BEGIN
  SELECT c.CourseName, g.AssignmentName, g.Grade
  FROM Grades g
  JOIN Enrollments e ON g.StudentID = e.StudentID AND g.CourseID = e.CourseID
  JOIN Courses c ON e.CourseID = c.CourseID
  WHERE g.StudentID = p_StudentID;
END;

CALL AddStudent('Alice','Johnson','2007-03-15',8);
CALL GetStudentGrades(1);

=== END FILE ===