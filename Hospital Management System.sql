

-- Create the database
create database Hospital;

use Hospital

-- 1. Departments table (created first because other tables reference it)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(100),
    ContactNumber NVARCHAR(20)
);

-- change datatype
ALTER TABLE Departments 
ALTER COLUMN ContactNumber NVARCHAR(50) NOT NULL;
	
-- 2. Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Specialization NVARCHAR(100),
    ContactNumber NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    LicenseNumber NVARCHAR(50),
    YearsOfExperience INT
);

select *from Doctors;
-- Change ContactNumber in Doctors for international format
ALTER TABLE Doctors 
ALTER COLUMN ContactNumber NVARCHAR(30) NOT NULL;

ALTER TABLE Doctors
ADD Salary DECIMAL(10,2);

-- Update Departments to add HeadDoctor relationship
ALTER TABLE Departments
ADD HeadDoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID);

-- 3. Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Age INT,
    Gender NVARCHAR(10),
    Address NVARCHAR(200),
    BloodType NVARCHAR(10),
    RegistrationDate DATE DEFAULT GETDATE()
);

--- ADD COLUMN
ALTER TABLE Patients 
ADD ContactNumber NVARCHAR(20) NOT NULL;

-- 4. Staff table
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50),
    ContactNumber NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    ShiftTimings NVARCHAR(100),
    Salary DECIMAL(10,2)
);

-- 5. Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    AppointmentDateTime DATETIME NOT NULL,
    Status NVARCHAR(20) CHECK (Status IN ('Scheduled', 'Completed', 'Canceled')),
    ReasonForVisit NVARCHAR(200)
);

-- 6. MedicalRecords table
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    VisitDate DATE NOT NULL,
    Diagnosis NVARCHAR(500),
    TreatmentNotes NVARCHAR(MAX)
);

ALTER TABLE MedicalRecords 
ALTER COLUMN Diagnosis NVARCHAR(MAX);

-- 7. PharmacyInventory table
CREATE TABLE PharmacyInventory (
    DrugID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Manufacturer NVARCHAR(100),
    Category NVARCHAR(50),
    ExpiryDate DATE,
    StockQuantity INT NOT NULL,
    PricePerUnit DECIMAL(10,2) NOT NULL
);

-- 8. Prescriptions table
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    IssueDate DATE NOT NULL,
    ExpiryDate DATE,
    Status NVARCHAR(20) CHECK (Status IN ('Active', 'Filled', 'Expired')),
    Instructions NVARCHAR(500)
);

-- 9. PrescriptionDetails table
CREATE TABLE PrescriptionDetails (
    PrescriptionDetailID INT PRIMARY KEY IDENTITY(1,1),
    PrescriptionID INT FOREIGN KEY REFERENCES Prescriptions(PrescriptionID),
    DrugID INT FOREIGN KEY REFERENCES PharmacyInventory(DrugID),
    Dosage NVARCHAR(50) NOT NULL,
    Frequency NVARCHAR(50) NOT NULL,
    Duration NVARCHAR(50),
    SpecialInstructions NVARCHAR(200)
);

-- 10. TestExaminations table
CREATE TABLE TestExaminations (
    TestID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    TestType NVARCHAR(100) NOT NULL,
    TestDate DATETIME NOT NULL,
    Results NVARCHAR(MAX),
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Completed')),
    TechnicianID INT FOREIGN KEY REFERENCES Staff(StaffID),
    Cost DECIMAL(10,2)
);

-- 11. Rooms table
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(20) NOT NULL,
    RoomType NVARCHAR(50) CHECK (RoomType IN ('General', 'ICU', 'Private', 'Semi-Private', 'Operating', 'Emergency')),
    Status NVARCHAR(20) CHECK (Status IN ('Occupied', 'Available', 'Maintenance')),
    CurrentPatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

ALTER TABLE Rooms 
ADD RatePerDay DECIMAL(10,2);

-- 12. Payments table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(20) CHECK (PaymentMethod IN ('Cash', 'Insurance', 'Card')),
    PaymentStatus NVARCHAR(20) CHECK (PaymentStatus IN ('Paid', 'Pending', 'Failed')),
    InvoiceNumber NVARCHAR(50),
    BillingStaffID INT FOREIGN KEY REFERENCES Staff(StaffID)
);

