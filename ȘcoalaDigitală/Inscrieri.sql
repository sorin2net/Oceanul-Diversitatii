Title: SchoolManagementSystem

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    GradeLevel INT
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    InstructorID INT,
    CreditHours INT
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

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    AssignmentName VARCHAR(100),
    Score INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

=== END FILE ===

=== FILE: populate_data.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, GradeLevel) VALUES
(1, 'John', 'Doe', '2005-03-15', 10),
(2, 'Jane', 'Smith', '2004-11-20', 11),
(3, 'David', 'Lee', '2006-05-10', 9),
(4, 'Sarah', 'Jones', '2005-09-25', 10),
(5, 'Michael', 'Brown', '2004-02-01', 11);

INSERT INTO Courses (CourseID, CourseName, InstructorID, CreditHours) VALUES
(1, 'Mathematics', 1, 4),
(2, 'Science', 2, 3),
(3, 'English', 3, 3),
(4, 'History', 1, 3),
(5, 'Art', 4, 2);


INSERT INTO Instructors (InstructorID, FirstName, LastName, Department) VALUES
(1, 'Robert', 'Williams', 'Mathematics'),
(2, 'Mary', 'Davis', 'Science'),
(3, 'Linda', 'Garcia', 'English'),
(4, 'Christopher', 'Rodriguez', 'Art');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 1, 3, 'B'),
(3, 2, 2, 'A'),
(4, 2, 4, 'C'),
(5, 3, 1, 'B'),
(6, 3, 5, 'A'),
(7, 4, 1, 'C'),
(8, 4, 2, 'B'),
(9, 5, 3, 'A'),
(10,5,4,'B');

INSERT INTO Grades (GradeID, StudentID, CourseID, AssignmentName, Score) VALUES
(1, 1, 1, 'Midterm', 90),
(2, 1, 1, 'Final', 85),
(3, 1, 3, 'Essay', 88),
(4, 2, 2, 'Lab', 95),
(5, 2, 2, 'Project', 92);

=== END FILE ===


=== FILE: queries.sql ===
-- Find the names of all students enrolled in Mathematics.
SELECT FirstName, LastName
FROM Students
WHERE StudentID IN (SELECT StudentID FROM Enrollments WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Mathematics'));

-- Find the average grade of all students in Science.
SELECT AVG(CAST(Grade AS FLOAT)) AS AverageGrade
FROM Enrollments
WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Science');

-- Find the instructors who teach more than one course.
SELECT FirstName, LastName
FROM Instructors
WHERE InstructorID IN (SELECT InstructorID FROM Courses GROUP BY InstructorID HAVING COUNT(*) > 1);

-- Find the students who have a grade higher than 90 in any assignment.
SELECT s.FirstName, s.LastName, g.AssignmentName, g.Score
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.Score > 90;

--List all students and their enrolled courses.
SELECT s.FirstName || ' ' || s.LastName AS StudentName, c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;


--Find the highest grade achieved by a student in any course.
SELECT MAX(CAST(Grade AS UNSIGNED)) as HighestGrade
FROM Enrollments;


--Find the average score for each assignment.
SELECT AssignmentName, AVG(Score) AS AverageScore
FROM Grades
GROUP BY AssignmentName;

--Find the number of students enrolled in each course.
SELECT c.CourseName, COUNT(e.StudentID) AS NumberOfStudents
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

--Find all students who haven't enrolled in any courses.
SELECT FirstName, LastName
FROM Students
EXCEPT
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID;

-- Find the student with the highest average grade across all courses.
WITH StudentAverageGrades AS (
    SELECT StudentID, AVG(CAST(Grade AS FLOAT)) AS AverageGrade
    FROM Enrollments
    GROUP BY StudentID
)
SELECT s.FirstName, s.LastName, AverageGrade
FROM StudentAverageGrades sag
JOIN Students s ON sag.StudentID = s.StudentID
ORDER BY AverageGrade DESC
LIMIT 1;


=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddNewStudent (
    IN p_FirstName VARCHAR(50),
    IN p_LastName VARCHAR(50),
    IN p_DateOfBirth DATE,
    IN p_GradeLevel INT
)
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, GradeLevel)
    VALUES (p_FirstName, p_LastName, p_DateOfBirth, p_GradeLevel);
END;

-- Stored procedure to update student grade
CREATE PROCEDURE UpdateStudentGrade (
  IN p_StudentID INT,
  IN p_CourseID INT,
  IN p_NewGrade VARCHAR(2)
)
BEGIN
  UPDATE Enrollments
  SET Grade = p_NewGrade
  WHERE StudentID = p_StudentID AND CourseID = p_CourseID;
END;

-- Stored procedure to get student's transcript
CREATE PROCEDURE GetStudentTranscript (
    IN p_StudentID INT
)
BEGIN
    SELECT c.CourseName, e.Grade
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = p_StudentID;
END;


=== END FILE ===