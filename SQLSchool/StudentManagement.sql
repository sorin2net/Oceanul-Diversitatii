Title: SchoolManagementSystem

=== FILE: create_tables.sql ===
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Address VARCHAR(100),
    PhoneNumber VARCHAR(20)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT,
    InstructorID INT
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
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

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

ALTER TABLE Instructors ADD COLUMN DepartmentID INT;
ALTER TABLE Instructors ADD CONSTRAINT FK_Instructor_Department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);


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
(3, 'Charlie', 'Brown', '2003-03-20', '789 Pine Ln', '555-9012');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 1, 'A'),
(2, 1, 2, 'B'),
(3, 2, 1, 'C'),
(4, 3, 3, 'A');

=== END FILE ===

=== FILE: queries.sql ===
-- List all students with their enrolled courses.
SELECT
    s.FirstName || ' ' || s.LastName AS StudentName,
    c.CourseName
FROM
    Students s
JOIN
    Enrollments e ON s.StudentID = e.StudentID
JOIN
    Courses c ON e.CourseID = c.CourseID;

-- Find the average grade for each course.
SELECT
    c.CourseName,
    AVG(CASE WHEN Grade = 'A' THEN 4 WHEN Grade = 'B' THEN 3 WHEN Grade = 'C' THEN 2 WHEN Grade = 'D' THEN 1 ELSE 0 END) AS AverageGrade
FROM
    Courses c
JOIN
    Enrollments e ON c.CourseID = e.CourseID
GROUP BY
    c.CourseName;

-- List instructors and the number of students they teach.
SELECT
    i.FirstName || ' ' || i.LastName AS InstructorName,
    COUNT(DISTINCT e.StudentID) AS NumberOfStudents
FROM
    Instructors i
JOIN
    Courses c ON i.InstructorID = c.InstructorID
JOIN
    Enrollments e ON c.CourseID = e.CourseID
GROUP BY
    InstructorName
ORDER BY
    NumberOfStudents DESC;

-- Find students who are enrolled in more than one course.
SELECT
    s.FirstName || ' ' || s.LastName AS StudentName
FROM
    Students s
JOIN
    Enrollments e ON s.StudentID = e.StudentID
GROUP BY
    StudentName
HAVING
    COUNT(*) > 1;

--Show all the students from Computer Science department.
SELECT s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Instructors i ON c.InstructorID = i.InstructorID
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';


=== END FILE ===

=== FILE: stored_procedures.sql ===
-- Stored procedure to add a new student.
CREATE PROCEDURE AddStudent (
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DateOfBirth DATE,
    @Address VARCHAR(100),
    @PhoneNumber VARCHAR(20)
)
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, Address, PhoneNumber)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Address, @PhoneNumber);
END;

-- Stored procedure to update student's grade in a course.
CREATE PROCEDURE UpdateGrade (
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

-- Stored procedure to get all students born after a specific date.
CREATE PROCEDURE GetStudentsAfterDate (@DateOfBirth DATE)
AS
BEGIN
  SELECT * FROM Students WHERE DateOfBirth > @DateOfBirth;
END;

-- Stored procedure to get the top N students with the highest GPA
CREATE PROCEDURE GetTopStudents (@N INT)
AS
BEGIN
    WITH StudentGPA AS (
        SELECT
            s.StudentID,
            s.FirstName,
            s.LastName,
            AVG(CASE WHEN Grade = 'A' THEN 4.0 WHEN Grade = 'B' THEN 3.0 WHEN Grade = 'C' THEN 2.0 WHEN Grade = 'D' THEN 1.0 ELSE 0.0 END) AS GPA
        FROM
            Students s
        JOIN
            Enrollments e ON s.StudentID = e.StudentID
        GROUP BY
            s.StudentID, s.FirstName, s.LastName
    )
    SELECT StudentID, FirstName, LastName, GPA
    FROM StudentGPA
    ORDER BY GPA DESC
    LIMIT @N;
END;

=== END FILE ===