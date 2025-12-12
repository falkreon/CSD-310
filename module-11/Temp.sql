-- Wines By Distributor

DROP VIEW IF EXISTS WinesByDistributor;

CREATE VIEW WinesByDistributor AS
SELECT DISTINCT
    Distributors.Id AS DistributorId,
    Distributors.Name AS DistributorName,
    Wines.Id AS WineId,
    Wines.Name AS WineName
FROM Distributors
JOIN ProductOrders
    ON ProductOrders.DistributorId = Distributors.Id
JOIN ProductOrderLines
    ON ProductOrderLines.OrderId = ProductOrders.Id
JOIN Wines
    ON Wines.Id = ProductOrderLines.WineId
ORDER BY Distributors.Name, Wines.Name;




-- Underperforming Wines
DROP PROCEDURE IF EXISTS UnderperformingWines;

CREATE PROCEDURE UnderperformingWines(IN AdequateQuantity INT)
SELECT
    Wines.Id,
    Wines.Name,
    COALESCE(SUM(ProductOrderLines.quantity), 0) AS TotalQuantitySold
FROM Wines
LEFT JOIN ProductOrderLines
ON Wines.Id = ProductOrderLines.wineId
GROUP BY Wines.Id, Wines.Name
HAVING TotalQuantitySold < AdequateQuantity;
