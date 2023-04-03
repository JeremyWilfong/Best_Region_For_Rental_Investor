--Joining the 2 tables and removing the United States(average) row.
SELECT *
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE sale.StateName IS NOT NULL


--Determining we have the same # of RegionIDs and that they match each table.
Select 
	COUNT(rent.RegionID), -- 403 Rows
	COUNT(sale.RegionID)  -- 403 Rows
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE sale.StateName IS NOT NULL

Select 
	AVG(rent.RegionID), -- 413951
	AVG(sale.RegionID)  -- 413951
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE sale.StateName IS NOT NULL

--Now that we know our RegionIDs match up, we can begin breaking the data down.
--What Region has the best Sales Price to Rental Income Ratio as of February 2023? Specifically a Low Sales Price, but High Rental Income
--Rank The Ratios as well.
SELECT 
	ROW_NUMBER() OVER(ORDER BY (sale.Jan_23/rent.Jan_23)) AS Jan_Rank,
	ROW_NUMBER() OVER(ORDER BY (sale.Dec_22/rent.Dec_22)) AS Dec_Rank,
	ROW_NUMBER() OVER(ORDER BY (sale.Nov_22/rent.Nov_22)) AS Nov_Rank,
	rent.RegionName,
	rent.Jan_23 as Jan_Rent,
	sale.Jan_23 as Jan_Sale,
	rent.Dec_22 as Dec_Rent,
	sale.Dec_22 as Dec_Sale,
	rent.Nov_22 as Nov_Rent,
	sale.Nov_22 as Nov_Sale,
	(sale.Jan_23/rent.Jan_23) Sales_Per_Rent_Jan,
	(sale.Dec_22/rent.Dec_22) Sales_Per_Rent_Dec,
	(sale.Nov_22/rent.Nov_22) Sales_Per_Rent_Nov
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND (sale.Nov_22/rent.Nov_22) IS NOT NULL
	AND (sale.Dec_22/rent.Dec_22) IS NOT NULL
ORDER BY (sale.Jan_23/rent.Jan_23) 


--Why is Glenwood Springs such an outlier?
SELECT *
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
Where rent.RegionName = 'Glenwood Springs, CO'
--We will not include Glenwood Springs, CO in the rest of the data as it is too much of an outlier. $500k homes do not rent out for 17k a month.


--What Regions had the Highest/Lowest Rents in Jan_23? What were their ranks in regards to sales price to rental income ratio?
SELECT 
	ROW_NUMBER() OVER(ORDER BY (sale.Jan_23/rent.Jan_23)) AS Overall_Rank,
	rent.jan_23,
	rent.RegionName,
	sale.Jan_23,
	sale.regionName,
	(sale.Jan_23/rent.Jan_23) Sales_Per_Rent_Jan
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND (sale.Nov_22/rent.Nov_22) IS NOT NULL
	AND (sale.Dec_22/rent.Dec_22) IS NOT NULL
ORDER BY rent.jan_23 --desc
--Not much of a correlation for either High/Low Rental Incomes.


--What States had the Highest/Lowest Sales Price in Jan_23? What were their ranks in regards to sales price to rental income ratio?
SELECT 
	ROW_NUMBER() OVER(ORDER BY (sale.Jan_23/rent.Jan_23)) AS Overall_Rank,
	rent.jan_23,
	rent.RegionName,
	sale.Jan_23,
	sale.regionName,
	(sale.Jan_23/rent.Jan_23) Sales_Per_Rent_Jan
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND (sale.Nov_22/rent.Nov_22) IS NOT NULL
	AND (sale.Dec_22/rent.Dec_22) IS NOT NULL
ORDER BY sale.jan_23 --desc
--10 out of 20 of the lowest Sales Price Regions were in our Top 20 of Sales Price to Rental Income Ratio. Higher Sales Priced Regions were not in the Top 20.


--What is the average Rental Income and Sales Price Ratio for the last 6 months and how does that compare to just Jan_2023? Not considering Glenwood Springs.
SELECT TOP 20
	ROW_NUMBER() OVER(ORDER BY (sale.Jan_23/rent.Jan_23)) AS Jan_Rank,
	ROW_NUMBER() OVER(ORDER BY ((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22 + sale.Aug_22)/6)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22 + rent.Aug_22)/6))) AS Six_Month_Rank, 
	rent.RegionName,
	rent.Jan_23 as Jan_Rent,
	sale.Jan_23 as Jan_Sale,
	(sale.Jan_23/rent.Jan_23) Sales_Per_Rent_Jan,
	AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22 + rent.Aug_22)/6 as Six_Month_Rent,
	AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22 + sale.Aug_22)/6 as Six_Month_Sale,
	((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22 + sale.Aug_22)/6)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22 + rent.Aug_22)/6)) AS Six_Month_Avg
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND rent.Dec_22 IS NOT NULL
	AND rent.Nov_22 IS NOT NULL
	AND rent.Oct_22 IS NOT NULL
	AND rent.Sep_22 IS NOT NULL
	AND rent.Aug_22 IS NOT NULL
	AND sale.RegionName != 'Glenwood Springs, CO'
