CREATE TABLE t_natalie_nejedla_project_SQL_primary_final AS
--Mzdy
WITH upravena_data AS (
SELECT cp.value AS hodnota,
	cp.industry_branch_code::text AS kategorie,
	NULL::float8 AS hodnota_mnozstvi,
	cpu."name" AS jednotka,
	cp.calculation_code AS kod_kalkulace,
	1 AS typ_dat,
	cp.payroll_year AS rok,
	NULL::text AS nazev_potraviny
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code
WHERE value_type_code = 5958
UNION ALL
--Ceny
SELECT cp.value AS hodnota,
	cp.category_code::text AS kategorie,
	cpc.price_value::float8 AS hodnota_mnozstvi,
	cpc.price_unit AS jednotka,
	NULL::integer AS kod_kalkulace,
	2 AS typ_dat,
	date_part ('year', cp.date_from)::integer AS rok,
	cpc.name::text AS nazev_potraviny
FROM czechia_price cp 
LEFT JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
--HDP
UNION ALL
SELECT gdp AS hodnota,
	NULL::text AS kategorie,
	NULL::float8 AS hodnota_mnozstvi,
	NULL::varchar AS jednotka,
	NULL::integer AS kod_kalkulace,
	3 AS typ_dat,
	"year"::integer AS rok,
	NULL::text AS nazev_potraviny
FROM economies e 
WHERE country LIKE 'Czech Republic'
)
SELECT ud.hodnota,
	ud.kategorie ,
	ud.hodnota_mnozstvi ,
	ud.jednotka,
	ud.kod_kalkulace ,
	ud.rok,
	ud.typ_dat ,
	ud.nazev_potraviny ,
	cpib."name" AS nazev_odvetvi,
	cpc."name" AS nazev_kalkulace,
CASE
	WHEN typ_dat = 1 THEN 'Mzdy'
	WHEN typ_dat = 2 THEN 'Ceny'
	WHEN typ_dat = 3 THEN 'HDP'
END AS nazev_typu_dat
FROM upravena_data ud
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON ud.kategorie = cpib.code
LEFT JOIN czechia_payroll_calculation cpc 
	ON ud.kod_kalkulace = cpc.code;

--Společné roky -> poslední dotaz bych opět přetvořila na CTE a přidala další SELECT
--SELECT *
--FROM nazev posledniho CTE
--WHERE rok BETWEEN 2006 AND 2018;
