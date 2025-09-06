Title: SchoolManagement

=== FILE: Student.cs ===
using System;
using System.Collections.Generic;

public class Student
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public int StudentID { get; set; }
    public List<Course> EnrolledCourses { get; set; } = new List<Course>();
    public double CalculateGPA()
    {
        double totalGradePoints = 0;
        int totalCredits = 0;
        foreach (var course in EnrolledCourses)
        {
            totalGradePoints += course.Grade * course.Credits;
            totalCredits += course.Credits;
        }
        return totalCredits > 0 ? totalGradePoints / totalCredits : 0;
    }
    public Student(string firstName, string lastName, int studentID)
    {
        FirstName = firstName;
        LastName = lastName;
        StudentID = studentID;
    }

    public void EnrollInCourse(Course course)
    {
        if (!EnrolledCourses.Contains(course))
        {
            EnrolledCourses.Add(course);
            course.AddStudent(this);

        }
    }

    public void DropCourse(Course course)
    {
        if (EnrolledCourses.Contains(course))
        {
            EnrolledCourses.Remove(course);
            course.RemoveStudent(this);
        }
    }
}
=== END FILE ===

=== FILE: Course.cs ===
using System;
using System.Collections.Generic;

public class Course
{
    public string CourseName { get; set; }
    public int CourseID { get; set; }
    public int Credits { get; set; }
    public List<Student> Students { get; set; } = new List<Student>();
    public double Grade { get; set; }

    public Course(string courseName, int courseID, int credits)
    {
        CourseName = courseName;
        CourseID = courseID;
        Credits = credits;
    }

    public void AddStudent(Student student)
    {
        if (!Students.Contains(student))
        {
            Students.Add(student);
        }
    }

    public void RemoveStudent(Student student)
    {
        if (Students.Contains(student))
        {
            Students.Remove(student);
        }
    }


    public void AssignGrade(Student student, double grade)
    {
        if (Students.Contains(student))
        {
            Grade = grade;
        }
    }
}
=== END FILE ===

=== FILE: School.cs ===
using System;
using System.Collections.Generic;

public class School
{
    public string SchoolName { get; set; }
    public List<Student> Students { get; set; } = new List<Student>();
    public List<Course> Courses { get; set; } = new List<Course>();

    public School(string schoolName)
    {
        SchoolName = schoolName;
    }

    public void AddStudent(Student student)
    {
        if (!Students.Contains(student))
        {
            Students.Add(student);
        }
    }

    public void AddCourse(Course course)
    {
        if (!Courses.Contains(course))
        {
            Courses.Add(course);
        }
    }

    public Student FindStudent(int studentID)
    {
        foreach (var student in Students)
        {
            if (student.StudentID == studentID)
            {
                return student;
            }
        }
        return null;
    }

    public Course FindCourse(int courseID)
    {
        foreach(var course in Courses)
        {
            if(course.CourseID == courseID)
            {
                return course;
            }
        }
        return null;
    }

    public void GenerateReport()
    {
        Console.WriteLine($"School Report for {SchoolName}");
        Console.WriteLine("-------------------------");
        foreach (var student in Students)
        {
            Console.WriteLine($"Student: {student.FirstName} {student.LastName}, ID: {student.StudentID}");
            Console.WriteLine("Enrolled Courses:");
            if(student.EnrolledCourses.Count == 0)
            {
                Console.WriteLine("  None");
            }
            foreach (var course in student.EnrolledCourses)
            {
                Console.WriteLine($"  {course.CourseName}, Grade: {course.Grade}");
            }
            Console.WriteLine($"GPA: {student.CalculateGPA():F2}");
            Console.WriteLine("-------------------------");
        }
    }
}
=== END FILE ===

=== FILE: Program.cs ===
using System;

public class Program
{
    public static void Main(string[] args)
    {
        School school = new School("Example High School");

        Student student1 = new Student("John", "Doe", 1234);
        Student student2 = new Student("Jane", "Smith", 5678);

        Course course1 = new Course("Math", 101, 3);
        Course course2 = new Course("Science", 102, 4);
        Course course3 = new Course("History", 103, 3);


        school.AddStudent(student1);
        school.AddStudent(student2);
        school.AddCourse(course1);
        school.AddCourse(course2);
        school.AddCourse(course3);

        student1.EnrollInCourse(course1);
        student1.EnrollInCourse(course2);
        student2.EnrollInCourse(course2);
        student2.EnrollInCourse(course3);

        course1.AssignGrade(student1, 3.7);
        course2.AssignGrade(student1, 3.9);
        course2.AssignGrade(student2, 3.5);
        course3.AssignGrade(student2, 4.0);


        school.GenerateReport();

        student1.DropCourse(course2);

        Console.WriteLine("\nReport after dropping a course:");
        school.GenerateReport();


    }
}
=== END FILE ===