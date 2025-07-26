--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
--Výpočet kupní síly - mzda/potravina = výsledek // společné roky ceny a mezd 2006 až 2018
WITH ceny AS (
--Hodnota mléka a chleba 2006, 2018
SELECT rok, kategorie, AVG (hodnota) AS cena, nazev_potraviny, hodnota_mnozstvi , jednotka 
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 2
AND rok IN (2006, 2018)
AND kategorie IN ('114201', '111301')
GROUP BY rok, kategorie, nazev_potraviny, hodnota_mnozstvi , jednotka 
),
-- Mzda v roce 2006 a 2018
mzdy AS (
SELECT rok, AVG (hodnota) AS mzda
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 1
AND rok IN (2006, 2018)
AND kod_kalkulace = 100
GROUP BY rok
),
ceny_a_mzdy AS (
SELECT c.rok, c.kategorie, c.cena, m.mzda, c.nazev_potraviny, c.hodnota_mnozstvi, c.jednotka
FROM ceny c
JOIN mzdy m
	ON c.rok = m.rok
)
SELECT rok, kategorie, nazev_potraviny, ROUND (mzda/cena)  AS kupni_sila, hodnota_mnozstvi , jednotka 
FROM ceny_a_mzdy
ORDER BY rok; 


--/// Kontrola jednotnosti jednotek
SELECT DISTINCT nazev_potraviny ,hodnota_mnozstvi , jednotka 
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE kategorie IN ('114201', '111301');

