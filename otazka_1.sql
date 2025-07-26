--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
--1. Obecný trend
WITH upravena_data AS (
SELECT rok, kategorie, AVG (hodnota) AS prumerna_hodnota, nazev_odvetvi 
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 1
AND kod_kalkulace = 200
GROUP BY kategorie , rok , nazev_odvetvi
),
upravena_data_pro_operace AS (
SELECT ud.rok, ud.kategorie, ud.prumerna_hodnota AS hodnota_2021 , ud2.rok, ud2.kategorie AS kategorie_2, ud2.prumerna_hodnota AS hodnota_2000, ud.nazev_odvetvi 
FROM upravena_data ud
JOIN upravena_data ud2
	ON ud.rok = ud2.rok + 21
	AND ud.kategorie = ud2.kategorie
)
SELECT kategorie, nazev_odvetvi, hodnota_2021 - hodnota_2000 AS rozdil
FROM upravena_data_pro_operace
ORDER BY rozdil;


--2. Lepší způsob analýzy obecného trendu - korelace s časem
SELECT kategorie, nazev_odvetvi , corr(hodnota, rok) AS korelace
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 1
AND kod_kalkulace = 200
AND kategorie  IS NOT NULL
GROUP BY kategorie, nazev_odvetvi
ORDER BY kategorie ASC;

--3. Rozpad rozdílů pro samostatné roky
WITH upravena_data AS (
SELECT rok, kategorie, AVG (hodnota) AS prumerna_hodnota, nazev_odvetvi 
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 1
AND kod_kalkulace = 200
GROUP BY kategorie , rok , nazev_odvetvi
),
upravena_data_pro_operace AS (
SELECT ud.rok AS rok_max,
ud.kategorie, 
ud.prumerna_hodnota AS hodnota_pozdejsi , 
ud2.rok AS rok_min, 
ud2.kategorie AS kategorie_2, 
ud2.prumerna_hodnota AS hodnota_drivejsi, 
ud.nazev_odvetvi 
FROM upravena_data ud
JOIN upravena_data ud2
	ON ud.rok = ud2.rok + 1
	AND ud.kategorie = ud2.kategorie
)
SELECT kategorie, nazev_odvetvi ,rok_max, rok_min, hodnota_pozdejsi - hodnota_drivejsi AS rozdil
FROM upravena_data_pro_operace
WHERE hodnota_pozdejsi - hodnota_drivejsi < 0;








	
	
	
	
	
	