SELECT *
FROM PortfolioProject..Nashville_housing_data

-- Standardize Date Format
SELECT SaleDateConverted, convert(Date, SaleDate)
FROM PortfolioProject..Nashville_housing_data
UPDATE PortfolioProject..Nashville_housing_data
SET SaleDate = convert(Date, SaleDate)

-- If it doesn't Update properly
ALTER TABLE Nashville_housing_data
ADD SaleDateConverted Date

UPDATE PortfolioProject..Nashville_housing_data
SET SaleDateConverted = convert(Date, SaleDate) 

-- Populate Property Address Data
SELECT *
FROM PortfolioProject..Nashville_housing_data
--where PropertyAddress is null
order by ParcelID

SELECT *
FROM PortfolioProject..Nashville_housing_data Table1
JOIN PortfolioProject..Nashville_housing_data Table2
	ON Table1.ParcelID = Table2.ParcelID
	AND Table1.[UniqueID ] <> Table2.[UniqueID ]
WHERE Table1.PropertyAddress is null

UPDATE Table1
SET PropertyAddress = isnull(Table1.PropertyAddress, Table2.PropertyAddress)
FROM PortfolioProject..Nashville_housing_data Table1
JOIN PortfolioProject..Nashville_housing_data Table2
	ON Table1.ParcelID = Table2.ParcelID
	AND Table1.[UniqueID ] <> Table2.[UniqueID ]
WHERE Table1.PropertyAddress is null

-- Breaking out Address into Individual Columns For Property Address (Address, City)
SELECT PropertyAddress
FROM PortfolioProject..Nashville_housing_data

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1
, LEN(PropertyAddress)) AS City
FROM PortfolioProject..Nashville_housing_data

--Adding New Data Into New Columns 
ALTER TABLE PortfolioProject..Nashville_housing_data
ADD PropertySplitAddress nvarchar(255)

UPDATE PortfolioProject..Nashville_housing_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject..Nashville_housing_data
ADD PropertySplitCity nvarchar(255)

UPDATE PortfolioProject..Nashville_housing_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1
, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..Nashville_housing_data


-- Breaking out Address into Individual Columns For Owner Address (Address, City, State)
SELECT OwnerAddress
FROM PortfolioProject..Nashville_housing_data

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProject..Nashville_housing_data

--Adding New Data Into New Columns 
ALTER TABLE PortfolioProject..Nashville_housing_data
ADD OwnerSplitAddress nvarchar(255)

UPDATE PortfolioProject..Nashville_housing_data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE PortfolioProject..Nashville_housing_data
ADD OwnerSplitCity nvarchar(255)

UPDATE PortfolioProject..Nashville_housing_data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE PortfolioProject..Nashville_housing_data
ADD OwnerSplitState nvarchar(255)

UPDATE PortfolioProject..Nashville_housing_data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT *
FROM PortfolioProject..Nashville_housing_data

-- Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..Nashville_housing_data
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM PortfolioProject..Nashville_housing_data

UPDATE PortfolioProject..Nashville_housing_data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END 

SELECT *
FROM PortfolioProject..Nashville_housing_data

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SaleDate,
				SalePrice,
				LegalReference
				ORDER BY 
				UniqueID
				) row_num
FROM PortfolioProject..Nashville_housing_data
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM PortfolioProject..Nashville_housing_data

-- Delete Unused Columns
SELECT *
FROM PortfolioProject..Nashville_housing_data

ALTER TABLE PortfolioProject..Nashville_housing_data
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict