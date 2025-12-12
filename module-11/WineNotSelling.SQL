SELECT Id, Name
FROM Wines;

SELECT wineId, quantity
FROM ProductOrderLines;

SELECT w.Id, w.Name, pol.quantity
FROM Wines w
LEFT JOIN ProductOrderLines pol ON w.Id = pol.wineId;
-- left join used to include nulls in product order lines table
SELECT w.Id, w.Name, COALESCE(SUM(pol.quantity), 0) AS TotalQuantitySold --replace the null with a 0 and name a new columns in the table
FROM Wines w
LEFT JOIN ProductOrderLines pol ON w.Id = pol.wineId -- join pol to wines on wineId 
GROUP BY w.Id, w.Name
HAVING COALESCE(SUM(pol.quantity), 0) = 0; --Filter the result to only get the wine that have never been sold
--view
DROP VIEW IF EXISTS WineNotSelling;
CREATE VIEW WineNotSelling AS
SELECT 
    w.Id AS WineId,
    w.Name AS WineName
FROM Wines w
LEFT JOIN ProductOrderLines pol 
    ON pol.wineId = w.Id
GROUP BY w.Id, w.Name
HAVING COALESCE(SUM(pol.quantity), 0) =0;
