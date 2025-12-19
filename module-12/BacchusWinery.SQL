-- Setting up BacchusWinery Database Schema --
USE BacchusWinery;

# Setting up database user

DROP USER IF EXISTS 'winery_user'@'localhost';
CREATE USER 'winery_user'@'localhost' IDENTIFIED BY 'grapes';
GRANT ALL PRIVILEGES ON BacchusWinery.* TO 'winery_user'@'localhost';


# Dropping Existing Tables

DROP TABLE IF EXISTS ProductOrderLines;
DROP TABLE IF EXISTS ProductOrders;
DROP TABLE IF EXISTS SupplyOrderLines;
DROP TABLE IF EXISTS Supplies;
DROP TABLE IF EXISTS SupplyOrders;
DROP TABLE IF EXISTS TimecardLines;
DROP TABLE IF EXISTS Distributors;
DROP TABLE IF EXISTS Wines;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Suppliers;

# Creating New Tables

#Core Entity Tables 
CREATE TABLE Suppliers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE Employees (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE Distributors (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE Wines (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    VintageYear INT NOT NULL CHECK(VintageYear >= 1800),
    Available INT NOT NULL CHECK(Available >= 0)
);

#----------------------------------------------------------------------

# Tables with Foreign Keys
CREATE TABLE TimecardLines (
    EmployeeId INT NOT NULL,
    DateWorked DATE NOT NULL,
    HoursWorked DECIMAL(4, 2) NOT NULL CHECK (HoursWorked > 0 AND HoursWorked <= 24),
    PRIMARY KEY (EmployeeId, DateWorked),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)
);

CREATE TABLE Supplies (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    PreferredSupplier INT NOT NULL,
    FOREIGN KEY (PreferredSupplier) REFERENCES Suppliers(Id)
);

CREATE TABLE SupplyOrders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SupplierId INT NOT NULL,
    ExpectedDate DATE NOT NULL,
    DeliveredDate DATE,
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(Id)
);

CREATE TABLE ProductOrders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    DistributorId INT NOT NULL,
    DatePlaced DATE NOT NULL,
    Carrier VARCHAR(100),
    TrackingNumber VARCHAR(255),
    FOREIGN KEY (DistributorId) REFERENCES Distributors(Id)
);

#----------------------------------------------------------------------

#Junction/Line-Item Tables 
CREATE TABLE SupplyOrderLines (
    OrderId INT NOT NULL,
    SupplyId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (OrderId, SupplyId),
    FOREIGN KEY (OrderId) REFERENCES SupplyOrders(Id),
    FOREIGN KEY (SupplyId) REFERENCES Supplies(Id)
);

CREATE TABLE ProductOrderLines (
    OrderId INT NOT NULL,
    WineId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),

    PRIMARY KEY (OrderId, WineId),
    FOREIGN KEY (OrderId) REFERENCES ProductOrders(Id),
    FOREIGN KEY (WineId) REFERENCES Wines(Id)
);

#----------------------------------------------------------------------

# data insertion scripts

# Inserting Initial Data into Suppliers Table
INSERT INTO Suppliers (Id, Name) VALUES 
(101,'Bottle & Cork Co.'),
(102, 'Label & Box Ltd.'),
(103, 'Vats & Tubing Inc.');

# Inserting Initial Data into Employees Table
INSERT INTO Employees (Id, Name) VALUES
(1, 'David Bacchus'),
(2, 'Stan Bacchus'),
(3, 'Janet Collins'),
(4, 'Roz Murphy'),
(5, 'Bob Ulrich'),
(6, 'Henry Doyle'),
(7, 'Maria Costanza');

# Inserting Initial Data into Distributors Table
INSERT INTO Distributors (Id, Name) VALUES
(301, "Southern Glazer’s Wine & Spirits"),
(302, 'Republic National Distributing Company'),
(303, 'Breakthru Beverage Group'),
(304, 'Winebow'),
(305, 'Johnson Brothers'),
(306, 'Young’s Market Company');

# Inserting Initial Data into Wines Table
INSERT INTO Wines (Id, Name, VintageYear, Available) VALUES
(401, 'Merlot', 2000, 300),
(402, 'Cabernet', 2000, 250),
(403, 'Chablis', 2000, 180),
(404, 'Chardonnay', 2000, 220);

# Inserting Initial Data into TimeCardLines Table
INSERT INTO TimecardLines (EmployeeId, DateWorked, HoursWorked) VALUES
    -- Q4 2024
    (1, '2024-10-04', 8.0),
    (1, '2024-10-05', 9.0),
    (1, '2024-10-06',15.0),
    (2, '2024-10-06', 7.5),
    (2, '2024-10-07', 7.0),
    (2, '2024-10-08',12.0),
    (3, '2024-10-05', 6.0),
    (3, '2024-10-06',15.0),
    (3, '2024-10-07',10.0),
    (4, '2024-10-04', 5.0),
    (4, '2024-10-05',10.0),
    (4, '2024-10-06',15.0),
    (5, '2024-10-04', 9.0),
    (5, '2024-10-05',10.0),
    (5, '2024-10-06', 9.0),

    -- Q1 2025
    (1, '2025-02-18', 7.5),
    (1, '2025-02-19', 7.0),
    (2, '2025-02-18', 8.0),
    (2, '2025-02-19',12.0),
    (3, '2025-02-19', 8.5),
    (3, '2025-02-20',12.0),
    (4, '2025-02-19', 7.0),
    (4, '2025-02-20',15.0),
    (5, '2025-02-20', 6.0),
    (5, '2025-02-21', 7.0),
    (6, '2025-02-20', 9.0),
    (6, '2025-02-21', 7.0),
    (7, '2025-02-21', 8.2),
    (7, '2025-02-22',11.0),

    -- Q2 2025
    (1, '2025-05-18', 8.0),
    (2, '2025-05-18', 7.5),
    (3, '2025-05-19', 8.5),
    (4, '2025-05-19', 8.0),
    (5, '2025-05-20', 6.5),
    (6, '2025-05-20', 9.5),
    (7, '2025-05-21', 7.0),

    -- Q3 2025
    (1, '2025-08-18', 7.0),
    (2, '2025-08-18', 7.5),
    (3, '2025-08-19', 8.0),
    (4, '2025-08-19', 9.0),
    (5, '2025-08-20', 6.5),
    (6, '2025-08-20', 9.0),
    (7, '2025-08-21', 8.0),

    -- Q4 2025
    (1, '2025-10-08', 8.0),
    (1, '2025-10-09',11.0),
    (1, '2025-10-10',11.0),
    (1, '2025-10-11',10.0),
    (1, '2025-11-18', 8.0),
    (2, '2025-10-17', 9.0),
    (2, '2025-11-18', 7.0),
    (3, '2025-11-19', 8.5),
    (4, '2025-11-19', 9.0),
    (5, '2025-11-20', 6.5),
    (6, '2025-11-20', 9.5),
    (7, '2025-11-21', 8.0);

# Inserting Initial Data into Supplies Table
INSERT INTO Supplies (Id, Name, Quantity, PreferredSupplier) VALUES
(201, 'Wine bottles', 300, 101),
(202, 'Corks', 200, 101),
(203, 'Labels', 500, 102),
(204, 'Cardboard boxes', 400, 102),
(205, 'Vats', 3, 103),
(206, 'Tubing', 250, 103);

# Inserting Initial Data into SupplyOrders Table
INSERT INTO SupplyOrders (Id, SupplierId, ExpectedDate, DeliveredDate) VALUES
(5001,101,'2025-11-10','2025-11-9'),
(5002,102,'2025-11-12','2025-11-16'),
(5003,103,'2025-11-20','2025-11-20');

# Inserting Initial Data into ProductOrders Table
INSERT INTO ProductOrders (Id, DistributorId, DatePlaced, Carrier, TrackingNumber) VALUES
(6001,301,'2025-11-18','UPS','1Z-SUN-001'),
(6002,302,'2025-11-19','FedEx','FDX-COAST-002'),
(6003,303,'2025-11-20','UPS','1Z-MID-003'),
(6004,304,'2025-11-21','USPS','USPS-MTN-004'),
(6005,305,'2025-11-22','DHL','DHL-DESERT-005'),
(6006,306,'2025-11-23','FedEx','FDX-ATL-006');

# Inserting Initial Data into SupplyOrderLines Table
INSERT INTO SupplyOrderLines (OrderId, SupplyId, Quantity) VALUES
(5001,201,100),
(5001,202,50),
(5002,203,200),
(5002,204,150),
(5003,205,1),
(5003,206,100);

# Inserting Initial Data into ProductOrderLines Table
INSERT INTO ProductOrderLines (OrderId, WineId, Quantity) VALUES
(6001,401,50),
(6001,402,25),
(6002,402,40),
(6002,401,25),
(6002,404,35),
(6003,404,60),
(6003,401,25),
(6004,404,30),
(6005,401,25),
(6005,402,40),
(6006,402,35);




# Stored functions and procedures

DROP FUNCTION IF EXISTS QuarterlyHours;

CREATE FUNCTION QuarterlyHours (Employee INT,`Quarter` INT,`Year` INT)
RETURNS INT DETERMINISTIC
RETURN (
	SELECT
        COALESCE(SUM(HoursWorked), 0) AS `QuarterlyHours`
    FROM TimecardLines
    WHERE
        EmployeeId = `Employee` AND
        QUARTER(DateWorked) = `Quarter` AND YEAR(DateWorked) = `Year`
);


