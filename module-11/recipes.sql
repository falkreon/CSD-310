# Late Deliveries
SELECT
	SupplyOrders.Id AS 'Id',
    SupplyOrders.ExpectedDate AS 'Expected Date',
	DATEDIFF(SupplyOrders.DeliveredDate, SupplyOrders.ExpectedDate) AS 'Days Late'
FROM SupplyOrders
HAVING `Days Late` > 0;


# Totaling TimecardLines up for each employee/year/quarter
# This is not a full answer - it's the data we want, but not shaped in the most useful way.
SELECT
	TimecardLines.EmployeeId,
    Employees.Name,
	SUM(TimecardLines.HoursWorked) AS 'Quarterly Hours',
    QUARTER(TimecardLines.DateWorked) AS 'Quarter',
    YEAR(TimecardLines.DateWorked) AS 'Year'
FROM TimecardLines
LEFT JOIN Employees ON TimecardLines.EmployeeId = Employees.Id
GROUP BY TimecardLines.EmployeeId, `Year`, `Quarter`;


# Wine Sales by Distributor
SELECT
    ProductOrders.DistributorId AS 'DistributorId',
    Distributors.Name AS 'Distributor',
    GROUP_CONCAT(Wines.Name) AS 'Wines',
    SUM(ProductOrderLines.Quantity) AS 'Total Quantity'

FROM ProductOrderLines
LEFT JOIN ProductOrders ON ProductOrderLines.OrderId = ProductOrders.Id
LEFT JOIN Distributors ON ProductOrders.DistributorId = Distributors.Id
LEFT JOIN Wines ON Wines.Id = ProductOrderLines.WineId
GROUP BY ProductOrders.DistributorId
ORDER BY Distributors.Name;


# Underperforming Wines
SELECT
    Wines.Id,
    Wines.Name,
    COALESCE(SUM(ProductOrderLines.Quantity), 0) AS TotalOrdered
FROM Wines
LEFT JOIN ProductOrderLines ON Wines.Id = ProductOrderLines.WineId
GROUP BY Wines.Id
HAVING TotalOrdered < 20;




# A Second Look at Quarterly Hours

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

SELECT QuarterlyHours(1, 4, 2025) AS 'Q4 2025';

# Using the function

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