SELECT * FROM Departments;
SELECT * FROM Doctors;
SELECT * FROM Patients;
SELECT * FROM Staff;
SELECT * FROM Appointments;
SELECT * FROM MedicalRecords;
SELECT * FROM PharmacyInventory;
SELECT * FROM Prescriptions;
SELECT * FROM PrescriptionDetails;
SELECT * FROM TestExaminations;
SELECT * FROM Rooms;
SELECT * FROM Payments;

INSERT INTO Departments (DepartmentName, Location, ContactNumber)
VALUES
('Cardiology', 'Lahore', '+92-42-111223344'),
('Neurology', 'Karachi', '+92-21-3344556677'),
('Orthopedics', 'Islamabad', '+92-51-22334455'),
('Pediatrics', 'Faisalabad', '+92-41-99887766'),
('Dermatology', 'Peshawar', '+92-91-11223344');

INSERT INTO Doctors (Name, Specialization, ContactNumber, Email, DepartmentID, LicenseNumber, YearsOfExperience)
VALUES
('Dr. Ayesha Khan', 'Cardiologist', '+92-300-1112233', 'ayesha.khan@hospital.pk', 1, 'PK-CARD-001', 12),
('Dr. Imran Ali', 'Neurologist', '+92-321-4433556', 'imran.ali@hospital.pk', 2, 'PK-NEUR-002', 9),
('Dr. Sana Malik', 'Orthopedic Surgeon', '+92-333-6677885', 'sana.malik@hospital.pk', 3, 'PK-ORTH-003', 7),
('Dr. Farhan Ahmed', 'Pediatrician', '+92-345-9988776', 'farhan.ahmed@hospital.pk', 4, 'PK-PED-004', 10),
('Dr. Hina Qureshi', 'Dermatologist', '+92-301-5544332', 'hina.qureshi@hospital.pk', 5, 'PK-DERM-005', 6);

UPDATE Departments SET HeadDoctorID = 1 WHERE DepartmentID = 1;
UPDATE Departments SET HeadDoctorID = 2 WHERE DepartmentID = 2;
UPDATE Departments SET HeadDoctorID = 3 WHERE DepartmentID = 3;
UPDATE Departments SET HeadDoctorID = 4 WHERE DepartmentID = 4;
UPDATE Departments SET HeadDoctorID = 5 WHERE DepartmentID = 5;

INSERT INTO Patients (Name, Age, Gender, Address, BloodType, ContactNumber)
VALUES
('Ali Raza', 28, 'Male', 'Model Town, Lahore', 'B+', '+92-300-9988771'),
('Zainab Fatima', 34, 'Female', 'Gulshan Iqbal, Karachi', 'O-', '+92-321-8877665'),
('Usman Tariq', 19, 'Male', 'G-11, Islamabad', 'A+', '+92-333-7788990'),
('Hira Naveed', 25, 'Female', 'People’s Colony, Faisalabad', 'AB+', '+92-345-6677889'),
('Bilal Shah', 40, 'Male', 'Cantt, Peshawar', 'B-', '+92-301-5566778');

INSERT INTO Staff (Name, Role, ContactNumber, Email, DepartmentID, ShiftTimings, Salary)
VALUES
('ayesha', 'Nurse', '+92-300-1122334', 'ayesha.rauf@hospital.pk', 1, '8AM-4PM', 25000.00),
('Samina Yasir', 'Receptionist', '+92-321-4433556', 'samina.yasir@hospital.pk', 2, '9AM-5PM', 40000.00),
('hamza', 'Lab Technician', '+92-333-9988772', 'hamza.iqbal@hospital.pk', 3, '10AM-6PM', 45000.00),
('Maria Shafiq', 'Pharmacist', '+92-345-5566998', 'maria.shafiq@hospital.pk', 4, '8AM-4PM', 48000.00),
('Tariq Jameel', 'Security Guard', '+92-301-4455883', 'tariq.jameel@hospital.pk', 5, '6AM-2PM', 30000.00);

update staff
set salary =23000
where Name='hamza';

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDateTime, Status, ReasonForVisit)
VALUES
(1, 1, '2025-04-15 10:00:00', 'Scheduled', 'Chest pain and shortness of breath'),
(2, 2, '2025-04-16 11:30:00', 'Completed', 'Recurring headaches'),
(3, 3, '2025-04-17 09:00:00', 'Canceled', 'Knee joint pain'),
(4, 4, '2025-04-18 14:00:00', 'Scheduled', 'Fever and cough in child'),
(5, 5, '2025-04-19 12:00:00', 'Scheduled', 'Skin rash and irritation');

