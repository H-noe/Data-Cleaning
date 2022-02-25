SELECT *
FROM dbo.Housing
-- First, lets standardize the date format (Get rid of the hour:minute:second timestamp)


SELECT SaleDateConverted, Convert(Date, SaleDate)
FROM dbo.Housing

ALTER TABLE Housing
ADD SaleDateConverted Date;

Update Housing
SET SaleDateConverted = CONVERT(Date, SaleDate)


 -- Lets populate the property address data where it is null
 -- The same ParcelIDs have the same address, so we will use that to populate null fields

SELECT *
FROM dbo.Housing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM dbo.Housing A
JOIN
dbo.Housing B
on A.ParcelID = B.ParcelID
and A.UniqueID <> B.UniqueID
Where A.PropertyAddress is null

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM dbo.Housing A
JOIN
dbo.Housing B
on A.ParcelID = B.ParcelID
and A.UniqueID <> B.UniqueID
Where A.PropertyAddress is null

-- The address needs to be broken into individual columns (Address, City, State)

SELECT PropertyAddress
FROM dbo.Housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM dbo.Housing 

ALTER TABLE Housing
ADD PropertySplitAddress Nvarchar(255);

UPDATE dbo.Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Housing
ADD PropertySplitCity Nvarchar(155);

UPDATE dbo.Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM dbo.Housing

-- Now, we do the same thing for the OwnerAddress field (this one includes a state)

SELECT OwnerAddress
FROM dbo.Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM dbo.Housing

ALTER TABLE Housing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE Housing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Housing
ADD OwnerSplitCity Nvarchar(155)

UPDATE Housing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Housing
ADD OwnerSplitState Nvarchar(3)

UPDATE Housing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--Select * 
--FROM dbo.Housing

-- Change Y and N to Yes and No in SoldAsVacant field

Select Distinct(SoldAsVacant), Count(SoldasVacant)
FROM dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, CASE when SoldAsVacant = 'Y' THEN 'Yes'
					When SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END
FROM dbo.Housing

UPDATE Housing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
					When SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END


-- Removing Duplicates (we will be deleting data)

WITH RowNUMCTE as (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID) row_num
FROM Housing
--ORDER BY ParcelID
)
DELETE
FROM RowNUMCTE
WHERE row_num > 1


-- Finally, lets delete some columns that we do not need anymore

SELECT *
FROM dbo.Housing

ALTER TABLE Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Housing
DROP COLUMN SaleDate

