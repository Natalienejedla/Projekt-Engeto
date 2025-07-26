--Má výška HDP vliv na změny ve mzdách a cenách potravin? 
--Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
--mzdy
--/// Příprava pro výpočty ///
--Mzdy
CREATE VIEW prumer_mezd AS
SELECT AVG (hodnota) AS prumer_mezd, rok
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 1
AND rok BETWEEN 2006 AND 2018
GROUP BY rok;
--Ceny
CREATE VIEW prumer_cen AS
SELECT AVG (hodnota) AS prumer_cen, rok
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 2
AND rok BETWEEN 2006 AND 2018
GROUP BY rok;
--HDP
CREATE VIEW prumer_hdp AS 
SELECT AVG (hodnota) AS prumer_hdp, rok
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 3
AND rok BETWEEN 2006 AND 2018
GROUP BY rok;
--Průměry
CREATE VIEW view_prumeru AS
SELECT pm.rok, pm.prumer_mezd, pc.prumer_cen, ph.prumer_hdp
FROM prumer_mezd pm
LEFT JOIN prumer_cen pc
	ON pm.rok = pc.rok
LEFT JOIN prumer_hdp ph
	ON pc.rok = ph.rok;


--/// Samotný výpočet ///
CREATE VIEW souvislosti_v_danem_roce AS
WITH case_rozdilu AS (
SELECT *, vp.rok AS rok_max, vp2.rok AS rok_min,
(vp.prumer_mezd - vp2.prumer_mezd)/vp2.prumer_mezd * 100 AS rozdil_mezd_procent, 
(vp.prumer_cen -vp2.prumer_cen)/ vp2.prumer_cen *100 AS rozdil_cen_procent, 
(vp.prumer_hdp - vp2.prumer_hdp)/vp2.prumer_hdp * 100 AS rozdil_hdp_procent
FROM view_prumeru vp
LEFT JOIN view_prumeru vp2
	ON vp.rok = vp2.rok+1
),
final_souvislosti AS (
SELECT *,
CASE 
	WHEN rozdil_mezd_procent > 0 AND rozdil_hdp_procent > 0 THEN 'ANO'
	ELSE 'NE'
END AS souvislost_mzdy_hdp,
CASE
	WHEN rozdil_cen_procent > 0 AND rozdil_hdp_procent > 0 THEN 'ANO'
	ELSE 'NE'
END AS souvislost_cen_hdp
FROM case_rozdilu
)
SELECT rok_max, rok_min, souvislost_mzdy_hdp, souvislost_cen_hdp
FROM final_souvislosti;
SELECT *
FROM souvislosti_v_danem_roce;

--Souvislost ceny (jen přepsáno pro mzdy)
SELECT COUNT (souvislost_cen_hdp)
FROM souvislosti_v_danem_roce
WHERE souvislost_cen_hdp LIKE 'ANO' --7

SELECT COUNT (souvislost_cen_hdp)
FROM souvislosti_v_danem_roce
WHERE souvislost_cen_hdp LIKE 'NE'
AND rok_min is not null; --5


--///Pro část: ...pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách v následujícím roce výraznějším růstem?///
CREATE VIEW souvislosti_v_nasledujicim_roce AS
WITH prumery_stejny_rok AS (
SELECT pm.rok AS rok_mezd,
pm.prumer_mezd,
pc.rok AS rok_cen,
pc.prumer_cen,
ph.rok AS rok_hdp,
ph.prumer_hdp
FROM prumer_mezd pm
LEFT JOIN prumer_cen pc
	ON pm.rok = pc.rok
LEFT JOIN prumer_hdp ph
	ON pc.rok = ph.rok
),
self_join_rozdily AS (
SELECT psr2.rok_mezd AS rok_od, psr.rok_mezd AS rok_do,
(psr.prumer_mezd - psr2.prumer_mezd)/psr2.prumer_mezd * 100 AS rozdil_mezd_procent, 
(psr.prumer_cen -psr2.prumer_cen)/ psr2.prumer_cen *100 AS rozdil_cen_procent, 
(psr.prumer_hdp - psr2.prumer_hdp)/psr2.prumer_hdp * 100 AS rozdil_hdp_procent
FROM prumery_stejny_rok psr
JOIN prumery_stejny_rok psr2
	ON psr.rok_mezd = psr2.rok_mezd + 1
),
nasledujici_rok AS (
SELECT rok_do,
rozdil_mezd_procent,
rozdil_cen_procent, 
rozdil_hdp_procent AS hdp,
LEAD (rozdil_mezd_procent, 1 , NULL) OVER (ORDER BY rok_od) AS mzdy,
LEAD (rozdil_cen_procent, 1 , NULL) OVER (ORDER BY rok_od) AS ceny
FROM self_join_rozdily
),
finalni_data AS (
SELECT rok_do,
hdp,
mzdy, 
ceny,
CASE 
	WHEN mzdy > 0 AND hdp > 0 THEN 'ANO'
	WHEN mzdy IS NULL OR hdp IS NULL THEN NULL
	ELSE 'NE'
END AS souvislost_mzdy_hdp,
CASE
	WHEN ceny > 0 AND hdp > 0 THEN 'ANO'
	WHEN ceny IS NULL OR hdp IS NULL THEN NULL
	ELSE 'NE'
END AS souvislost_cen_hdp
FROM nasledujici_rok
)
SELECT rok_do AS rok, souvislost_mzdy_hdp, souvislost_cen_hdp
FROM finalni_data;


--Analogicky k první části
SELECT COUNT (souvislost_mzdy_hdp)
FROM souvislosti_v_nasledujicim_roce
WHERE souvislost_mzdy_hdp LIKE 'ANO' -- 8

SELECT COUNT (souvislost_mzdy_hdp)
FROM souvislosti_v_nasledujicim_roce
WHERE souvislost_mzdy_hdp LIKE 'NE'
AND rok is not null; --6