INSERT INTO MedicalRecords (PatientID, DoctorID, VisitDate, Diagnosis, TreatmentNotes)
VALUES
(2, 2, '2025-04-16', 'Migraine', 'Prescribed pain relievers and lifestyle changes'),
(1, 1, '2025-04-10', 'Angina', 'Advised ECG and started beta-blockers'),
(4, 4, '2025-03-30', 'Viral Fever', 'Paracetamol and hydration therapy'),
(3, 3, '2025-04-01', 'Meniscus Tear', 'Recommended MRI and physiotherapy'),
(5, 5, '2025-04-03', 'Allergic Dermatitis', 'Prescribed antihistamines and cream');

INSERT INTO PharmacyInventory (Name, Manufacturer, Category, ExpiryDate, StockQuantity, PricePerUnit)
VALUES
('Panadol', 'GSK Pakistan', 'Analgesic', '2026-12-31', 200, 5.00),
('Augmentin 625mg', 'GSK Pakistan', 'Antibiotic', '2025-08-30', 150, 25.00),
('Ventolin Inhaler', 'GSK Pakistan', 'Respiratory', '2026-06-15', 100, 300.00),
('Betnovate Cream', 'GSK Pakistan', 'Dermatological', '2025-10-01', 75, 70.00),
('Brufen 400mg', 'Abbott Pakistan', 'Painkiller', '2027-01-01', 180, 8.00);

INSERT INTO Prescriptions (PatientID, DoctorID, IssueDate, ExpiryDate, Status, Instructions)
VALUES
(2, 2, '2025-04-16', '2025-04-30', 'Active', 'Take after meals'),
(1, 1, '2025-04-10', '2025-04-25', 'Filled', 'Avoid strenuous activities'),
(4, 4, '2025-03-30', '2025-04-15', 'Expired', 'Plenty of fluids'),
(3, 3, '2025-04-01', '2025-04-20', 'Active', 'Apply ice and rest'),
(5, 5, '2025-04-03', '2025-04-17', 'Filled', 'Apply twice daily');

INSERT INTO PrescriptionDetails (PrescriptionID, DrugID, Dosage, Frequency, Duration, SpecialInstructions)
VALUES
(1, 1, '500mg', 'Twice a day', '5 days', 'With water'),
(2, 2, '625mg', 'Thrice a day', '7 days', 'After meals'),
(3, 5, '400mg', 'Twice a day', '3 days', 'Take rest'),
(4, 4, 'Apply small amount', 'Twice daily', '2 weeks', 'Do not cover with bandage'),
(5, 3, '2 puffs', 'As needed', '1 month', 'Shake well before use');

INSERT INTO TestExaminations (PatientID, DoctorID, TestType, TestDate, Results, Status, TechnicianID, Cost)
VALUES
(1, 1, 'ECG', '2025-04-11 09:30:00', 'Mild abnormalities', 'Completed', 3, 1500.00),
(2, 2, 'CT Scan', '2025-04-16 13:00:00', 'Normal', 'Completed', 3, 4500.00),
(3, 3, 'MRI Knee', '2025-04-02 10:00:00', 'Tear in lateral meniscus', 'Completed', 3, 7000.00),
(4, 4, 'CBC', '2025-04-01 08:00:00', 'Elevated WBC count', 'Completed', 3, 1200.00),
(5, 5, 'Skin biopsy', '2025-04-04 14:00:00', 'Mild inflammation', 'Pending', 3, 3500.00);

INSERT INTO Rooms (RoomNumber, RoomType, Status, CurrentPatientID, DepartmentID, RatePerDay)
VALUES
('101', 'General', 'Occupied', 1, 1, 2500.00),
('102', 'Private', 'Available', NULL, 2, 6000.00),
('103', 'ICU', 'Occupied', 2, 1, 12000.00),
('104', 'Semi-Private', 'Occupied', 4, 4, 4000.00),
('105', 'Operating', 'Maintenance', NULL, 3, 15000.00);

INSERT INTO Payments (PatientID, Amount, PaymentMethod, PaymentStatus, InvoiceNumber, BillingStaffID)
VALUES
(1, 2500.00, 'Cash', 'Paid', 'INV-001', 1),
(2, 4500.00, 'Card', 'Paid', 'INV-002', 2),
(3, 7000.00, 'Insurance', 'Pending', 'INV-003', 2),
(4, 1200.00, 'Cash', 'Paid', 'INV-004', 3),
(5, 3500.00, 'Card', 'Failed', 'INV-005', 4);

