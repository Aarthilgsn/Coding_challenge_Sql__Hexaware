--Coding Challenge 3_RDBMS_CrimeMangement
--Coding Challenge SQL
--Crime Management Shema DDL and DML

-- Create the Crime Management database
CREATE DATABASE crimemanagemet;
USE crimemanagement;

-- Create the Crime table
CREATE TABLE Crime (
    CrimeID INT PRIMARY KEY,
    IncidentType VARCHAR(255),
    IncidentDate DATE,
    Location VARCHAR(255),
    Description TEXT,
    Status VARCHAR(20)
);

-- Create the Victim table
CREATE TABLE Victim (
    VictimID INT PRIMARY KEY,
    CrimeID INT,
    Name VARCHAR(255),
    ContactInfo VARCHAR(255),
    Injuries VARCHAR(255),
    Age INT,
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

-- Create the Suspect table
CREATE TABLE Suspect (
    SuspectID INT PRIMARY KEY,
    CrimeID INT,
    Name VARCHAR(255),
    Description TEXT,
    CriminalHistory TEXT,
    Age INT,
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

--view the table
select * from crime;
select * from victim;
select * from suspect;

-- Insert initial data into Crime table
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');

-- Insert initial data into Victim table
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries, Age) VALUES
(1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries', 30),
(2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased', 25),
(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None', 28);

-- Insert initial data into Suspect table
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory, Age) VALUES
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions', 32),
(2, 2, 'Unknown', 'Investigation ongoing', NULL, 27),
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests', 28);

-- Insert additional data to support all queries
INSERT INTO Crime VALUES
(4, 'Robbery', '2023-09-21', '321 Maple Ave', 'Second robbery at bank', 'Open'),
(5, 'Assault', '2023-09-22', '111 Pine St', 'Physical altercation reported', 'Closed'),
(6, 'Robbery', '2023-09-25', '222 Cherry St', 'Robbery at gas station', 'Open');

INSERT INTO Victim VALUES
(4, 4, 'Mike Doe', 'mikedoe@example.com', 'None', 35),
(5, 5, 'Unknown', 'unknown@example.com', 'Injured', 40);

INSERT INTO Suspect VALUES
(4, 4, 'John Doe', 'Repeat offender', 'Robbery, Assault', 38),
(5, 5, 'Jane Smith', 'Identified by CCTV', 'None', 26),
(6, 6, 'Robber 1', 'Same suspect as before', 'Robbery record', 32);

-- View all table data
SELECT * FROM Crime;
SELECT * FROM Victim;
SELECT * FROM Suspect;

-- Query 1: Select all open incidents
SELECT * FROM Crime WHERE Status = 'Open';

-- Query 2: Total number of incidents
SELECT COUNT(*) AS Total_Incidents FROM Crime;

-- Query 3: Unique incident types
SELECT DISTINCT IncidentType FROM Crime;

-- Query 4: Incidents between 2023-09-01 and 2023-09-10
SELECT * FROM Crime WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

-- Query 5: Persons involved in incidents in descending order of age
SELECT Victim.Name, Victim.Age, Victim.ContactInfo, Crime.IncidentType
FROM Victim
JOIN Crime ON Victim.CrimeID = Crime.CrimeID
ORDER BY Victim.Age DESC;

-- Query 6: Average age of victims
SELECT AVG(Age) AS Average_Victim_Age FROM Victim;

-- Query 7: Incident types and counts for open cases
SELECT IncidentType, COUNT(*) AS IncidentCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType;

-- Query 8: Persons with names containing 'Doe'
SELECT * FROM Victim WHERE Name LIKE '%Doe%';

-- Query 9: Names of victims involved in open or closed cases
SELECT Victim.Name, Crime.Status
FROM Victim
JOIN Crime ON Victim.CrimeID = Crime.CrimeID
WHERE Crime.Status IN ('Open', 'Closed');

-- Query 10: Incident types with victims aged 30 or 35
SELECT Victim.Name, Victim.Age, Crime.IncidentType
FROM Victim
JOIN Crime ON Victim.CrimeID = Crime.CrimeID
WHERE Victim.Age IN (30, 35);

-- Query 11: Victims involved in incidents of type 'Robbery'
SELECT Victim.Name, Crime.IncidentType
FROM Victim
JOIN Crime ON Victim.CrimeID = Crime.CrimeID
WHERE Crime.IncidentType = 'Robbery';

-- Query 12: Incident types with more than one open case
SELECT IncidentType
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType
HAVING COUNT(CrimeID) > 1;

-- Query 13: Incidents with suspects who are also victims in other incidents
SELECT DISTINCT Crime.IncidentType, Suspect.Name AS SuspectName, Victim.Name AS VictimName
FROM Crime
JOIN Suspect ON Crime.CrimeID = Suspect.CrimeID
JOIN Victim ON Crime.CrimeID = Victim.CrimeID
WHERE Suspect.Name IN (SELECT Name FROM Victim);

-- Query 14: All incidents with victim and suspect details
SELECT Crime.CrimeID, Crime.IncidentType, Crime.IncidentDate, Crime.Location,
       Victim.Name AS VictimName, Victim.ContactInfo,
       Suspect.Name AS SuspectName, Suspect.Description
FROM Crime
JOIN Victim ON Crime.CrimeID = Victim.CrimeID
JOIN Suspect ON Crime.CrimeID = Suspect.CrimeID;

-- Query 15: Incidents where suspect is older than any victim
SELECT Crime.CrimeID, Crime.IncidentType, Suspect.Name AS SuspectName, Victim.Name AS VictimName
FROM Crime
JOIN Suspect ON Crime.CrimeID = Suspect.CrimeID
JOIN Victim ON Crime.CrimeID = Victim.CrimeID
WHERE Suspect.Age > Victim.Age;

-- Query 16: Suspects involved in multiple incidents
SELECT Suspect.Name
FROM Suspect
GROUP BY Suspect.Name
HAVING COUNT(DISTINCT CrimeID) > 1;

-- Query 17: Incidents with no suspects
DELETE FROM Suspect
WHERE SuspectID = 5;

SELECT Crime.CrimeID, Crime.IncidentType, Crime.IncidentDate, Crime.Location
FROM Crime
LEFT JOIN Suspect ON Crime.CrimeID = Suspect.CrimeID
WHERE Suspect.SuspectID IS NULL;

-- Query 18: Cases with at least one 'Homicide' and all others 'Robbery'
-- Most recent HOMICIDE + all ROBBERY incidents
SELECT * FROM (
    SELECT TOP 1 * 
    FROM Crime 
    WHERE IncidentType = 'Homicide' 
    ORDER BY IncidentDate DESC
) AS Homicide
UNION ALL
SELECT * FROM Crime 
WHERE IncidentType = 'Robbery';

-- Query 19: Incidents with suspect names or 'No Suspect'
SELECT c.crimeID, c.incidentType,ISNULL(s.name,'No suspect') AS suspectname
FROM crime c
LEFT JOIN suspect s ON c.crimeID=s.crimeID;

-- Query 20: Suspects in 'Robbery' or 'Assault' cases
SELECT DISTINCT Suspect.Name
FROM Suspect
JOIN Crime ON Suspect.CrimeID = Crime.CrimeID
WHERE Crime.IncidentType IN ('Robbery', 'Assault')
ORDER BY Suspect.Name;