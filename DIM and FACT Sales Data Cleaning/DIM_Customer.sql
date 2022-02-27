-- Cleaning DIMCustomer Table --

SELECT 
  c.customerkey AS CustomerKey, 
  --,[GeographyKey]
  --,[CustomerAlternateKey]
  --,[Title]
  c.FirstName AS [FirstName], 
  --,[MiddleName]
  c.LastName AS [LastName], 
  c.FirstName + ' ' + LastName AS [Full Name], --Combining First and Last name fields
  --,[NameStyle]
  --,[BirthDate]
  --,[MaritalStatus]
  --,[Suffix]
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender, 
  --,[EmailAddress]
  --,[YearlyIncome]
  --,[TotalChildren]
  --,[NumberChildrenAtHome]
  --,[EnglishEducation]
  --,[SpanishEducation]
  --,[FrenchEducation]
  --,[EnglishOccupation]
  --,[SpanishOccupation]
  --,[FrenchOccupation]
  --,[HouseOwnerFlag]
  --,[NumberCarsOwned]
  --,[AddressLine1]
  --,[AddressLine2]
  --,[Phone]
  c.datefirstpurchase AS DateFirstPurchase, 
  --,[CommuteDistance]
  g.city AS [Customer City] --Joined in Customer City from DimGeography Table
FROM 
  dbo.DimCustomer AS c 
  LEFT JOIN dbo.DimGeography AS g ON g.geographykey = c.geographykey 
ORDER BY 
  CustomerKey ASC