---- Select a doctor that salary is greather than 1 lac
select * from Doctors

  select d.Name, d.DepartmentID, d.YearsOfExperience,d.Salary 
  from Doctors as d
  where d.Salary>=100000;


----------------------- Joins -------------------------
--List all active prescriptions with drug details (combine Prescriptions and PrescriptionDetails) using inner join
--Tables: Prescriptions, PrescriptionDetails
 
SELECT  
    p.PrescriptionID,  
    pd.DrugID,  
    pd.Dosage,  
    pd.Duration  
FROM  
    Prescriptions p  
INNER JOIN  
    PrescriptionDetails pd ON p.PrescriptionID = pd.PrescriptionID  
WHERE  
    p.Status = 'Active';  

--	Scenario: List all patients and their appointments (including patients with no appointments). using left joins 
--Tables: Patients, Appointments

SELECT  
    p.Name AS PatientName,  
    a.AppointmentDateTime,  
    a.Status  
FROM  
    Patients p  
LEFT JOIN  
    Appointments a ON p.PatientID = a.PatientID;  

--Scenario: List all departments and their staff (including departments with no staff).using right join
--Tables: Departments, Staff 
--- which department who staff exist ?

SELECT  
    d.DepartmentName,  
    s.Name AS StaffName  
FROM  
    Staff s  
RIGHT JOIN  
    Departments d ON s.DepartmentID = d.DepartmentID;  

select * from Departments;
select * from Staff;

--Scenario: List all prescriptions and their details (including unmatched records). using full join 
--Tables: Prescriptions, PrescriptionDetails

SELECT  
    p.PrescriptionID,
	p.ExpiryDate,
	p.Instructions,
    pd.DrugID  
FROM  
    Prescriptions p  
inner JOIN  
    PrescriptionDetails pd ON p.PrescriptionID = pd.PrescriptionID;
	
select * from Prescriptions;
select * from PrescriptionDetails;

--Scenario: Calculate total payments grouped by method (e.g., Cash, Insurance). uisng aggrgae functions 
--Tables: Payments

SELECT  
    PaymentMethod,  
    SUM(Amount) AS TotalRevenue  
FROM  
    Payments  
GROUP BY  
    PaymentMethod;  

	select * from Payments;
--	Scenario: Find average salaries for nurses, technicians, etc. aggrgate functions 
--Tables: Staff
--
SELECT  
   s.Role, 
   AVG(Salary) AS AvgSalary  
FROM  
    Staff  as s
GROUP BY  
    Role;  

	select * from Staff
--	Scenario: Identify how many blood type of same patients using aggegare functions 
--Tables: Patients

SELECT  
    BloodType,  
    COUNT(PatientID) AS TotalPatients  
FROM  
    Patients  
GROUP BY  
    BloodType;  

	select * from Patients;
	--------------- Nested Queries -----------------
--Doctors with No Canceled Appointments 
--Tables: Doctors, Appointments

--scenerio--> Doctor Names that appointment not canceled  
SELECT  
    Name  
FROM  
    Doctors  
WHERE  
    DoctorID NOT IN (  
        SELECT DoctorID  
        FROM Appointments  
        WHERE Status = 'Canceled'  
    );  

	select * from Doctors;
	select * from Appointments;

--scenerio --> Patients that room rate is more than Average   
--Tables: Patients, Rooms

SELECT  
	p.PatientID,
	p.Name, 
    r.RatePerDay,
	r.RoomType
FROM  
    Patients p  
INNER JOIN  
    Rooms r ON p.PatientID = r.CurrentPatientID  
WHERE  
    r.RatePerDay > (SELECT AVG(RatePerDay) FROM Rooms);  

--Drugs Prescribed More Than Average or exactly one  using nested quries
--Tables: PrescriptionDetails, PharmacyInventory currentlty no more than average 

--scenerio-->name and count (total ) of drugs Greater than or equal to Average of count how many total number of times times drugs used in a prescription of all drugs 
select * from PrescriptionDetails;
select * from PharmacyInventory;

SELECT  
    pi.[Name] AS Drug,  
    COUNT(pd.DrugID) AS TotalPrescriptions  
