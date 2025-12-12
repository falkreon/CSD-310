SELECT Id, Name
    FROM Distributors;
SELECT Id, DistributorId
    FROM ProductOrders;
SELECT OrderId, WineId
    FROM ProductOrderLines;
SELECT Id, Name
    FROM Wines;
-- Getting all the necessary columns to create the joins.
-- joining distributors table to product orders, then product order lines and finally wines table to get the wine names (inner join)
SELECT
    d.Id AS DistributorId,
    d.Name AS DistributorName,
    po.Id AS OrderId,
    pol.WineId,
    w.Name AS WineName
FROM Distributors d
JOIN ProductOrders po 
    ON po.DistributorId = d.Id
JOIN ProductOrderLines pol 
    ON pol.OrderId = po.Id
JOIN Wines w 
    ON w.Id = pol.WineId
ORDER BY d.Name, w.Name;
--
SELECT DISTINCT-- not necessary in the current example but will be if a distributor place several orders for the same wine
    d.Id AS DistributorId,
    d.Name AS DistributorName,
    w.Id AS WineId,
    w.Name AS WineName
FROM Distributors d
JOIN ProductOrders po 
    ON po.DistributorId = d.Id
JOIN ProductOrderLines pol 
    ON pol.OrderId = po.Id
JOIN Wines w 
    ON w.Id = pol.WineId
ORDER BY d.Name, w.Name;
-- View
DROP VIEW IF EXISTS WineAssignedDistributors;
CREATE VIEW WineAssignedDistributors AS
SELECT DISTINCT 
    w.Name AS WineName,
    d.Id AS DistributorId,
    d.Name AS DistributorName
FROM Distributors d
JOIN ProductOrders po 
    ON po.DistributorId = d.Id
JOIN ProductOrderLines pol 
    ON pol.OrderId = po.Id
JOIN Wines w 
    ON w.Id = pol.WineId;
