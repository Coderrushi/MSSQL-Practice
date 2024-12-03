USE sample_db;

DECLARE @WeekDays TABLE(Number INT, Day VARCHAR(20), Name VARCHAR(30))

INSERT INTO @WeekDays
VALUES
(1, 'MON', 'MONDAY'),
(2, 'TUE', 'TUESDAY'),
(3, 'WED', 'WEDNESDAY'),
(4, 'THU', 'THURSDAY'),
(5, 'FRI', 'FRIDAY'),
(6, 'SAT', 'SATURDAY'),
(7, 'SUN', 'SUNDAY');
DELETE @WeekDays WHERE Number = 7;
UPDATE @WeekDays SET Name = 'SATURDAY is holiday' WHERE Number = 6;
SELECT * FROM @WeekDays; 

SELECT @@SERVERNAME;
