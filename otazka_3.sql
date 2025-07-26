--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
WITH agregovane_ceny AS (
SELECT AVG (hodnota) AS prumerna_cena, kategorie, hodnota_mnozstvi , jednotka, rok, nazev_potraviny
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 2
GROUP BY kategorie, hodnota_mnozstvi , jednotka, rok, nazev_potraviny
),
data_pred_final_zobrazenim AS (
SELECT ac2.rok AS rok_min, ac2.prumerna_cena, ac.rok AS rok_max, ac.prumerna_cena, ((ac.prumerna_cena - ac2.prumerna_cena)/ac2.prumerna_cena) * 100 AS  rozdil_procent, ac.kategorie, ac.hodnota_mnozstvi , ac.jednotka, ac.nazev_potraviny
FROM agregovane_ceny ac
JOIN agregovane_ceny ac2
	ON ac.rok = ac2.rok+12
	AND ac.kategorie = ac2.kategorie
)
SELECT kategorie, nazev_potraviny, MIN (ROUND ((rozdil_procent)::numeric, 2)) AS nejmensi_rozdil_procent
FROM data_pred_final_zobrazenim
WHERE rozdil_procent >0
GROUP BY nazev_potraviny, kategorie
ORDER BY nejmensi_rozdil_procent ASC
LIMIT 1;



