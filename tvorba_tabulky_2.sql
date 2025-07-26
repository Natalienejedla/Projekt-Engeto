CREATE TABLE t_natalie_nejedla_project_SQL_secondary_final AS
--JOIN
WITH tabulky_join AS (
SELECT e.country AS zeme, 
e.YEAR AS rok, 
c.continent, 
e.gdp AS hdp, 
e.population AS populace, 
e.gini AS gini
FROM economies e 
LEFT JOIN countries c
	ON e.country = c.country
),
--Doplnění Isle of Man a Kosovo
uprava_kontinentu AS (
SELECT *,
CASE
	WHEN continent = 'Europe' THEN 'Europe'
	WHEN zeme = 'Isle of Man' THEN 'Europe'
	WHEN zeme = 'Kosovo' THEN 'Europe'
	ELSE 'Non-Europe'
END AS kontinent_manualni
FROM tabulky_join
),
--Finální úprava pro Evropu
data_evropa AS (
SELECT *
FROM uprava_kontinentu
WHERE kontinent_manualni LIKE 'Europe'
)
SELECT zeme, 
rok, 
kontinent_manualni, 
AVG (HDP) AS hdp, 
AVG (populace) AS populace, 
AVG (gini) AS gini
FROM data_evropa
GROUP BY rok, zeme, kontinent_manualni ;
--Převod na společné roky - přidání podmínky WHERE rok BETWEEN 2006 AND 2018
