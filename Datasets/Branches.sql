CREATE TABLE Branches
(
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    City VARCHAR(50)
);

INSERT INTO Branches
(BranchID, BranchName, City)
VALUES
(1, 'Main Branch Karachi', 'Karachi'),
(2, 'Clifton Branch', 'Karachi'),
(3, 'Gulshan Branch', 'Karachi'),

(4, 'Main Branch Lahore', 'Lahore'),
(5, 'DHA Lahore Branch', 'Lahore'),
(6, 'Johar Town Branch', 'Lahore'),

(7, 'Blue Area Branch', 'Islamabad'),
(8, 'F-10 Branch', 'Islamabad'),
(9, 'G-11 Branch', 'Islamabad'),

(10, 'University Road Branch', 'Peshawar'),
(11, 'Hayatabad Branch', 'Peshawar'),

(12, 'Jinnah Road Branch', 'Quetta'),
(13, 'Satellite Town Branch', 'Quetta'),

(14, 'Cantt Branch Multan', 'Multan'),
(15, 'Bosan Road Branch', 'Multan'),

(16, 'Saddar Branch Rawalpindi', 'Rawalpindi'),
(17, 'Commercial Market Branch', 'Rawalpindi'),

(18, 'Clock Tower Branch', 'Faisalabad'),
(19, 'D Ground Branch', 'Faisalabad'),

(20, 'Latifabad Branch', 'Hyderabad'),
(21, 'Qasimabad Branch', 'Hyderabad'),

(22, 'Cantt Branch Sialkot', 'Sialkot'),
(23, 'Paris Road Branch', 'Sialkot'),

(24, 'Main Branch Gujranwala', 'Gujranwala'),
(25, 'Satellite Town Branch', 'Gujranwala');

SELECT * FROM Branches