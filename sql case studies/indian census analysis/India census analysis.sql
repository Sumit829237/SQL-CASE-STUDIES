USE SUMIT_DB;
SELECT * FROM growth;
SELECT * FROM population;
/* total rows in datasets*/
SELECT COUNT(*) FROM growth;
SELECT COUNT(*) FROM population;

/*INSIGHTS FOR 'BIHAR' AND 'JHARKHAND'*/
SELECT * FROM GROWTH
WHERE State IN ('BIHAR', 'JHARKHAND');

/* TOTAL DATASETS INSIGHTS FOR 'BIHAR' AND 'JHARKHAND'*/
SELECT COUNT(*) FROM GROWTH
WHERE State IN ('BIHAR', 'JHARKHAND');

/*DISTRICT AND STATES*/
SELECT DISTRICT, STATE FROM GROWTH;

/*TOTAL COUNT OF DISTRICTS AND STATES*/
SELECT count(*) FROM GROWTH
WHERE DISTRICT = 'BANKA';

SELECT count(*) FROM GROWTH
WHERE STATE = 'BIHAR';

/*ALL STATES PRINT  DISTINCT*/
SELECT distinct STATE FROM GROWTH;
SELECT distinct DISTRICT FROM GROWTH
WHERE DISTRICT = 'SIWAN';

SELECT * FROM population
WHERE population='2583052' AND STATE = 'RAJASTHAN';

/*ORDERING OF STATES*/
SELECT * FROM population
order by STATE;

/* ALL THE STATES  NAME STARTING WITH A*/
SELECT distinct STATES FROM population
WHERE STATES LIKE 'A%';


/*Total population of India*/ 
SELECT sum(population) AS TOTAL_POPULATION
FROM population;

-- Average growth of India in the year 2011

SELECT ROUND(AVG(growth)*100, 2) AS Average_Growth 
FROM growth; 

-- Average growth percentage for each state

SELECT state, ROUND(AVG(growth)*100, 2) AS Average_Growth 
FROM growth 
GROUP BY state;

-- Average Sex Ratio for each state 

SELECT state, ROUND(AVG(sex_ratio),2) AS Average_SexRatio 
FROM growth 
GROUP BY state
ORDER BY state;

-- Average literacy rate for each state 

SELECT state, ROUND(AVG(literacy),2) AS Average_LiteracyRate 
FROM growth 
GROUP BY state
ORDER BY Average_LiteracyRate DESC ;

-- Top 5 states displaying highest growth percentage ratio 

SELECT state, ROUND(AVG(growth)*100, 2) AS Average_Growth 
FROM growth 
GROUP BY state
ORDER BY Average_Growth DESC
LIMIT 5;

-- 5 states showing Least Sex Ratio

SELECT state, ROUND(AVG(sex_ratio),2) AS Average_SexRatio 
FROM growth 
GROUP BY state
ORDER BY Average_SexRatio
LIMIT 5;


-- fetch Top and Bottom 3 states for literacy rate in a single result set 

SELECT * FROM (SELECT state, ROUND(AVG(literacy),2) AS Average_LiteracyRate 
FROM growth 
GROUP BY state
ORDER BY Average_LiteracyRate DESC 
LIMIT 3 ) A 
UNION 
SELECT * FROM (
SELECT state, ROUND(AVG(literacy),2) AS Average_LiteracyRate 
FROM growth 
GROUP BY state
ORDER BY Average_LiteracyRate ASC
LIMIT 3 ) B ;

-- total number of males and females from the census data 

SELECT c.district, c.state , ROUND(c.population/(c.sex_ratio + 1), 0) AS males, ROUND((c.population*c.sex_ratio)/(c.sex_ratio+1),0) AS females 
FROM(
SELECT g.district, g.state, g.sex_ratio/1000 as sex_ratio, p.population 
FROM growth g 
INNER JOIN population p 
ON g.district = p.district ) c ;

-- Total no of people who are literate from the population in each state 

SELECT d.state, SUM(d.Literate_people) AS total_literates FROM
(select c.district, c.state, ROUND(c.literacy_ratio*c.population,0) as Literate_people FROM
(SELECT g.district, g.state, g.literacy/100 as literacy_ratio, p.population 
FROM growth g 
INNER JOIN population p 
ON g.district = p.district) c ) d
GROUP BY state;

-- Population in previous census 

SELECT c.district,c.state,ROUND(c.population/(1+ c.growth_rate),0) AS prev_census_Population, c.population AS curr_Census_population FROM 
(SELECT g.district, g.state, g.growth as growth_rate, p.population 
FROM growth g 
INNER JOIN population p 
ON g.district = p.district) c ;

-- Find out the top 3 district from each states having high literacy ratio

SELECT a.* FROM
(SELECT state, district, Literacy, 
DENSE_RANK() OVER(partition by state order by literacy desc) as rnk
FROM growth ) a
WHERE a.rnk <= 3;