FROM  
    PrescriptionDetails pd  
INNER JOIN  
    PharmacyInventory pi ON pd.DrugID = pi.DrugID  
GROUP BY  
    pi.[Name]  
HAVING  
    COUNT(pd.DrugID) >= (  
        SELECT AVG(PrescriptionCount)  
        FROM (  
            SELECT COUNT(DrugID) AS PrescriptionCount  
            FROM PrescriptionDetails  
            GROUP BY DrugID  
        ) AS SubQuery  
    );

	select * from PrescriptionDetails;
	--------------- Real World Scenerios -------------
--	Emergency Room Availability Check   
--Tables: Rooms

INSERT INTO Rooms (RoomNumber, RoomType, Status, DepartmentID, RatePerDay)
VALUES ('106', 'Emergency', 'Available', 5, 8000.00);

SELECT  
    RoomNumber,  
    RoomType  
FROM  
    Rooms  
WHERE  
    RoomType = 'Emergency' AND Status = 'Available';  

--expired date of Drug Alert
--Tables: PharmacyInventory

INSERT INTO PharmacyInventory (Name, StockQuantity, PricePerUnit, ExpiryDate)
VALUES ('Expired Drug', 50, 2.99, '2023-01-01');

SELECT  
    Name,  
    ExpiryDate  
FROM  
    PharmacyInventory  
WHERE  
    ExpiryDate < GETDATE();  


--	Pending Lab Tests with Technician Details
--Tables: TestExaminations, Staff, Patients

--> scenerio test type and patient Name And Teechnician Name that Status is pendind for tests

SELECT  
    t.TestType,  
    p.Name AS Patient,  
    s.Name AS Technician  
FROM  
    TestExaminations t  
INNER JOIN  
    Patients p ON t.PatientID = p.PatientID  
LEFT JOIN  
    Staff s ON t.TechnicianID = s.StaffID  
WHERE  
    t.Status = 'Pending';  

	select * from TestExaminations;
	select * from Patients;
	select * from Staff;

SELECT  
    t.TestType, 
	(select p.Name from Patients as p where p.PatientID=t.PatientID) as PatientName ,
	(select s.Name from Staff as s where s.StaffID=t.TechnicianID) as Technician  
FROM  
    TestExaminations t  
WHERE  
t.Status='Pending';

	------------- SET Operations Queries 

--1)Find Names of People Who are either Doctors or Staff Members
SELECT Name, ContactNumber
FROM Doctors
UNION
SELECT Name, ContactNumber
FROM Staff;

--2)Find Names who are both Doctors AND Staff 
SELECT Name
FROM Doctors
intersect
SELECT Name
FROM Staff;

insert into Staff(Name,ContactNumber,Role)
values ('Dr. Farhan Ahmed',+92-345-9988776,'Doctor');

select * from Doctors;
select * from Staff;

--3) Find All Contact Numbers (Doctors, Patients, Staff) (UNION ALL)
SELECT ContactNumber
FROM Doctors

UNION ALL

SELECT ContactNumber
FROM Patients

UNION ALL

SELECT ContactNumber
FROM Staff;

--4)Find Rooms Assigned to Patients but Not Under Maintenance
SELECT RoomID
FROM Rooms
WHERE Status = 'Occupied'

INTERSECT

SELECT RoomID
FROM Rooms
WHERE Status != 'Maintenance';

	------------------------  Views ----------------------------

	-- View: Basic Doctor Info
CREATE VIEW vw_DoctorInfo AS
SELECT DoctorID, Name, Specialization, Email, DepartmentID
FROM Doctors;

select * from vw_DoctorInfo;
select * from Doctors;

-- View: Patient Upcoming Appointments

ALTER VIEW vw_UpcomingAppointments AS
SELECT a.AppointmentID, p.Name AS PatientName, d.Name AS DoctorName, a.AppointmentDateTime, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE a.AppointmentDateTime > GETDATE();

select * from vw_UpcomingAppointments;

SELECT * FROM Patients;
SELECT * FROM Doctors;
SELECT * FROM Appointments;

-- View: Patient Contact Details
CREATE VIEW vw_PatientContacts AS
SELECT PatientID, Name, ContactNumber, Address
FROM Patients;

select * from Patients;
select * from vw_PatientContacts;

-- View allowing updates on patient contact info
CREATE VIEW vw_EditablePatientContact
AS
SELECT PatientID, Name, ContactNumber
FROM Patients;

