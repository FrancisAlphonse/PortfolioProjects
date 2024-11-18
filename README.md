# E-Commerce Data Analysis Project  

## Overview  
This project is a data analysis exercise using realistic e-commerce data sourced from Kaggle. The objective was to clean, analyze, and extract insights that could help improve e-commerce strategies.  

## Timeline  
- **Start Date:** November 14, 2024  
- **Completion Date:** November 18, 2024  

## Objectives  
1. Clean and structure raw e-commerce data for analysis.  
2. Generate meaningful insights related to sales, customer demographics, and shipping performance.  
3. Create an interactive dashboard for easy visualization and interpretation.  

## Dataset  
- **Source:** Kaggle  
- **Dataset Name:** Realistic E-commerce Raw Data  

## Process  

### 1. Initial Steps  
- Downloaded and explored the raw data to understand its structure and key attributes.  
- Created a duplicate copy of the dataset, named "Working Sheet," for all modifications.  

### 2. Data Cleaning  
- Adjusted column widths for readability.  
- Applied filters to identify and handle blank values:  
  - Replaced blanks with "NA" for non-numeric fields.  
  - Used `0` for missing numeric values.  
- Checked for duplicates (none were found).  
- Grouped customer age data into categories using the `IF` function.  

### 3. Analytical Questions  
To guide the analysis, the following questions were defined:  
1. What is the region-wise sales distribution?  
2. Which age group purchases more products in each category?  
3. What are gender-specific purchasing patterns by product?  
4. What is the regional distribution of shipping statuses (In Transit, Delivered, Returned)?  
5. Which region charges the highest shipping fees, and for which products?  

### 4. Data Analysis  
- Conducted analysis using pivot tables to answer the defined questions.  
- Created pivot charts for visual representation of insights.  
- Consolidated all visualizations into a dedicated "Dashboards" sheet.  

### 5. Dashboard Enhancements  
- Added slicers to make the dashboard interactive and user-friendly.  

## Key Insights  
1. **Region-Wise Sales:**  
   - The East region accounts for the highest sales (~25%).  
2. **Age Group Analysis:**  
   - Young customers (<21 years) dominate the electronics category (~93%).  
3. **Gender-Based Insights:**  
   - Laptops are the top-selling product, with males purchasing ~57% of them.  
4. **Shipping Status:**  
   - The East region has the highest "In Transit" rate (~28%).  
   - The West region leads in Delivery and Return rates (~29%).  
5. **Shipping Fee Analysis:**  
   - The West region charges the highest average shipping fee (~₹13 per product).  

## Recommendations  
- Focus marketing efforts on male customers below 21 years in the East region.  
- Improve shipping processes to reduce "In Transit" and "Returned" rates.  
- Optimize shipping fees in the West region to enhance customer satisfaction.  

## Tools Used  
- **Excel**: Data cleaning, pivot tables, and dashboards  

## Lessons Learned  
- Effective data cleaning is crucial for reliable analysis.  
- Pivot tables and charts provide powerful tools for exploring and visualizing data.  
- Interactive dashboards make insights more accessible and actionable.  
