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
DROP TABLE IF EXISTS `Time`;
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
