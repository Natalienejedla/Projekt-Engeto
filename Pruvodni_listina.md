# Průvodní listina
V tomto dokumentu popisuji vytváření tabulek, interpretuji výsledky pro jednotlivé výzkumné otázky a reflektuji vlastní práci.

## Tvorba tabulek

### Tvorba tabulky 1
#### Můj postup
Vytvořila jsem tabulku s názvem t_natalie_nejedla_project_SQL_primary_final. Mým cílem bylo spojit informace ze tří tabulek. Jednalo se o tabulky obsahující informace o mzdách, cenách a HDP. Z těchto tabulek jsem vzala sloupce, které byly potřebné pro veškeré následné analýzy. Původním záměrem bylo využít klauzule LEFT JOIN. Avšak vzhledem k povaze zmiňovaných tabulek toto nebylo možné. Pokoušela jsem se tabulky k sobě připojit prostřednictvím sloupců obsahující roky. Spojení pouze na základě roku ale nebylo dostačující pro správné propojení záznamů. Výsledkem byl prakticky kartézský součin a tedy obrovské množství řádků. 
Zvolila jsem proto klauzuli UNION ALL. Musela jsem tedy zajistit, aby každá tabulka měla stejný počet sloupců. To nebylo vždy možné standardní cestou. Zařadila jsem tedy i sloupce, pro které v jiných tabulkách nebyly hodnoty. V těchto tabulkách jsem pak prostřednictvím SELECT takový sloupec zařadila a vyplnila jej hodnotami NULL. Dále byla potřeba ošetřit datové typy. Každý sloupec, který měl být součástí výsledné tabulky jsem přetypovala podle potřeby. Například sloupec *kategorie* čerpal z tabulky mezd, kde byl textovým typem, v tabulce o cenách to byl pak integer. Finální sloupec *kategorie* jsem tak přetypovala na text. Následně byla potřeba vytvořit další sloupec, díky kterému bude jasné, jestli se jedná o hodnoty z tabulky mezd, cen či HDP. Vytvořila jsem sloupec *typ_dat*, ve kterém jsem zdroj dat okódovala:
- 1 pro mzdy
- 2 pro ceny
- 3 pro HDP
Týto kódy jsem pak ještě doplnila právě o slovní popis v následujícím sloupci. Primárně byla čísla užita pro přesnost ve výpočtech.
#### Reflexe
Domnívám se, že jsem se v tomto případě částečně odchýlila od zadání, které požadovalo sjednotit data o mzdách a cenách potravin za Českou republiku na společné, porovnatelné období – tedy pracovat pouze s roky, které se vyskytují v obou tabulkách. Přesnějším řešením by pravděpodobně bylo sloučit pouze tabulku cen a tabulku mezd. V takovém případě by bylo možné použít klauzuli LEFT JOIN, jelikož obě tabulky obsahovaly navíc také údaj o kvartálu. Kombinace roku a kvartálu by poskytla dostatečný základ pro spojení bez vzniku kartézského součinu. Já jsem se však rozhodla připojit i informace o HDP, protože byly potřebné k vyhodnocení poslední výzkumné otázky. Připadalo mi smysluplné mít všechny potřebné údaje pohromadě v jedné tabulce. Vzhledem k tomu, že spojení přes JOIN nebylo možné, zvolila jsem přístup pomocí UNION ALL a zachovala tak i roky, které by jinak musely být vyloučeny kvůli absenci v některé z tabulek. Ani v následných analýzách nepracuji s jednotnou sadou roků – pokud to není vysloveně nutné, pracuji vždy s maximálním možným rozsahem dostupných měření. Větší množství pozorování podle mého názoru přináší více informací a nechtěla jsem se o ně připravit. Uvědomuji si, že tímto přístupem nesplňuji zadání zcela přesně. Pokud se ukáže, že mé úvahy byly nepřesné nebo nevhodné, ráda vše upravím při opravě projektu.

### Tvorba tabulky 2
#### Můj postup
Vytvořila jsem tabulky s názvem t_natalie_nejedla_project_SQL_secondary_final. Cílem bylo sloučit tabulky tak, aby výsledná data obsahovala pouze vybrané ukazatele pro evropské státy. V tabulce s ekonomickými ukazateli nebyl sloupec kontinent a tak jej byla potřeba doplnit z tabulky druhé. 
Při použití klasického LEFT JOINu zůstalo přibližně 70 záznamů bez informace o kontinentu (kontinent = NULL). Tyto jsem manuálně prošla. Rozhodla jsem se do finální tabulky nezahrnout údaje typu 'low income' apod. Byly odhaleny evropské státy, které měly ve sloupci kontinent NULL. Jednalo se o Kosovo a Isle of Man. Proto jsem skrze CASE vytvořila nový sloupec, kde jsem doplnila kontinent pro tyto státy.
#### Reflexe
Ani zde jsem neřešila případné vymezené období z důvodu snahy předejít ztrátě potenciálně důležitých dat. V tomto případě však v zadání nebylo toto explicitně požadováno. Řešení chybějících hodnot přes CASE mi nepřipadá přílíš elegantní, nicméně jednoznačně lepší, než data přímo v tabulkách přepsat. Ani to nebylo možné kvůli absenci primárního klíče.

## Výzkumné otázky

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
#### Interpretace
Provedené analýzy ukazují, že trend mezd v průběhu času je jednoznačně stoupající ve všech odvětvích.

**První dotaz** - zobrazení rozdílu mezi průměrnou mzdou z roku 2000 a 2021 (čili první a poslední měřitelné období) pro každé odvětví. Veškeré hodnoty jsou kladné, v žádném odvětví tedy mzdy neklesaly. Nejmenší nárůst mzdy (o 12952,75) pozorujeme v sektoru I - ubytování, stravování a pohostinství. Největší nárůst mzdy (o 42331,75) byl přítomný v odvětví J - informační a komunikační činnosti.