DROP PROCEDURE IF EXISTS UnderperformingWines;

CREATE PROCEDURE UnderperformingWines(IN AdequateQuantity INT, IN QuartersAgo INT)
WITH SoldInQuarter AS (
	SELECT
    	ProductOrderLines.WineId AS WineId,
    	SUM(ProductOrderLines.Quantity) AS Quantity
	FROM ProductOrderLines
    LEFT JOIN ProductOrders
    	ON ProductOrderLines.OrderId = ProductOrders.Id
    WHERE
    	QUARTER(ProductOrders.DatePlaced) = QUARTER(DATE_SUB(NOW(), INTERVAL QuartersAgo QUARTER)) AND
		YEAR(ProductOrders.DatePlaced) = YEAR(DATE_SUB(NOW(), INTERVAL QuartersAgo QUARTER))
    GROUP BY ProductOrderLines.WineId
)
SELECT
    Wines.Id,
    Wines.VintageYear AS Vintage,
    Wines.Name,
    COALESCE(SoldInQuarter.Quantity, 0) AS 'Quantity Sold',
    Wines.Available AS Inventory
FROM Wines
LEFT JOIN SoldInQuarter
	ON Wines.Id = SoldInQuarter.WineId
WHERE COALESCE(SoldInQuarter.Quantity, 0) < AdequateQuantity;


# Views

DROP VIEW IF EXISTS DeliveryReport;

CREATE VIEW DeliveryReport AS
SELECT
    s.Name AS 'Supplier Name',
    DATE_FORMAT(so.ExpectedDate, '%Y-%m') AS 'Month',

    COUNT(*) AS 'Total Orders',

    SUM(CASE WHEN so.DeliveredDate <= so.ExpectedDate THEN 1 ELSE 0 END) AS 'On Time',
    SUM(CASE WHEN so.DeliveredDate > so.ExpectedDate THEN 1 ELSE 0 END) AS 'Late',
    CASE
    	WHEN AVG(DATEDIFF(so.DeliveredDate, so.ExpectedDate)) < 0 THEN 0
    	ELSE AVG(DATEDIFF(so.DeliveredDate, so.ExpectedDate)) END
		AS 'Average Days Late',
    CASE
		WHEN MAX(DATEDIFF(so.DeliveredDate, so.ExpectedDate)) < 0 THEN 0
		ELSE MAX(DATEDIFF(so.DeliveredDate, so.ExpectedDate)) END
		AS 'Max Days Late'

FROM SupplyOrders so
LEFT JOIN Suppliers s ON so.SupplierId = s.Id
GROUP BY so.SupplierId, DATE_FORMAT(so.ExpectedDate, '%Y-%m')
ORDER BY Month, 'Supplier Name';


DROP VIEW IF EXISTS QuarterlyHoursByEmployee;

CREATE VIEW QuarterlyHoursByEmployee AS
SELECT
	Employees.Id AS 'EmployeeId',
    Employees.Name AS 'Name',
    QuarterlyHours(
        Employees.Id,
        QUARTER(CURRENT_DATE()),
        YEAR(CURRENT_DATE())
	) AS 'Current Quarter',
    QuarterlyHours(
		Employees.Id,
		QUARTER(DATE_SUB(CURRENT_DATE(), INTERVAL 1 QUARTER)),
		YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 1 QUARTER))
	) AS 'Last Quarter',
    QuarterlyHours(
		Employees.Id,
		QUARTER(DATE_SUB(CURRENT_DATE(), INTERVAL 2 QUARTER)),
		YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 2 QUARTER))
	) AS '2 Quarters Ago',
    QuarterlyHours(
		Employees.Id,
		QUARTER(DATE_SUB(CURRENT_DATE(), INTERVAL 3 QUARTER)),
		YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 3 QUARTER))
	) AS '3 Quarters Ago'
FROM Employees;


DROP VIEW IF EXISTS WinesByDistributor;

CREATE VIEW WinesByDistributor AS
SELECT DISTINCT
    Distributors.Id AS DistributorId,
    Distributors.Name AS DistributorName,
    Wines.Id AS WineId,
    Wines.VintageYear AS Vintage,
    Wines.Name AS WineName
FROM Distributors
JOIN ProductOrders
    ON ProductOrders.DistributorId = Distributors.Id
JOIN ProductOrderLines
    ON ProductOrderLines.OrderId = ProductOrders.Id
JOIN Wines
    ON Wines.Id = ProductOrderLines.WineId
ORDER BY Distributors.Name, Wines.Name;

-- BacchusWinery Database Schema Setup Complete --