UPDATE vw_EditablePatientContact
SET ContactNumber = '123456789012'
WHERE PatientID = 1;

select * from vw_EditablePatientContact;
select * from Patients;

-- scenerio <--- View How many Times Patient visit in Doctors 

CREATE VIEW vw_PatientVisitFrequency AS
SELECT 
    p.PatientID,
    p.Name,
    COUNT(m.RecordID) AS VisitCount
FROM Patients p
JOIN MedicalRecords m ON p.PatientID = m.PatientID
GROUP BY p.PatientID, p.Name

select * from vw_PatientVisitFrequency;
select * from MedicalRecords;

select v.Name, v.PatientID , max(VisitCount) from vw_PatientVisitFrequency  as v
where VisitCount <
(select max(VisitCount) from vw_PatientVisitFrequency)
group by  v.Name, v.PatientID;

---Example to insert data and check 
insert into MedicalRecords(PatientID,DoctorID,VisitDate,Diagnosis,TreatmentNotes)
values (1,3,getdate(),'Flue','Taking Calpol in two times')

--scenerio <--- Patient Name And Doctor that is in Appointment 

create VIEW vw_PatientAppointments AS
SELECT 
    a.AppointmentID,
    p.Name AS PatientName,
    d.Name AS DoctorName,
    a.AppointmentDateTime,
    a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID

select * from vw_PatientAppointments;
select * from Appointments;

--Prescription summary
creat VIEW vw_PrescriptionSummary AS
SELECT 
    pr.PrescriptionID,
    p.Name AS PatientName,
    d.Name AS DoctorName,
    pr.IssueDate,
	pr.Instructions
FROM Prescriptions pr
JOIN Patients p ON pr.PatientID = p.PatientID
JOIN Doctors d ON pr.DoctorID = d.DoctorID;

select * from vw_PrescriptionSummary;
select * from Prescriptions;

-------------------------------------------------
SELECT * FROM vw_DoctorInfo;
SELECT * FROM vw_UpcomingAppointments;
SELECT * FROM vw_PatientContacts;
SELECT * FROM vw_EditablePatientContact;
SELECT * FROM vw_PatientVisitFrequency;
select * from vw_PatientAppointments;
SELECT * FROM vw_PrescriptionSummary;


-------------------- Triggers --------------------------
--Update Room Status on Patient Assignment

CREATE TRIGGER trg_UpdateRoomStatusOnPatientAssign
ON Rooms
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Rooms
    SET Status = 'Occupied'
    WHERE CurrentPatientID IS NOT NULL
    AND RoomID IN (SELECT RoomID FROM inserted);
END;

update Rooms
set CurrentPatientID=6
where RatePerDay=6000;

-- Insert a patient
INSERT INTO Patients (Name, Age, Gender, Address, BloodType, ContactNumber)
VALUES ('Ali Khan', 35, 'Male', 'Lahore', 'O+', '03001234567');

-- Insert a department
INSERT INTO Departments (DepartmentName, Location, ContactNumber)
VALUES ('General Ward', 'Block A', '042-9999999');

-- Insert a room and assign patient
INSERT INTO Rooms (RoomNumber, RoomType, Status, CurrentPatientID, DepartmentID, RatePerDay)
VALUES ('101', 'General', 'Available', 1, 1, 2000);

---- ? Now check if status became 'Occupied'
SELECT * FROM Rooms;
select * from Patients;

-----------Trigger: Auto-Update Patient Room Status to Available on Discharge

CREATE TRIGGER trg_UpdateRoomOnDischarge
ON Rooms
AFTER UPDATE
AS
BEGIN	
    UPDATE Rooms
    SET Status = 'Available'
    WHERE CurrentPatientID IS NULL
    AND RoomID IN (SELECT RoomID FROM inserted);
END;

-- Discharge patient by setting CurrentPatientID to NULL
UPDATE Rooms
SET CurrentPatientID = NULL
WHERE RoomID = 1;

-- ? Check if room status updated to Available
SELECT * FROM Rooms;

-------------Automatically Mark Appointment as Completed After Visit
CREATE TRIGGER trg_MarkAppointmentCompleted
ON MedicalRecords
AFTER INSERT
AS
BEGIN
    UPDATE Appointments
    SET Status = 'Completed'
    WHERE PatientID IN (SELECT PatientID FROM inserted) AND DoctorID IN (SELECT DoctorID FROM inserted) AND Status = 'Scheduled';