GROUP BY rent.regionName, sale.Jan_23 , sale.Dec_22 , sale.Nov_22 , sale.Oct_22 , sale.Sep_22 , sale.Aug_22, rent.Jan_23 , rent.Dec_22 , rent.Nov_22 , rent.Oct_22 , rent.Sep_22 , rent.Aug_22

--What happened to Indiana, PA in the above results?
Select *
FROM Median_Sale_Data
WHERE RegionName = 'Indiana, PA' 

--Aug_22 Rent is Null for Indiana, PA so it didn't show in the above results. Lets see if it is still the best if we take the last 5 months.
SELECT TOP 20
	ROW_NUMBER() OVER(ORDER BY (sale.Jan_23/rent.Jan_23)) AS Jan_Rank,
	ROW_NUMBER() OVER(ORDER BY ((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5))) AS Five_Month_Rank, 
	rent.RegionName,
	rent.Jan_23 as Most_Recent_Rent,
	sale.Jan_23 as Most_Recent_Sale,
	(sale.Jan_23/rent.Jan_23) Sales_Per_Rent_Jan,
	AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5 as Five_Month_Rent,
	AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5 as Five_Month_Sale,
	((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)) AS Five_Month_Avg
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND rent.Dec_22 IS NOT NULL
	AND rent.Nov_22 IS NOT NULL
	AND rent.Oct_22 IS NOT NULL
	AND rent.Sep_22 IS NOT NULL
	AND sale.RegionName != 'Glenwood Springs, CO'
GROUP BY rent.regionName, sale.Jan_23 , sale.Dec_22 , sale.Nov_22 , sale.Oct_22 , sale.Sep_22 , rent.Jan_23 , rent.Dec_22 , rent.Nov_22 , rent.Oct_22 , rent.Sep_22
--My assumption was correct. We will use the 5 month average rank to determine which regions are the best to Buy and Rent out.


--What is the Gross rent multiplier (GRM) of the Top 20?
SELECT TOP 20
	ROW_NUMBER() OVER(ORDER BY ((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5))) AS Five_Month_Rank, 
	rent.RegionName,
	rent.Jan_23 as Most_Recent_Rent,
	sale.Jan_23 as Most_Recent_Sale,
	(sale.Jan_23/rent.Jan_23) Sales_Per_Rent_Jan,
	AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5 as Five_Month_Rent,
	AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5 as Five_Month_Sale,
	((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)) AS Five_Month_Avg,
	(((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5))/((AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)*12)) AS GRM
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND rent.Dec_22 IS NOT NULL
	AND rent.Nov_22 IS NOT NULL
	AND rent.Oct_22 IS NOT NULL
	AND rent.Sep_22 IS NOT NULL
	AND sale.RegionName != 'Glenwood Springs, CO'
GROUP BY rent.regionName, sale.Jan_23 , sale.Dec_22 , sale.Nov_22 , sale.Oct_22 , sale.Sep_22 , rent.Jan_23 , rent.Dec_22 , rent.Nov_22 , rent.Oct_22 , rent.Sep_22

--Out of the Top 20, which Regions meet the 1% Investing Rule? Monthly Rent should be at least 1% of Sales Price.
SELECT 
	ROW_NUMBER() OVER(ORDER BY ((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5))) AS Five_Month_Rank, 
	rent.RegionName,
	rent.StateName,
	rent.Jan_23 as Most_Recent_Rent,
	sale.Jan_23 as Most_Recent_Sale,
	(sale.Jan_23/rent.Jan_23) Sales_Per_Rent_Most_Recent,
	AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5 as Five_Month_Rent,
	AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5 as Five_Month_Sale,
	((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)) AS Five_Month_Avg,
	(((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5))/((AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)*12)) AS GRM,
	((AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)/(AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)) AS Percent_Rule
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND rent.Dec_22 IS NOT NULL
	AND rent.Nov_22 IS NOT NULL
	AND rent.Oct_22 IS NOT NULL
	AND rent.Sep_22 IS NOT NULL
	AND sale.RegionName != 'Glenwood Springs, CO'
GROUP BY rent.regionName, rent.StateName, sale.Jan_23 , sale.Dec_22 , sale.Nov_22 , sale.Oct_22 , sale.Sep_22 , rent.Jan_23 , rent.Dec_22 , rent.Nov_22 , rent.Oct_22 , rent.Sep_22
--Only Indiana, PA meets the 1% Rule.