**Druhý dotaz** - výpočet korelace mzdy s časem. Ve všech odvětvích se ukázala velmi silná pozitivní korelace ( r > 0,80). Hodnoty korelace naznačují velmi silný a stabilní vzestupný trend. Čím novější rok, tím vyšší byla průměrná mzda. 

**Třetí dotaz** - zobrazení meziročních rozdílů v mzdách v každém odvětví. Zde se můžeme podívat, mezi kterými lety došlo například k poklesu průměrných mezd v rámci odvětví. Můžeme vidět, že opravdu v žádném odvětví nedocházelo k zásadním propadům v mzdách (nejvyšší propad -2150,25 a to je mírný outlier). Zajímavé je, že v oblasti C -zpracovatelský průmysl a Q -zdravotní a sociální péče, nedošlo v žádném měřeném roce k jakémukoli propadu. Mzda v jejich případě opravdu byla každý rok o něco vyšší a vyšší.
#### Reflexe
Zde možná uvedeno mnoho řešení této otázky. Pro nalezení odpovědi na otázku ve smyslu uzavřené odpovědi Ano / Ne by postačil buď první nebo druhý dotaz. Nicméně vyhodnocení všech tří mi připadá, že nám poskytuje komplexní obraz. Používala jsem pouze mzdy "přepočtené", jelikož mi připadalo, že například hodnoty ze zkrácených uvazků by mohly mírně zkreslovat výsledky. 

### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
#### Interpretace
V prvním období (v roce 2006) bylo možné si koupit 1257 kg chleba a 1404 l mléka za průměrnou mzdu. Ve druhém období (v roce 2018) bylo možné si koupit 1317 kg chleba a 1611 l mléka za průměrnou mzdu. Z uvedených údajů vyplývá, že v těchto konkrétních případech se kupní síla mzdy zlepšila. V roce 2018 bylo možné za průměrnou mzdu koupit více chleba i mléka než v roce 2006
#### Reflexe
Na závěr možná nadbytečně uvedena kontrola jednotek. 
Zde jsem naopak od první otázky pracovala s nepřepočtenými mzdami. Tento přístup mi v této otázce připadal přesnější pro zachycení reality.

### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
#### Interpretace
Nejmenší procentuální rozdíl byl zaznamenán u banánů žlutých. Mezi lety 2006 a 2018 cena banánů vzrostla o 7,39 %. 
#### Reflexe
Rozhodla jsem se porovnat pouze ceny v prvním a posledním sledovaném období. Tento přístup mi připadal nejpřehlednější a nejsrozumitelnější. Uvědomuji si však, že tímto způsobem nepočítám skutečný meziroční nárůst, jak bylo uvedeno v zadání, ale spíše celkovou změnu mezi dvěma body v čase.

### 4.Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
#### Interpretace
Ve sledovaném období neexistuje žádný rok, ve kterém by byl meziroční nárůst cen potravin vyšší o více než 10 procentních bodů oproti růstu mezd. Největší rozdíl byl zaznamenán mezi lety 2012 a 2013, kdy růst cen převýšil růst mezd o 7,04 %
#### Reflexe
Zde jsem nevěděla, jak výsledky na závěr zobrazit. Nechala jsem tedy 2 dotazy. Jeden, kde se můžeme na tyto rozdíly podívat. Druhý, který vrací prázdnou tabulku – ta jednoznačně implikuje zápornou odpověď.

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
#### Interpretace
**První část** - sleduje souvislost mezi růstem HDP a růstem mezd nebo cen ve stejném roce. Za souvislost jsem považovala situaci, kdy v roce s kladným meziročním růstem HDP zároveň rostly i mzdy nebo ceny. Výsledky byly zaznamenány ve sloupcích souvislost_mzdy_hdp a souvislost_cen_hdp.
- Kladný meziroční nárůst mezd a HDP byl zaznamenán v 9 případech z 12 
- Kladný meziroční nárůst cen a HDP byl zaznamenán v 7 případech z 12
**Druhá část** - týká se vlivu následujícího roku. Tedy pokud vzroste HDP v jednom roce, projeví se to na cenách v druhém roce. Analogické pro první část.
- Kladný meziroční nárůst mezd a HDP byl zaznamenán v 8 případech z 11
- Kladný meziroční nárůst cen a HDP byl zaznamenán v 5 případech z 11
#### Reflexe
Tato otázka pro mne byla opravdovým oříškem. Slovo "vliv" v otázce mě vedlo na korelaci. Vytvořila jsem si tedy 3 view, kde jsem zprůměrovala hodnoty tak, abych měla vždy jednu hodnotu mzdy, cen a HDP pro každý rok ve společném rozptylu 2006 až 2018. Následně jsem provedla korelaci pro mzdy a HDP a ceny a HDP. Až po několikáté kontrole mi došlo, že operuji s agregovanými hodnotami, čili do výpočtu korelace uvažuji proměnné, které mají pouze 13 záznamů, což pro korelaci nebude dostatečně validní. Prohlížela jsem data před agregací a zkoumala, zdali by to šlo spočítat na původních datech. Ani to nebylo nijak proveditelné. Nenapadl mě žádný statistický výpočet, jak si s tímto poradit a znovu studovat stará skripta jsem pro tentokrát odložila. Pokusila jsem se tedy vytvořit řešení, které je čistě popisem, jak se to v datech jeví. Ta dle mého ukazuje, že by tam nějaký vliv mohl být, ale potvrdit či vyvrátit by se dal pouze na základě lepší metody či postupu, avšak ty jsou mi v současnosti neznámy. 