END;

---Both are equal 
CREATE OR ALTER TRIGGER trg_MarkAppointmentCompleted
ON MedicalRecords
AFTER INSERT
AS
BEGIN
    UPDATE Appointments
    SET Status = 'Completed'
    FROM Appointments a
    INNER JOIN inserted i
        ON a.PatientID = i.PatientID  AND a.DoctorID = i.DoctorID AND a.Status = 'Scheduled';
END;

SELECT * FROM Patients;
SELECT * FROM Doctors
SELECT * FROM Appointments;
SELECT * FROM MedicalRecords;

-- Add a medical record (this should complete the appointment)

-- Create an appointment
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDateTime, Status, ReasonForVisit)
VALUES (1, 1, GETDATE(), 'Scheduled', 'Checkup');

INSERT INTO MedicalRecords (PatientID, DoctorID, VisitDate, Diagnosis, TreatmentNotes)
VALUES (1, 1, GETDATE(), 'Flu', 'Prescribed rest and medication.');

--new insert query 
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDateTime, Status, ReasonForVisit)
VALUES (7, 3, GETDATE(), 'Scheduled', 'Checkup');

INSERT INTO MedicalRecords (PatientID, DoctorID, VisitDate, Diagnosis, TreatmentNotes)
VALUES (7, 3, '2025-04-28', 'Stomach Infection', 'Prescribed antibiotics and rest');

delete Appointments
where PatientID=7;

delete MedicalRecords
where PatientID=1;

--  Check if appointment was marked completed

SELECT * FROM Appointments WHERE PatientID = 1 AND DoctorID = 1;

--------------------------------------Reduce Drug Stock on Prescription
CREATE TRIGGER trg_UpdateDrugStockOnPrescription
ON PrescriptionDetails
AFTER INSERT
AS
BEGIN
    UPDATE PharmacyInventory
    SET StockQuantity = StockQuantity - 1
    WHERE DrugID IN (SELECT DrugID FROM inserted);
END;

INSERT INTO PrescriptionDetails (PrescriptionID, DrugID, Dosage, Frequency)
VALUES (1, 2, '500mg', 'Twice a day');

select * from PrescriptionDetails;
select * from PharmacyInventory;

---------- Doctor Salary Was Updated
alter TRIGGER trg_UpdateDoctorSalary
ON Doctors
AFTER UPDATE
AS
BEGIN
    SELECT 'Doctor salary was updated.'
    FROM INSERTED i
    JOIN DELETED d ON i.DoctorID = d.DoctorID
    WHERE i.Salary <> d.Salary;
END;

select * from Doctors;

update Doctors
set Salary = 50000
where DoctorID=3;

UPDATE Doctors
SET Salary = Salary + 5000
WHERE Specialization = 'Cardiology';


-------Create the audit table for trigger fire :
CREATE TABLE PatientAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    PatientID INT,
    Name NVARCHAR(100),
    Age INT,
    Gender NVARCHAR(10),
    ActionType NVARCHAR(20),
    DeletedDate DATETIME DEFAULT GETDATE()
);

-------------Audit Trigger for Deleted Patients
CREATE TRIGGER trg_PatientDeleteAudit
ON Patients
AFTER DELETE
AS
BEGIN
    INSERT INTO PatientAudit (PatientID, Name, Age, Gender, ActionType)
    SELECT PatientID, Name, Age, Gender, 'Deleted'
    FROM deleted;
END;

 
-- Delete one to activate the trigger
DELETE FROM Appointments WHERE PatientID = (SELECT PatientID FROM Patients WHERE Name = 'Ali Raza');

DELETE FROM Patients WHERE Name = 'Ali Raza';

select * from Patients;
SELECT * FROM PatientAudit;
select * from Appointments;

-----------------List all triggers in the current database
SELECT 
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    type_desc AS TriggerType,
    create_date,
    modify_date
FROM sys.triggers;

-------------- Normalization ------------------------ 

----------------------UNNORMALIZED TABLE (Bad Design) -----------------
CREATE TABLE Doctors_Unnormalized (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Specializations NVARCHAR(200), -- multiple specializations in a single field
    ContactNumbers NVARCHAR(200),   -- multiple contact numbers in a single field
    DepartmentName NVARCHAR(100),
    LicenseNumbers NVARCHAR(200),
    YearsOfExperience INT,
    Salary DECIMAL(10,2)
);

