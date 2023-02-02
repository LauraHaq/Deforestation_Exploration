-- Create table
DROP VIEW IF EXISTS forestation;
CREATE VIEW forestation AS
SELECT l.country_code,
        l.country_name,
        l.year,
        f.forest_area_sqkm,
        (f.forest_area_sqkm/2.59) AS forest_area_sqmiles,
        l.total_area_sq_mi,
        r.region,
        r.income_group, 
        (((f.forest_area_sqkm/2.59)/l.total_area_sq_mi)*100.00)  as forest_percent
FROM forest_area AS f
LEFT JOIN land_area AS l
    ON f.country_code = l.country_code 
    AND f.year =l.year
LEFT JOIN regions AS r
    ON r.country_code = l.country_code
WHERE f.forest_area_sqkm IS NOT NULL
	  AND l.total_area_sq_mi IS NOT NULL
GROUP BY l.country_code, 
         l.country_name, 
         l.year, 
         r.region, 
         f.forest_area_sqkm, 
         forest_area_sqmiles, 
         l.total_area_sq_mi, 
         r.income_group;


--1ab What was the total forest area (in sq km) of the world in 1990 and 2016?
SELECT country_name,
       forest_area_sqkm,
       year
FROM forestation
WHERE country_name = 'World' 
	AND (year = 1990 
    OR year = 2016);

-- 1c What was the change (in sq km) in the forest area of the world from 1990 to 2016?
SELECT ((SELECT forest_area_sqkm
        FROM forestation
        WHERE country_name = 'World'
            AND year = 2016)
        -
        (SELECT forest_area_sqkm
        FROM forestation
        WHERE country_name = 'World'
            AND year = 1990)) as forest_lost_sqkm;

--1d What was the percent change in forest area of the world between 1990 abd 2016?
SELECT (SELECT ((SELECT forest_area_sqkm
                FROM forestation
                WHERE country_name = 'World'
                    AND year = 2016)
                -
                (SELECT forest_area_sqkm
                FROM forestation
                WHERE country_name = 'World'
                    AND year = 1990))
        /
        (SELECT forest_area_sqkm
        FROM forestation
        WHERE country_name = 'World'
        AND year = 1990))*100 as forest_lost_percent;

--1e If you compare the amount of forest area lost between 1990 and 2016, 
-- to which country's total area in 2016 is it closest to?
SELECT country_name,
       (total_area_sq_mi*2.59) AS total_area_sqkm
FROM forestation
WHERE YEAR = 2016
    AND total_area_sq_mi *2.59 <= 1324449
GROUP BY country_name, total_area_sqkm
ORDER BY total_area_sqkm DESC
LIMIT 1

--2 region table
DROP VIEW if EXISTS region_table;
CREATE VIEW region_table AS
SELECT *
FROM(WITH region_1990 AS 
	    (SELECT region,
                ROUND((SUM(forest_area_sqmiles)/SUM(total_area_sq_mi))::NUMERIC*100,2) AS percent_1990
        FROM forestation
        WHERE year = 1990
        GROUP BY region),
     region_2016 AS
        (SELECT region,
     	        ROUND((SUM(forest_area_sqmiles)/SUM(total_area_sq_mi))::NUMERIC*100,2) AS percent_2016
        FROM forestation
        WHERE year=2016
        GROUP BY region),
     regions AS
        (SELECT region_1990.region,
                percent_1990,
                percent_2016,
                CASE WHEN percent_2016 > percent_1990 THEN 'Increased'
                    ELSE 'Decreased' END AS outcome
        FROM region_1990
        FULL JOIN region_2016
        ON region_1990.region = region_2016.region)
SELECT *
FROM regions) as region_table

-- 2.a what was the percent forest of the entire world in 2016? 
-- Which region had the HIGHEST percent forest in 2016?
-- Which region had the LOWEST percent in 2016? (2 decimal places)
SELECT region,
       percent_2016
FROM region_table
WHERE region = 'World'
	OR percent_2016 = (SELECT percent_2016 FROM region_table ORDER BY percent_2016 ASC Limit 1)
        OR percent_2016 = (SELECT percent_2016 FROM region_table ORDER BY percent_2016 DESC Limit 1)

-- 2.b What was the percent forest of the entire world in 1990?
-- which region had the HIGHEST percent forest in 1990?
-- Which region had the LOWEST percent forest in 1990? ( to 2 decimal places)
SELECT region,
       percent_1990
FROM region_table
WHERE region = 'World'
	OR percent_1990 = (SELECT percent_1990 FROM region_table ORDER BY percent_1990 ASC Limit 1)
        OR percent_1990 = (SELECT percent_1990 FROM region_table ORDER BY percent_1990 DESC Limit 1)

-- 2.c Based on the table you, which regions of the world DECREASED in forest area from 1990 to 2016?
SELECT region,
       outcome
FROM region_table
WHERE percent_2016 < percent_1990
 AND region != 'World'

