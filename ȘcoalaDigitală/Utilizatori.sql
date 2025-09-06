Title: SchoolManagement

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

=== FILE: populate_data.sql ===
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Mathematics'),
(2, 'Science'),
(3, 'Literature'),
(4, 'History');

INSERT INTO Instructors (InstructorID, FirstName, LastName, DepartmentID) VALUES
(1, 'John', 'Doe', 1),
(2, 'Jane', 'Smith', 2),
(3, 'Robert', 'Brown', 3),
(4, 'Emily', 'Wilson', 4);

INSERT INTO Courses (CourseID, CourseName, InstructorID, Credits) VALUES
(1, 'Calculus I', 1, 3),
(2, 'Biology I', 2, 4),
(3, 'English Literature', 3, 3),
(4, 'World History', 4, 3);

INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, GradeLevel) VALUES
(1, 'Alice', 'Johnson', '2005-05-10', 10),
(2, 'Bob', 'Williams', '2004-11-15', 11),
(3, 'Charlie', 'Davis', '2006-02-20', 9),
(4, 'David', 'Miller', '2005-08-25', 10);


INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 1, 2, 'B'),
(3, 2, 1, 'C'),
(4, 2, 3, 'A'),
(5, 3, 2, 'B'),
(6, 4, 4, 'A');

INSERT INTO Grades (GradeID, StudentID, CourseID, Grade) VALUES
(1,1,1,'A'),(2,1,2,'B'),(3,2,1,'C'),(4,2,3,'A'),(5,3,2,'B'),(6,4,4,'A');

=== END FILE ===


=== FILE: queries.sql ===
-- Query 1: List all students with their enrolled courses.
SELECT
    s.FirstName || ' ' || s.LastName AS StudentName,
    c.CourseName
FROM
    Students s
JOIN
    Enrollments e ON s.StudentID = e.StudentID
JOIN
    Courses c ON e.CourseID = c.CourseID;

-- Query 2: Find the average grade for each course.
SELECT
    c.CourseName,
    AVG(g.Grade) AS AverageGrade
FROM
    Courses c
JOIN
    Grades g ON c.CourseID = g.CourseID
GROUP BY
    c.CourseName;

-- Query 3: List all instructors and the courses they teach.
SELECT
    i.FirstName || ' ' || i.LastName AS InstructorName,
    c.CourseName
FROM
    Instructors i
JOIN
    Courses c ON i.InstructorID = c.InstructorID;

-- Query 4: Find students who have enrolled in more than 2 courses.
SELECT
    s.FirstName || ' ' || s.LastName AS StudentName
FROM
    Students s
JOIN
    Enrollments e ON s.StudentID = e.StudentID
GROUP BY
    s.StudentID
HAVING
    COUNT(e.CourseID) > 2;

-- Query 5:  List the top 3 students with the highest average grade.
WITH StudentAverageGrades AS (
    SELECT
        StudentID,
        AVG(CASE WHEN Grade = 'A' THEN 4 WHEN Grade = 'B' THEN 3 WHEN Grade = 'C' THEN 2 WHEN Grade = 'D' THEN 1 ELSE 0 END) AS AverageGrade
    FROM Grades
    GROUP BY StudentID
)
SELECT
    s.FirstName || ' ' || s.LastName AS StudentName,
    sag.AverageGrade
FROM
    StudentAverageGrades sag
JOIN
    Students s ON sag.StudentID = s.StudentID
ORDER BY
    sag.AverageGrade DESC
LIMIT 3;

=== END FILE ===

=== FILE: procedures.sql ===
-- Procedure 1: Add a new student
CREATE PROCEDURE AddStudent (
    p_FirstName VARCHAR(255),
    p_LastName VARCHAR(255),
    p_DateOfBirth DATE,
    p_GradeLevel INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO Students (FirstName, LastName, DateOfBirth, GradeLevel)
  VALUES (p_FirstName, p_LastName, p_DateOfBirth, p_GradeLevel);
END;
$$;

-- Procedure 2: Update student grade
CREATE PROCEDURE UpdateStudentGrade (
    p_StudentID INT,
    p_CourseID INT,
    p_NewGrade VARCHAR(2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Grades
    SET Grade = p_NewGrade
    WHERE StudentID = p_StudentID AND CourseID = p_CourseID;
END;
$$;

-- Procedure 3: Get Student Details by ID
CREATE OR REPLACE PROCEDURE GetStudentDetails (
    IN p_StudentID INT,
    OUT p_FirstName VARCHAR(255),
    OUT p_LastName VARCHAR(255),
    OUT p_GradeLevel INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT FirstName, LastName, GradeLevel
    INTO p_FirstName, p_LastName, p_GradeLevel
    FROM Students
    WHERE StudentID = p_StudentID;
END;
$$;

=== END FILE ===


=== FILE: main.sql ===
-- Example usage of procedures and queries

CALL AddStudent('Eva','Green','2007-03-15',9);

CALL UpdateStudentGrade(1,1,'B');

CALL GetStudentDetails(1, @firstName, @lastName, @gradeLevel);
SELECT @firstName, @lastName, @gradeLevel;

\i queries.sql;


=== END FILE ===