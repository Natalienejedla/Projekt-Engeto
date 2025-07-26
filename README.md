# Analýza vybraných ekonomických ukazatelů v čase – SQL projekt v rámci datové akademie od Engeta

## Popis projektu
Tento projekt vznikl v rámci kurzu datové analýzy. Jeho cílem bylo připravit datové podklady a nalézt odpovědi na předem vytyčené výzkumné otázky. Otázky se týkají dostupnosti základních potravin široké veřejnosti. Analýza probíhala v programu DBeaver, který pracoval s databází PostgreSQL dostupnou v rámci kurzu. Práce probíhala na lokální kopii databáze, poskytnuté v rámci kurzu. Analýza má především deskriptivní charakter. Byly využity základní SQL klauzule, zejména SELECT, JOIN, WHERE, GROUP BY apod. Data potřebná k analýze byla původně uložena v devíti tabulkách. Pro účely další práce byly vytvořeny dvě nové tabulky (viz dále).

## Výzkumné otázky
- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

## Struktura projektu
Najdete zde celkem sedm SQL skriptů. Dva se týkají vytváření tabulek, zbylých pět reprezentuje odpověď vždy na jednu výzkumnou otázku.
- pruvodni_listina.md – zde naleznete interpretaci veškerých výpočtů a reflexi vlastní práce.
- otazka_1
- otazka_2
- otazka_3
- otazka_4
- otazka_5
- tvorba_tabulky_1 – obsahuje cestu k vytvoření tabulky, ve které najdeme informace o mzdách, cenách a HDP.
- tvorba_tabulky_2 – skript pro sestavení tabulky s daty o HDP, GINI koeficientu a populaci evropských států.

## Hlavní zjištění
- V průběhu let mzdy rostou ve všech odvětvích
- V kontextu vybraných let kupní síla mezd roste
- Nejpomaleji zdražovaly banány (7 % nárůst v sledovaném období)
- V dostupných datech neexistuje rok, kdy by meziroční nárůst cen potravin byl výrazně vyšší než růst mezd (více než o 10 %)
- Zcela základní výpočty na našich datech ukazují, že by růst HDP mohl mít vliv na růst mezd a cen potravin 

## Reflexe
Celou tvorbu projektu doprovázela značná nejistota, protože jsem v oblasti programovacích jazyků naprostý začátečník. Jelikož se jednalo o můj první projekt tohoto typu, vnímám výrazné rezervy – zejména v jistotě při používání SQL klauzulí, při výpočtech a při pochopení i správném uchopení jednotlivých výzkumných otázek. Projekt mi však poskytl cennou zkušenost a zpětná vazba mi umožní se z tohoto výchozího bodu dále rozvíjet. Konkrétní chyby, nejasnosti v interpretaci zadání a další nedostatky, kterých jsem si vědoma, podrobněji popisuji v souboru pruvodni_listina.md.

Zde bych chtěla doplnit ještě jeden vědomý nedostatek. Veškeré názvy sloupců mám pojmenovány v češtině. Často to působí zvláštně, nicméně pro mě bylo velice důležité se v datech neztratit. Nyní, když se v datech lépe orientuji bych byla schopná pracovat s anglickými názvy.



