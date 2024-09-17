--- Combien de médailles de chaque type ont été attribuées ?
SELECT 
	medal_type
    , COUNT(medal_type) as medals_nb
FROM medals
GROUP BY medal_type
ORDER BY medals_nb DESC

--- Quelle est la date de la première médaille remportée dans chaque discipline ?
SELECT
	discipline
    , MIN(medal_date) AS first_medal
FROM medals
GROUP by discipline
ORDER BY first_medal ASC

--- Quels sont les 5 événements ayant distribué le plus de médailles ?
SELECT 
	event
    , COUNT(medal_code) AS medals_nb
FROM medals
GROUP BY event
ORDER BY medals_nb DESC
LIMIT 5

--- Combien de médailles ont été remportées par les athlètes masculins et féminins respectivement ?
SELECT
	gender
    , COUNT(medal_type) AS medals_nb
FROM medals
GROUP BY gender
ORDER BY medals_nb DESC

--- Quels sont les pays ayant remporté des médailles d'or et combien en ont-ils gagné ?
SELECT
	country
    , COUNT(medal_type) AS medals_nb
FROM medals
WHERE medal_type = 'Gold Medal'
GROUP BY country
ORDER BY medals_nb DESC

--- Quels athlètes ont remporté le plus de médailles dans une seule discipline ?
SELECT
	name
    , discipline
    , COUNT(medal_type) AS medals_nb
FROM medals
WHERE name != country ---to avoid team events
GROUP BY name, discipline
ORDER BY medals_nb DESC

--- Quels pays ont remporté des médailles dans plus de 3 disciplines différentes ?
SELECT
	country
    , COUNT(DISTINCT discipline) AS discipline_nb
FROM medals
GROUP BY country
HAVING discipline_nb > 2
ORDER BY discipline_nb DESC

--- Affiche une liste des pays et indique "Beaucoup de médailles" si un pays a gagné plus de 10 médailles, et "Peu de médailles" s'il en a gagné 10 ou moins.
SELECT
	country
    , COUNT(medal_type) as medals_nb
    , CASE
    	WHEN COUNT(medal_type) > 9 THEN 'Many medals'
        WHEN COUNT(medal_type) > 2 THEN 'Few medals'
        WHEN COUNT(medal_type) = 1 THEN 'One medal'
        ELSE 'No medals'
      End AS medals_category
FROM medals
GROUP BY country
ORDER BY medals_nb DESC

--- Quel est le nombre moyen de médailles par pays ?
WITH medals_count AS
	(SELECT 
     	country
     	, COUNT(medal_type) AS medals_nb
     FROM medals
     GROUP BY country)
SELECT AVG(medals_nb)
FROM medals_count
     
--- Quelle est la médaille la plus courante pour chaque pays, et quel est le nombre total de médailles pour chaque pays ?     
WITH country_medals AS (
    SELECT country, medal_type, COUNT(medal_type) AS medals_nb
    FROM medals
    GROUP BY country, medal_type
)
SELECT country, medal_type, medals_nb
FROM (
    SELECT country, medal_type, medals_nb,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY medals_nb DESC) AS rank
    FROM country_medals
) ranked_medals
WHERE rank = 1
ORDER BY medals_nb DESC
     