--We will now move to Excel to forecast the rents and sales prices of all the regions to see which ones will be in the Top 20 in the next 5 months.


--Now that we've forecasted the next 5 months. Lets start by narrowing the # of Sales Price rows to match Rental Income rows.
SELECT 
	Rent.RegionName, rent.Feb_23 as Feb_Rents, rent.Mar_23 as Mar_Rents, rent.Apr_23 as Apr_Rents, rent.May_23 as May_Rents, rent.Jun_23 as Jun_Rents,
	sale.Feb_23 as Feb_Sales, sale.Mar_23 as Mar_Sales, sale.Apr_23 as Apr_Sales, sale.May_23 as May_Sales, sale.Jun_23 as Jun_Sales
FROM Forecasted_Rental_Data rent
JOIN Forecasted_Sale_Data sale
ON rent.RegionName = sale.RegionName


--Now that we've cleaned the data, lets start calculating 5-Month Future Average of Rental Income and Sales Price.
SELECT 
	Rent.RegionName, 
	(AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5) as Avg_Future_Rent, 
	(AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5) as Avg_Future_Sale 
FROM Forecasted_Rental_Data rent
JOIN Forecasted_Sale_Data sale
ON rent.RegionName = sale.RegionName
GROUP BY Rent.RegionName


--The Averages are calculated. Let's Start Determining Sales Per Rental Income, GRM, and 1% Rule.
SELECT 
	ROW_NUMBER() OVER(ORDER BY ((AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5)/(AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5))) AS Future_Rank,
	Rent.RegionName,
	rent.State,
	(AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5) as Avg_Future_Rent, 
	(AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5) as Avg_Future_Sale,
	((AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5)/(AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5)) AS Future_Ratio,
	(((AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5))/((AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5)*12)) AS GRM,
	((AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5)/(AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5)) AS Percent_Rule
FROM Forecasted_Rental_Data rent
JOIN Forecasted_Sale_Data sale
ON rent.RegionName = sale.RegionName
WHERE rent.RegionName != 'Glenwood Springs, CO'
GROUP BY Rent.RegionName, rent.State
--Based on forecasted projections, there are now 2 Regions who meet the 1% Rule. Blacksburg, VA and Indiana, PA.


--For Fun, let's see which states have the best Sales Price to Rental Income Ratio for our Forecasted Data and Original Data.
SELECT TOP 20
	ROW_NUMBER() OVER(ORDER BY ((AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5)/(AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5))) AS Future_Rank,
	Rent.State, 
	(AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5) as Avg_Future_Rent, 
	(AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5) as Avg_Future_Sale,
	((AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5)/(AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5)) AS Future_Ratio,
	(((AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5))/((AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5)*12)) AS GRM,
	((AVG(rent.Feb_23 + rent.Mar_23 + rent.Apr_23 + rent.May_23 + rent.Jun_23)/5)/(AVG(sale.Feb_23 + sale.Mar_23 + sale.Apr_23 + sale.May_23 + sale.Jun_23)/5)) AS Percent_Rule
FROM Forecasted_Rental_Data rent
JOIN Forecasted_Sale_Data sale
ON rent.RegionName = sale.RegionName
WHERE rent.RegionName != 'Glenwood Springs, CO'
GROUP BY rent.State
ORDER BY Future_Ratio

SELECT TOP 20
	ROW_NUMBER() OVER(ORDER BY ((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5))) AS Five_Month_Rank, 
	rent.StateName,
	AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5 as Five_Month_Rent,
	AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5 as Five_Month_Sale,
	((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)/(AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)) AS Five_Month_Ratio,
	(((AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5))/((AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)*12)) AS GRM,
	((AVG(rent.Jan_23 + rent.Dec_22 + rent.Nov_22 + rent.Oct_22 + rent.Sep_22)/5)/(AVG(sale.Jan_23 + sale.Dec_22 + sale.Nov_22 + sale.Oct_22 + sale.Sep_22)/5)) AS Percent_Rule
FROM Median_Rental_Data rent
JOIN Median_Sale_Data sale
ON rent.RegionID = sale.RegionID
WHERE 
	sale.StateName IS NOT NULL 
	AND rent.Jan_23 IS NOT NULL
	AND rent.Dec_22 IS NOT NULL
	AND rent.Nov_22 IS NOT NULL
	AND rent.Oct_22 IS NOT NULL
	AND rent.Sep_22 IS NOT NULL
	AND sale.RegionName != 'Glenwood Springs, CO'
GROUP BY rent.StateName
--The Top 5 States stayed consistent between forecasted data and past data: IL, NJ, MS, NY, GA.

--We will now visualize all of our findings in Tableau.



