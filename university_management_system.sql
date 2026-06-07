-- DROP TABLES

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS students;

--------------------------------------------------
-- STUDENTS TABLE
--------------------------------------------------

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    department VARCHAR(100),
    semester INT
);

--------------------------------------------------
-- PROFESSORS TABLE
--------------------------------------------------

CREATE TABLE professors (
    professor_id INT PRIMARY KEY,
    professor_name VARCHAR(100),
    department VARCHAR(100)
);

--------------------------------------------------
-- COURSES TABLE
--------------------------------------------------

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT,
    professor_id INT,
    FOREIGN KEY (professor_id)
    REFERENCES professors(professor_id)
);

--------------------------------------------------
-- ENROLLMENTS TABLE
--------------------------------------------------

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade DECIMAL(4,2),

    FOREIGN KEY (student_id)
    REFERENCES students(student_id),

    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
);

--------------------------------------------------
-- INSERT STUDENTS
--------------------------------------------------

INSERT INTO students VALUES
(1,'Aarav Sharma','Computer Science',5),
(2,'Priya Das','Computer Science',4),
(3,'Rahul Singh','Electronics',6),
(4,'Sneha Roy','Mathematics',3),
(5,'Ananya Gupta','Computer Science',5);

--------------------------------------------------
-- INSERT PROFESSORS
--------------------------------------------------

INSERT INTO professors VALUES
(101,'Dr. Kumar','Computer Science'),
(102,'Dr. Sen','Electronics'),
(103,'Dr. Patel','Mathematics');

--------------------------------------------------
-- INSERT COURSES
--------------------------------------------------

INSERT INTO courses VALUES
(201,'Database Systems',4,101),
(202,'Data Structures',4,101),
(203,'Digital Electronics',3,102),
(204,'Linear Algebra',4,103);

--------------------------------------------------
-- INSERT ENROLLMENTS
--------------------------------------------------

INSERT INTO enrollments VALUES
(1,1,201,8.50),
(2,1,202,9.10),
(3,2,201,8.00),
(4,2,202,8.70),
(5,3,203,7.90),
(6,4,204,9.20),
(7,5,201,8.80),
(8,5,202,9.00);

--------------------------------------------------
-- ANALYSIS QUERIES
--------------------------------------------------

-- View Students

SELECT * FROM students;

-- View Courses

SELECT * FROM courses;

-- Total Students

SELECT COUNT(*) AS total_students
FROM students;

-- Students By Department

SELECT
    department,
    COUNT(*) AS total_students
FROM students
GROUP BY department
ORDER BY total_students DESC;

-- Average Grade By Course

SELECT
    c.course_name,
    ROUND(AVG(e.grade),2) AS avg_grade
FROM enrollments e
JOIN courses c
ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY avg_grade DESC;

-- Top Performing Students

SELECT
    s.student_name,
    ROUND(AVG(e.grade),2) AS average_grade
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_name
ORDER BY average_grade DESC;

-- Courses Taught By Each Professor

SELECT
    p.professor_name,
    COUNT(c.course_id) AS total_courses
FROM professors p
LEFT JOIN courses c
ON p.professor_id = c.professor_id
GROUP BY p.professor_name;

-- Student Ranking

SELECT
    s.student_name,
    ROUND(AVG(e.grade),2) AS average_grade,
    RANK() OVER(
        ORDER BY AVG(e.grade) DESC
    ) AS student_rank
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_name;

-- Students Above Average Grade

SELECT
    student_name
FROM students
WHERE student_id IN
(
    SELECT student_id
    FROM enrollments
    GROUP BY student_id
    HAVING AVG(grade) >
    (
        SELECT AVG(grade)
        FROM enrollments
    )
);

-- Create View

CREATE OR REPLACE VIEW top_students AS
SELECT
    s.student_name,
    ROUND(AVG(e.grade),2) AS average_grade
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_name;

SELECT * FROM top_students;