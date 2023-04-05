# Rental Investment Project

**GOAL:** 
- Investor Client wants to know which cities in the United States have the best rental property investment opportunity.

**SOLUTION:** 
- Created a Tableau Dashboard showing which cities had the best GRM (Gross Rent Multiplier) and cities that met the 1% rule (Rental Income/Sales Price) based on the Median Rental Income and Median Sales Price Data of each city downloaded from Zillow. 
- **Indiana, PA and Blacksburn, VA are two cities that met the 1% rule.**
- **Here is the Tableau Dashboard for [Best Regions for Rental Investors](https://public.tableau.com/views/BestRegionsforRentalInvestors/TopRegions?:language=en-US&:display_count=n&:origin=viz_share_link)**

**SKILLS USED:** 
- Excel for Forecasting and Initial Data Cleaning. 
- MS SQL For Joining Zillow Data and Calculating GRM/1% Rule.
- Tableau for Visualizing the Data.

**QUESTIONS ASKED:** 
- What Top 20 Cities in the US have the best Sales Price to Rental Income ratio based on current data? Specifically Low Sales Price with High Rental Income.
- What Top 20 Cities in the US have the best Sales Price to Rental Income ratio based on forecasted data?
- Which Cities in each State have the best GRM and 1% Rule based on current data AND forecasted data?
- What are the Top States to buy a Rental Property in based on the 1% Rule?
                 
**PROCESS:**
1. Downloaded Median_Sales_Data and Median_Rental_Data from Zillow Research.
2. Cleaned the 2 datasets in Excel to only show the last few years of data. I also cleaned the dates in the column header to make them more SQL friendly.
3. Joined the 2 tables together in MS SQL, calculated the values in the "Questions Asked" section by taking the average of the last 5 months data, and removed an outlier (Glenwood Springs, CO).
4. Brought the tables back into Excel to forecast what the Median Rental Income and Median Sales Price would be for the next 5 months in each city.
5. Joined the 2 forecasted tables together in MS SQL and calculated the values in the "Questions Asked" section by taking the average of the forecasted 5 months.
6. Once all my queries were completed, I downloaded the individual queried data and visualized it in Tableau for the Investor.