-- 3. Country table
DROP VIEW IF EXISTS country_table;
CREATE VIEW country_table AS
SELECT *
FROM (WITH country_1990 AS 
	    (SELECT country_name,
                region,
                forest_area_sqkm,
                ROUND((SUM(forest_area_sqmiles)/SUM(total_area_sq_mi))::NUMERIC*100,2) AS percent_1990
        FROM forestation
        WHERE year = 1990
        GROUP BY country_name,forest_area_sqkm, region),
     country_2016 AS
        (SELECT country_name,
                region,
                forest_area_sqkm,
     	        ROUND((SUM(forest_area_sqmiles)/SUM(total_area_sq_mi))::NUMERIC*100,2) AS percent_2016
        FROM forestation
        WHERE year=2016
        GROUP BY country_name,forest_area_sqkm, region),
     countries AS
        (SELECT country_1990.country_name,
                country_1990.region,
                percent_1990,
                percent_2016,
                ROUND((((country_2016.forest_area_sqkm - country_1990.forest_area_sqkm)/country_1990.forest_area_sqkm)::NUMERIC*100),2) AS percent_diff,
                country_2016.forest_area_sqkm-country_1990.forest_area_sqkm AS sqkm_diff
        FROM country_1990
        FULL JOIN country_2016
        ON country_1990.country_name = country_2016.country_name)
        SELECT *
        FROM countries) AS country_table;
SELECT * 
from country_table;

-- SUCCESS story 
--by sqkm
SELECT country_name,
	   sqkm_diff
FROM country_table
ORDER BY sqkm_diff DESC
LIMIT 2;
-- by percent
SELECT country_name,
       percent_diff
FROM country_table
ORDER BY percent_diff DESC
LIMIT 1;

--3.a Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016?
-- What was the difference in forest area for each?
SELECT country_name,
	   region,
       sqkm_diff
FROM country_table
WHERE country_name != 'World'
ORDER BY sqkm_diff ASC
LIMIT 5;

--3.b Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016?
-- What was the percent change to decimal places for each?
SELECT country_name,
	   region,
       percent_diff
FROM country_table
ORDER BY percent_diff
LIMIT 5;

--3.c If countries were grouped by percent forestation in quartiles,
WITH quartiles_2016 AS
	(SELECT CASE
     	WHEN forest_percent <= 25 THEN 'Q1'
     	WHEN forest_percent >25 AND forest_percent <=50 THEN 'Q2'
     	WHEN forest_percent >50 AND forest_percent <=75 THEN 'Q3'
     	WHEN forest_percent >75 THEN 'Q4'
     END AS quartiles
     FROM forestation
     WHERE year = 2016 
        AND country_name != 'World'
        AND forest_percent IS NOT NULL)
SELECT quartiles, 
       count(*) AS quartile_count
FROM quartiles_2016
GROUP BY quartiles
ORDER BY quartiles;

-- which group had the most countires in 2016?
WITH quartiles_2016 AS
	(SELECT CASE
     	WHEN forest_percent <= 25 THEN 'Q1'
     	WHEN forest_percent >25 AND forest_percent <=50 THEN 'Q2'
     	WHEN forest_percent >50 AND forest_percent <=75 THEN 'Q3'
     	WHEN forest_percent >75 THEN 'Q4'
     END AS quartiles
     FROM forestation
     WHERE year = 2016 
        AND country_name != 'World'
        AND forest_percent IS NOT NULL)
SELECT quartiles, 
       count(*) AS quartile_count
FROM quartiles_2016
GROUP BY quartiles
ORDER BY quartile_count DESC 
LIMIT 1;
      
--3.d List all of the countires that were in the 4th quatile (percent forest > 75%) in 2016?
SELECT country_name,
       region,
       ROUND((forest_percent)::NUMERIC,2)AS forest_percent
FROM forestation
WHERE forest_percent > 75
        AND year = 2016
ORDER BY forest_percent DESC;

--3.e How many countries had higher percentage of land forested than the U.S. USING SELF JOIN?
SELECT COUNT(*) AS higher_than_us
FROM forestation a
JOIN forestation b 
	ON a.country_name = b.country_name
    AND a.year = b.year 
WHERE a.year = 2016 
	AND a.forest_percent >(SELECT forest_percent
                           FROM forestation
                           WHERE year = 2016 
                           AND country_name = 'United States')
  
-- Recommendations table
SELECT c.country_name,
       c.region,
       c.sqkm_diff,
       c.percent_2016,
       r.income_group
FROM country_table AS c
LEFT JOIN regions AS r
ON c.country_name = r.country_name
WHERE c.region = 'Sub-Saharan Africa'
ORDER BY sqkm_diff ASC
LIMIT 4;

-- total loss by this region? -787645.5737803 km
SELECT SUM(sqkm_diff) as sqkm_diff
FROM(SELECT country_name,
       region,
       sqkm_diff
FROM country_table
WHERE region = 'Sub-Saharan Africa') sub;

-- total forest lost by these four countries?
SELECT SUM(sqkm_diff) as sqkm_diff
FROM(SELECT country_name,
       region,
       sqkm_diff
FROM country_table
WHERE country_name = 'Nigeria'
     OR country_name = 'Tanzania'
     OR country_name = 'Zimbabwe'
     OR country_name ='Congo%')
     sub;

