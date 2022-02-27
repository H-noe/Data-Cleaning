-- Cleaning DIMDate Table

SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date, 
  --,[DayNumberOfWeek], 
  [EnglishDayNameOfWeek] AS Day, 
  --,[SpanishDayNameOfWeek]
  --,[FrenchDayNameOfWeek]
  --,[DayNumberOfMonth]
  --,[DayNumberOfYear]
  [WeekNumberOfYear] As Weeknbr, 
  LEFT([EnglishMonthName], 3) AS Monthshort, 
  [EnglishMonthName] AS Month, 
  --,[SpanishMonthName]
  --,[FrenchMonthName]
  [MonthNumberOfYear] AS Monthnbr, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year 
  --,[CalendarSemester]
  --,[FiscalQuarter]
  --,[FiscalYear]
  --,[FiscalSemester]
FROM 
  [AdventureWorksDW2019].[dbo].[DimDate]
WHERE 
  CalendarYear >= 2019