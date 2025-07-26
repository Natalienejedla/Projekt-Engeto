--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
CREATE VIEW view_cen AS
WITH agregovane_ceny AS (
SELECT AVG (hodnota) AS prumerna_cena, rok
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 2
GROUP BY rok
)
SELECT ac2.rok AS rok_min, ac.rok AS rok_max, ((ac.prumerna_cena - ac2.prumerna_cena)/ac2.prumerna_cena) * 100 AS  rozdil_procent_cen
FROM agregovane_ceny ac
LEFT JOIN agregovane_ceny ac2
	ON ac.rok = ac2.rok+1
ORDER BY rok_min ASC, rok_max ASC;

CREATE VIEW view_mezd AS
WITH agregovane_mzdy AS (
SELECT AVG (hodnota) AS prumerna_mzda, rok
FROM t_natalie_nejedla_project_SQL_primary_final
WHERE typ_dat = 1
AND kod_kalkulace = 200
AND rok BETWEEN 2006 AND 2018
GROUP BY rok
)
SELECT am2.rok AS rok_min, am.rok AS rok_max, ((am.prumerna_mzda - am2.prumerna_mzda)/am2.prumerna_mzda) * 100 AS  rozdil_procent_mezd 
FROM agregovane_mzdy am
LEFT JOIN agregovane_mzdy am2
	ON am.rok = am2.rok+1
ORDER BY rok_min ASC, rok_max ASC;

SELECT vc.rok_min,
vc.rok_max,
vc.rozdil_procent_cen,
vm.rozdil_procent_mezd,
vc.rozdil_procent_cen - vm.rozdil_procent_mezd AS rozdil_procent_cen_mezd
FROM view_cen vc
JOIN view_mezd vm
	ON vc.rok_min = vm.rok_min
	AND vc.rok_max = vm.rok_max;
--/// Připadá mi logické, v tomto bodě skončit. Na první pohled vidím, že nikde rozdíl větší než 10 není. 
--/// V případě, že by výsledkem bylo velké množství řádků, finální část bych provedla takto:

SELECT vc.rok_min, 
vc.rok_max, vc.rozdil_procent_cen, 
vm.rozdil_procent_mezd, 
vc.rozdil_procent_cen - vm.rozdil_procent_mezd AS rozdil_cen_mezd
FROM view_cen vc
JOIN view_mezd vm
	ON vc.rok_min = vm.rok_min
	AND vc.rok_max = vm.rok_max
WHERE vc.rozdil_procent_cen - vm.rozdil_procent_mezd > 10;

--Tady již vidíme prázdnou tabulku - opravdu nikde náůst tak vysoký nebyl.