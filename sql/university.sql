-- New Database created for lab demonstration
CREATE DATABASE lab;

-- Using the created database
USE lab;

-- ######################
-- CREATING TABLE IN 3NF
-- ######################

-- Creating Major Table
CREATE TABLE Majors (
    Major VARCHAR(50) PRIMARY KEY, 
    Advisor VARCHAR(100) NOT NULL
    );

INSERT INTO Majors VALUES
    ('CS', 'Dr. Smith'),
    ('Physics', 'Dr. Lee');

-- Creating Student Table
CREATE TABLE Students (
    StudentID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Major VARCHAR(50),
    FOREIGN KEY (Major) REFERENCES Majors(Major)
    );

INSERT INTO Students VALUES
    ('S101', 'Alice', 'alice@uni.edu', 'CS'),
    ('S102', 'Bob', 'bob@uni.edu', 'CS'),
    ('S103', 'Carol', 'carol@uni.edu', 'Physics');

-- Creating Courses Table
CREATE TABLE Courses (
    CourseID VARCHAR(10) PRIMARY KEY,
    CourseTitle VARCHAR(100) NOT NULL,
    Credits INT NOT NULL,
    Building VARCHAR(50),
    Room VARCHAR(10)
    );

INSERT INTO Courses VALUES
    ('CS301', 'Algorithms', 4, 'Science', '205'),
    ('MATH201', 'Linear Algebra', 3, 'Math Wing', '101'),
    ('PHYS101', 'Mechanics', 4, 'Science', '301');

-- Creating Enrollments Table
CREATE TABLE Enrollments (
    StudentID VARCHAR(10),
    CourseID VARCHAR(10),
    Grade CHAR(1),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
    );

INSERT INTO Enrollments VALUES
    ('S101', 'CS301', 'A'),
    ('S101', 'MATH201', 'B'),
    ('S102', 'CS301', 'C'),
    ('S103', 'PHYS101', 'A');

-- Verification Queries
SELECT '=== STUDENT TABLE ===' AS Info;
SELECT * FROM Students;

SELECT
    s.StudentID,
    s.Name,
    s.Email,
    s.Major,
    m.Advisor,
    c.CourseID,
    c.CourseTitle,
    c.Credits,
    e.Grade,
    c.Building,
    c.Room
FROM Students s
JOIN Majors m ON s.Major = m.Major
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;