-- Example Insert
INSERT INTO Doctors_Unnormalized (Name, Specializations, ContactNumbers, DepartmentName, LicenseNumbers, YearsOfExperience, Salary)
VALUES 
('Dr. Ahsan Khan', 'Cardiology, Internal Medicine', '03001234567,0423456789', 'Cardiology', 'LIC123,LIC456', 10, 200000),
('Dr. Fatima Raza', 'Dermatology', '03007654321', 'Dermatology', 'LIC789', 7, 180000);

-------------------- FIRST NORMAL FORM (1NF) ------------------
CREATE TABLE Doctors_1NF (
    DoctorID INT,
    Name NVARCHAR(100) NOT NULL,
    Specialization NVARCHAR(100),
    ContactNumber NVARCHAR(30),
    DepartmentName NVARCHAR(100),
    LicenseNumber NVARCHAR(50),
    YearsOfExperience INT,
    Salary DECIMAL(10,2)
);

-- Example Insert
INSERT INTO Doctors_1NF (DoctorID, Name, Specialization, ContactNumber, DepartmentName, LicenseNumber, YearsOfExperience, Salary)
VALUES 
(1, 'Dr. Ahsan Khan', 'Cardiology', '03001234567', 'Cardiology', 'LIC123', 10, 200000),
(1, 'Dr. Ahsan Khan', 'Internal Medicine', '0423456789', 'Cardiology', 'LIC456', 10, 200000),
(2, 'Dr. Fatima Raza', 'Dermatology', '03007654321', 'Dermatology', 'LIC789', 7, 180000);


----------------- SECOND NORMAL FORM (2NF) --------------------
---Main doctor Table
--- a ---
CREATE TABLE Doctors_2NF (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    DepartmentName NVARCHAR(100),
    YearsOfExperience INT,
    Salary DECIMAL(10,2)
);

-- Example Insert
INSERT INTO Doctors_2NF (Name, DepartmentName, YearsOfExperience, Salary)
VALUES 
('Dr. Ahsan Khan', 'Cardiology', 10, 200000),
('Dr. Fatima Raza', 'Dermatology', 7, 180000);

----- b ---
CREATE TABLE DoctorSpecializations (
    SpecializationID INT PRIMARY KEY IDENTITY(1,1),
    DoctorID INT FOREIGN KEY REFERENCES Doctors_2NF(DoctorID),
    Specialization NVARCHAR(100) NOT NULL
);

-- Example Insert
INSERT INTO DoctorSpecializations (DoctorID, Specialization)
VALUES 
(1, 'Cardiology'),
(1, 'Internal Medicine'),
(2, 'Dermatology');

--- c----
CREATE TABLE DoctorContactNumbers (
    ContactID INT PRIMARY KEY IDENTITY(1,1),
    DoctorID INT FOREIGN KEY REFERENCES Doctors_2NF(DoctorID),
    ContactNumber NVARCHAR(30) NOT NULL
);

-- Example Insert
INSERT INTO DoctorContactNumbers (DoctorID, ContactNumber)
VALUES 
(1, '03001234567'),
(1, '0423456789'),
(2, '03007654321');


----- THIRD NORMAL FORM (3NF)----------------
CREATE TABLE Departments_3NF (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL
);

-- Example Insert
INSERT INTO Departments_3NF (DepartmentName)
VALUES 
('Cardiology'),
('Dermatology');

-- Modify Doctors table to reference DepartmentID:
CREATE TABLE Doctors_3NF (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments_3NF(DepartmentID),
    YearsOfExperience INT,
    Salary DECIMAL(10,2)
);

-- Example Insert
INSERT INTO Doctors_3NF (Name, DepartmentID, YearsOfExperience, Salary)
VALUES 
('Dr. Ahsan Khan', 1, 10, 200000),
('Dr. Fatima Raza', 2, 7, 180000);

SELECT * FROM Doctors_Unnormalized;

SELECT * FROM Doctors_1NF;

SELECT * FROM Doctors_2NF;

SELECT * FROM DoctorSpecializations;

SELECT * FROM DoctorContactNumbers;

SELECT * FROM Departments_3NF;

SELECT * FROM Doctors_3NF;

SELECT * FROM DoctorSpecializations;

SELECT * FROM DoctorContactNumbers;