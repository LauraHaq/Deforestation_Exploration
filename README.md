# Deforestation_Exploration

## Report for ForestQuery into Global Deforeation, 1990 to 2016

ForestQuery is on a mission to combat deforestation around the world and to raise awareness about this topic and its impact on the environment. The data analysis team at ForestQuery has obtained data from the World Bank that includes forest area and total land area by country and year from 1990 to 2016, as well as a table of countries and the regions to which they belong.

The data analysis team has used SQL to bring these tables together and to query them in an effort to find areas of concern as well as areas that present an opportunity to learn from successes.

### 1. Global Situation
According to the World Bank, the total forest area of the world was 41,282,694.9 sq km in 1990. As of 2016, the most recent year for which data was available, that number had fallen to 39,958,245.9 sq km a loss of -1,324,449 sq km or -3.21%.

The forest area lost over this time period is slightly more than the entire land area of Peru listed for the year 2016 (which is 1,279,999.99)

The forest area lost over this time period is slightly more than the entire land area of Peru listed for the year 2016 (which is 1,279,999.99)

### 2. Regional Outlook
In 2016, the percentage of the total land area of the world designated as forested was 31.38%. The region with the highest relative forestation was Latin America & Caribbean, with 46.16%, and the region with the lowest relative forestation was the Middle East & North Africa with 2.07% forestation.

In 1990, the percentage of the total land area of the world designated as forested was 32.42%. The region with the highest relative forestation was Latin America & Caribbean, with 51.03%, and the region with the lowest relative forestation was the Middle East & North Africa, with 1.78% forestation.

__Table 2.1: Percent Forest Area by Region, 1990 & 2016__
![region_table](https://github.com/LauraHaq/Deforestation_Exploration/blob/main/percent_forest_area_by_region.png)


The only regions of the world that decreased in percent forest area from 1990 to 2016 were Sub-Saharan Africa (dropped from 30.67%  to 28.79%) and Latin America & Caribbean 51.03% to 46.16%). All other regions actually increased in forest area over this time period. However, the drop in forest area in the two aforementioned regions was so large, the percent forest area of the world decreased over this time period from 32.42% to 31.38%. 

### 3. Country Level Detail
#### A. Success Stories
There is one particularly bright spot in the data at the country level, China. This country actually increased in forest area from 1990 to 2016 by 527,229 km². It would be interesting to study what has changed in this country over this time to drive this figure in the data higher. The country with the next largest increase in forest area from 1990 to 2016 was the United States, but it only saw an increase of 79,200 km², much lower than the figure for China.

China and the United States are of course very large countries in total land area, so when we look at the largest percent change in forest area from 1990 to 2016, we aren’t surprised to find a much smaller country listed at the top. Iceland increased in forest area by 213.66% from 1990 to 2016. 

#### B. Largest Concerns
Which countries are seeing deforestation to the largest degree? We can answer this question in two ways. First, we can look at the absolute square kilometer decrease in forest area from 1990 to 2016. The following 5 countries had the largest decrease in forest area over the time period under consideration:

Table 3.1: Top 5 Amount Decrease in Forest Area by Country, 1990 & 2016:
![decrease_time](https://github.com/LauraHaq/Deforestation_Exploration/blob/main/percent_forest_area_by_region.png)

The second way to consider which countries are of concern is to analyze the data by percent decrease.

Table 3.2: Top 5 Percent Decrease in Forest Area by Country, 1990 & 2016:
![decrease_percent](https://github.com/LauraHaq/Deforestation_Exploration/blob/main/largest_concern_percent.png)

When we consider countries that decreased in forest area percentage the most between 1990 and 2016, we find that four of the top 5 countries on the list are in the region of Sub-Saharan Africa. The countries are Togo, Nigeria, Uganda and Mauritania. The 5th country on the list is Honduras, which is in the Latin America & Caribbean region. 

From the above analysis, we see that Nigeria is the only country that ranks in the top 5 both in terms of absolute square kilometer decrease in the forest as well as the percent decrease in forest area from 1990 to 2016. Therefore, this country has a significant opportunity ahead to stop the decline and hopefully spearhead remedial efforts.

#### C. Quartiles
Table 3.3: Count of Countries Grouped by Forestation Percent Quartiles, 2016:
![quartiles](https://github.com/LauraHaq/Deforestation_Exploration/blob/main/quartiles.png)
The largest number of countries in 2016 were found in the first quartile.

There were 9 countries in the top quartile in 2016. These are countries with a very high percentage of their land area designated as forest. The following is a list of countries and their respective forest land, denoted as a percentage.

Table 3.4: Top Quartile Countries, 2016:

![top_quartiles](https://github.com/LauraHaq/Deforestation_Exploration/blob/main/top_quartiles.png)


### 4. RECOMMENDATIONS
Write out a set of recommendations as an analyst on the ForestQuery team.
- What have you learned from the World Band data?
- Which countries should we focus on over others?


