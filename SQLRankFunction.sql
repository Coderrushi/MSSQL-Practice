CREATE DATABASE WINDOWFUNCTIONS_db;
USE WINDOWFUNCTIONS_db;

CREATE TABLE Geek_Demo (
	Name VARCHAR(10) );
INSERT INTO Geek_Demo (Name)
VALUES ('A'), ('B'), ('B'), ('C'), ('C'),( 'D');
SELECT * FROM Geek_Demo;

--RANK() FUNCTION
SELECT Name, RANK() OVER (ORDER BY Name) AS Rank_no
FROM Geek_Demo;

--ROW_NUMBER() FUNCTION
CREATE TABLE studentsSectionWise(
studentId INT,
studentName VARCHAR(100),
sectionName VARCHAR(50),
studentMarks INT 
);
INSERT INTO studentsSectionWise
VALUES (1, 'Geek1','A',461),
(1, 'Geek2','B',401),
(1, 'Geek3','C',340),
(2, 'Geek4','A',446),
(2, 'Geek5','B',361),
(2, 'Geek6','C',495),
(3, 'Geek7','A',436),
(3, 'Geek8','B',367),
(3, 'Geek9','C',498),
(4, 'Geek10','A',206),
(4, 'Geek11','B',365),
(4, 'Geek12','C',485),
(5, 'Geek13','A',446),
(5, 'Geek14','B',368),
 (5, 'Geek15','C',295),
 (6, 'Geek16','C',495);
 SELECT * FROM studentsSectionWise;

 SELECT *, ROW_NUMBER() OVER (ORDER BY studentMarks DESC) AS rankNumber
 FROM studentsSectionWise;

 SELECT *, ROW_NUMBER() OVER (PARTITION BY sectionName ORDER BY studentMarks DESC) AS rankNumber
 FROM studentsSectionWise;

 --to get top 2 rankers from each section
 WITH cte_topTwoRankers AS
 (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY sectionName ORDER BY studentMarks DESC) AS rankNumber
	FROM studentsSectionWise
)
SELECT * 
FROM cte_topTwoRankers
WHERE rankNumber <= 2;

--DENSE_RANK() Function
SELECT Name, DENSE_RANK() OVER (ORDER BY Name DESC) AS rankName
FROM Geek_Demo;


