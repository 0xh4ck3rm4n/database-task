## Database Task (Normalization)

This is a lab demonstration for database normalization from unnormalized form to 3NF.

## Learning Objectives

- ✅ Understand normalization (1NF, 2NF, 3NF)
- ✅ Writing efficient SQL DDL commands
- ✅ Verifying data integrity through JOIN operations

## Task Structure

```
database-task/
├── sql/
│   ├── university.sql          # DDL Queries
└── README.md                   # Documentation
```

## Normalization Process

### Original Unnormalized Form

```
Registration(StudentID, Name, Email, Major, Advisor, CourseID,
             CourseTitle, Credits, Grade, Building, Room)
```

**Problems**: Redundancy, update anomalies, insertion anomalies, deletion anomalies

### First Normal Form (1NF)

✅ All attributes are atomic

### Second Normal Form (2NF)

✅ Eliminated partial dependencies by separating:

- Student data → **Students** table
- Course data → **Courses** table
- Enrollment data → **Enrollments** table

### Third Normal Form (3NF)

✅ Eliminated transitive dependencies by creating:

- **Majors** table (Major → Advisor)

## Quick Start

### Prerequisites

- MySQL 5.7+ or MariaDB
- Database client (MySQL Workbench, phpMyAdmin, or CLI)

### Installation

1. **Connect to your MySQL server**

```bash
mysql -u root -p
```

2. **Execute the SQL script**

```bash
mysql -u root -p < university.sql
```

Or copy and paste the entire script into your SQL client.

3. **Verify the setup**

```sql
USE lab;
SHOW TABLES;
```

Expected output:

```
+-----------------+
| Tables_in_lab   |
+-----------------+
| Courses         |
| Enrollments     |
| Majors          |
| Students        |
+-----------------+
```

### View All Students with Their Advisors

```sql
SELECT
    s.StudentID,
    s.Name,
    s.Major,
    m.Advisor
FROM Students s
JOIN Majors m ON s.Major = m.Major;
```

### List All Course Enrollments

```sql
SELECT
    s.Name AS Student,
    c.CourseTitle AS Course,
    e.Grade,
    c.Credits
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
ORDER BY s.Name;
```

### Find Students by Major

```sql
SELECT
    s.StudentID,
    s.Name,
    s.Email
FROM Students s
WHERE s.Major = 'CS';
```

### Calculate Total Credits by Student

```sql
SELECT
    s.StudentID,
    s.Name,
    SUM(c.Credits) AS TotalCredits
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY s.StudentID, s.Name;
```

### Verification Query (Reconstruct Original Data)

```sql
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
```

## Adding New Data

### Add a New Major

```sql
INSERT INTO Majors VALUES ('Mathematics', 'Dr. Johnson');
```

### Add a New Student

```sql
INSERT INTO Students VALUES
    ('S104', 'David', 'david@uni.edu', 'Mathematics');
```

### Add a New Course

```sql
INSERT INTO Courses VALUES
    ('MATH301', 'Calculus III', 4, 'Math Wing', '203');
```

### Enroll a Student in a Course

```sql
INSERT INTO Enrollments VALUES ('S104', 'MATH301', 'A');
```

## 🧪 Testing Data Integrity

### Test 1: Try to add duplicate email

```sql
INSERT INTO Students VALUES
    ('S105', 'Eve', 'alice@uni.edu', 'CS');
-- Error: Duplicate entry 'alice@uni.edu' for key 'Email'
```

### Test 2: Try to enroll in non-existent course

```sql
INSERT INTO Enrollments VALUES ('S101', 'BIO101', 'A');
-- Error: Foreign key constraint fails
```

### Test 3: Try to delete a major with students

```sql
DELETE FROM Majors WHERE Major = 'CS';
-- Error: Cannot delete due to foreign key constraint
```

## 🔄 Database Maintenance

### View Table Structure

```sql
DESCRIBE Students;
DESCRIBE Majors;
DESCRIBE Courses;
DESCRIBE Enrollments;
```

### Check Foreign Key Relationships

```sql
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'lab'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

## Author

**0xh4ck3rm4n**
