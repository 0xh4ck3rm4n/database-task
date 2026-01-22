# Database Task (Normalization)

This is a lab demonstration for database normalization from unnormalized form to 3NF.

## Learning Objectives

- Understand normalization (1NF, 2NF, 3NF)
- Write DDL Commands
- Verifying with queries
- Github Documentation

## Quick Start

### 1. Clone the Repository

```
git clone git@github.com:0xh4ck3rm4n/database-task.git
cd database-task
```

### 2. Start MySQL Docker Container

```
docker run --name lab \
  -e MYSQL_ROOT_PASSWORD=lab \
  -e MYSQL_DATABASE=university \
  -d -p 3307:3306 \
  mysql:8.0
```

### 3. Execute the Complete Demo Script

```
docker exec -i lab mysql -uroot -plab uni < university.sql
```

### 4. Verifying the result

```
# Check Student table

docker exec lab mysql -uroot -plab -t uni -e "SELECT * FROM Students;"

# Check Courses table

docker exec lab mysql -uroot -plab -t uni -e "SELECT * FROM Courses;"

# List all enrollment

docker exec lab mysql -uroot -plab -t uni -e "
    SELECT
        s.Name AS Student,
        c.CourseTitle AS Course,
        e.Grade,
        c.Credits
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    JOIN Courses c ON e.CourseID = c.CourseID
    ORDER BY s.Name;"
```

## Normalization Process

### Original Unnormalized Form

```
Registration(StudentID, Name, Email, Major, Advisor, CourseID,
             CourseTitle, Credits, Grade, Building, Room)
```

**Problems**: Redundancy, update anomalies, insertion anomalies, deletion anomalies

### First Normal Form (1NF)

**All attributes are atomic**

### Second Normal Form (2NF)

**Eliminated partial dependencies by separating:**

- Student data → **Students** table
- Course data → **Courses** table
- Enrollment data → **Enrollments** table

### Third Normal Form (3NF)

**Eliminated transitive dependencies by creating:**

- **Majors** table (Major → Advisor)

## Task Structure

```
database-task/
├── images/
│   ├── 1.png
│   ├── 2.png
│   ├── 3.png
├── sql/
│   ├── university.sql          # DDL Queries
└── README.md                   # Documentation
```

## Verification and Testing

```sql
USE lab;
SHOW TABLES;
```

Expected output:
<img src="/images/1.png" width="500" height="500" />

```sql
SELECT * FROM Students;
```

Expected Output:
<img src="/images/2.png" width="500" height="500" />

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

Expected Output:
<img src="/images/3.png" width="500" height="500" />

## Testing Data Integrity

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

## Author

**Gaurav Poudel** - Student
