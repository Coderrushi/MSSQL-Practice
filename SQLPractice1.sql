USE demo_db;

CREATE TABLE Assignment (
	AssignId INT IDENTITY(1,1) PRIMARY KEY,
	CourseId INT NOT NULL,
	Title VARCHAR(30) NOT NULL,
	DueDate DATE NOT NULL
);
INSERT INTO Assignment (CourseId, Title, DueDate) VALUES 
(1, 'Math Assignment 1', '2024-11-20'),
(2, 'Science Project', '2024-11-25'),
(1, 'Math Assignment 2', '2024-12-01'),
(3, 'History Essay', '2024-11-30'),
(2, 'Science Lab Report', '2024-12-05');

CREATE TABLE Grades (
	GradeId INT IDENTITY(1,1) PRIMARY KEY,
	StudentId INT NOT NULL,
	AssignId INT NOT NULL,
	Score INT NOT NULL
);
INSERT INTO Grades (StudentId, AssignId, Score) VALUES 
(101, 1, 85),
(102, 2, 90),
(103, 3, 78),
(104, 4, 88),
(105, 5, 92);

CREATE TABLE Instructors (
	InstructorId INT IDENTITY(1,1) PRIMARY KEY,
	InstructorName VARCHAR(30) NOT NULL,
	CourseId INT NOT NULL,
	Email VARCHAR(30) NOT NULL
);
INSERT INTO Instructors (InstructorName, CourseId, Email) VALUES 
('John Doe', 1, 'john.doe@example.com'),
('Jane Smith', 2, 'jane.smith@university.edu'),
('Emily Johnson', 3, 'emily.johnson@example.com'),
('Michael Brown', 1, 'michael.brown@university.edu'),
('Sarah Davis', 2, 'sarah.davis@university.edu');

CREATE TABLE Attendance (
	AttendanceId INT IDENTITY(1,1) PRIMARY KEY,
	StudentId INT NOT NULL,
	AttendanceDate DATE NOT NULL,
	AttendanceStatus VARCHAR(10) NOT NULL
);
INSERT INTO Attendance (StudentId, AttendanceDate, AttendanceStatus) VALUES 
(101, '2024-11-10', 'Present'),
(102, '2024-11-10', 'Absent'),
(103, '2024-11-10', 'Present'),
(104, '2024-11-10', 'Present'),
(105, '2024-11-10', 'Absent');

--1)Retrieve all assignments with due dates in the next 7 days. 
SELECT AssignId, CourseId, Title
FROM Assignment
WHERE DueDate =
(SELECT DueDate FROM Assignment WHERE DueDate = CAST(DATEADD(DAY, 7, GETDATE()) AS DATE));

SELECT a1.AssignId, a1.CourseId, a1.Title
FROM Assignment a1
JOIN Assignment a2
ON DATEADD(DAY, 7, a2.DueDate) = a1.DueDate;

--2)Find the average score of all students on a specific assignment. 
SELECT A.Title, AVG(G.Score) AS Avg_Score_Per_Assignment
FROM Assignment A
JOIN Grades G ON A.AssignId = G.AssignId
GROUP BY A.Title;

--3)Count the total number of days each student was marked "Present".
SELECT StudentId, COUNT(AttendanceStatus) AS Student_Attendance
FROM Attendance 
WHERE AttendanceStatus ='Present'
GROUP BY StudentId;

--4)Retrieve a list of instructors who have an email address ending with "@university.edu". 
SELECT InstructorId, InstructorName, Email
FROM Instructors 
WHERE Email LIKE '%@university.edu';

--5)List all students who scored above 90 on any assignment. 
SELECT G.StudentId, A.AssignId, A.Title, G.Score
FROM Grades G
INNER JOIN Assignment A
ON G.AssignId = A.AssignId
WHERE G.Score > 90;

--6)Retrieve the names of all instructors who have not assigned a course.
SELECT InstructorId, InstructorName
FROM Instructors 
WHERE CourseId IS NULL;

--7)Find students who have more than three absences.
SELECT StudentId
FROM Attendance
WHERE AttendanceStatus = 'Absent'
GROUP BY StudentId
HAVING COUNT(*) > 3;

--8)For each assignment, find the highest score achieved by any student. 
SELECT A.Title, G.StudentId, MAX(G.Score) AS Highest_Score
FROM Assignment A
LEFT JOIN Grades G
ON A.AssignId = G.AssignId
GROUP BY A.Title, G.StudentId

--9)Retrieve all assignments that were due more than a month ago. 
SELECT AssignId, Title, DueDate
FROM Assignment
WHERE DueDate = DATEADD(DAY, -30, GETDATE());

--10)Count the total number of assignments for each course. 
SELECT CourseId, COUNT(*) AS Total_Assigns_Per_Course
FROM Assignment
GROUP BY  CourseId;

--11)Retrieve a list of instructors, sorted by name in descending order. 
SELECT InstructorId, InstructorName
FROM Instructors
ORDER BY InstructorName DESC;

--12)List all students and their highest score across all assignments.
SELECT G.StudentId, A.Title, G.Score
FROM Grades G
LEFT JOIN Assignment A
ON G.AssignId = A.AssignId;

