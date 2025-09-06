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
    Credits INT
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Teachers (
    TeacherID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Department VARCHAR(255)
);

CREATE TABLE Teaches (
    TeacherID INT,
    CourseID INT,
    PRIMARY KEY (TeacherID, CourseID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
=== END FILE ===

=== FILE: populate_tables.sql ===
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, GradeLevel) VALUES
(1, 'John', 'Doe', '2005-03-15', 10),
(2, 'Jane', 'Smith', '2004-11-20', 11),
(3, 'Peter', 'Jones', '2006-05-10', 9),
(4, 'Alice', 'Brown', '2005-09-25', 10),
(5, 'Bob', 'Davis', '2004-02-01', 11);

INSERT INTO Courses (CourseID, CourseName, Credits) VALUES
(1, 'Mathematics', 3),
(2, 'Science', 3),
(3, 'History', 2),
(4, 'English', 3),
(5, 'Computer Science', 4);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 1, 2, 'B'),
(3, 2, 1, 'A'),
(4, 2, 4, 'C'),
(5, 3, 3, 'B'),
(6, 4, 1, 'B'),
(7, 4, 5, 'A'),
(8, 5, 2, 'C'),
(9, 5, 4, 'B');

INSERT INTO Teachers (TeacherID, FirstName, LastName, Department) VALUES
(1, 'Robert', 'Johnson', 'Mathematics'),
(2, 'Sarah', 'Williams', 'Science'),
(3, 'David', 'Miller', 'History'),
(4, 'Emily', 'Wilson', 'English'),
(5, 'Michael', 'Garcia', 'Computer Science');


INSERT INTO Teaches (TeacherID, CourseID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
=== END FILE ===


=== FILE: queries.sql ===
-- Students with highest grade in a specific course
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = 1 AND e.Grade = (SELECT MAX(Grade) FROM Enrollments WHERE CourseID = 1);

-- Average grade for each course
SELECT c.CourseName, AVG(CASE WHEN e.Grade = 'A' THEN 4 WHEN e.Grade = 'B' THEN 3 WHEN e.Grade = 'C' THEN 2 ELSE 1 END) AS AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;


-- Number of students in each grade level
SELECT GradeLevel, COUNT(*) AS NumberOfStudents
FROM Students
GROUP BY GradeLevel;

--Teachers who teach more than one course
SELECT t.FirstName, t.LastName
FROM Teachers t
JOIN Teaches te ON t.TeacherID = te.TeacherID
GROUP BY t.FirstName, t.LastName
HAVING COUNT(*) > 1;

-- Students enrolled in both Mathematics and Science
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (1,2)
GROUP BY s.FirstName, s.LastName
HAVING COUNT(*) = 2;

-- All courses a specific student is enrolled in
SELECT c.CourseName
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.StudentID = 1;

-- Update a student's grade
UPDATE Enrollments
SET Grade = 'A'
WHERE EnrollmentID = 2;


-- Delete a student from the database
DELETE FROM Students
WHERE StudentID = 5;


=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student
CREATE PROCEDURE AddStudent (
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DateOfBirth DATE,
    @GradeLevel INT
)
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, GradeLevel)
    VALUES (@FirstName, @LastName, @DateOfBirth, @GradeLevel);
END;


-- Stored procedure to get all students in a specific grade
CREATE PROCEDURE GetStudentsByGrade (@GradeLevel INT)
AS
BEGIN
    SELECT *
    FROM Students
    WHERE GradeLevel = @GradeLevel;
END;

-- Stored procedure to update student's grade level
CREATE PROCEDURE UpdateStudentGradeLevel (@StudentID INT, @NewGradeLevel INT)
AS
BEGIN
	IF EXISTS (SELECT * FROM Students WHERE StudentID = @StudentID)
		BEGIN
			UPDATE Students
			SET GradeLevel = @NewGradeLevel
			WHERE StudentID = @StudentID;
		END
	ELSE
		BEGIN
			PRINT 'Student not found.'
		END
END;

-- Stored procedure to find average grade for a given student.
CREATE PROCEDURE GetStudentAverageGrade (@StudentID INT)
AS
BEGIN
	DECLARE @avgGrade FLOAT;
	SELECT @avgGrade = AVG(CASE WHEN Grade = 'A' THEN 4.0 WHEN Grade = 'B' THEN 3.0 WHEN Grade = 'C' THEN 2.0 ELSE 1.0 END)
	FROM Enrollments
	WHERE StudentID = @StudentID;
	SELECT @avgGrade AS AverageGrade;
END;


=== END FILE ===