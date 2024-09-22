/*НОВЫЕ КОММЕНТАРИИ от 22 сентября 2024*/

SELECT b.brand AS brand_name,
       EXTRACT(YEAR FROM s.date) AS year,
	   ROUND(AVG(s.price), 2) AS price_avg
FROM car_shop.sales AS s
LEFT JOIN car_shop.car_specification AS cs ON s.car_id = cs.id
LEFT JOIN car_shop.model AS m ON cs.model_id = m.id
LEFT JOIN car_shop.brand AS b ON m.brand_id = b.id
GROUP BY brand_name, year
ORDER BY brand_name ASC, YEAR ASC;

/*СТАРЫЕ КОММЕНТАРИИ от 19 сентября 2024*/
/*добавьте сюда запрос для решения задания 2*/

/*РЕШЕНИЕ. Запрос к финальной таблице*/

SELECT cs.brand AS brand_name,
       EXTRACT(YEAR FROM s.date) AS year,
	   ROUND(AVG(s.price), 2) AS price_avg
FROM car_shop.sales AS s
INNER JOIN car_shop.car_specification_possible AS csp ON s.car_id = csp.id
INNER JOIN car_shop.car_specification AS cs ON csp.car_specification_id = cs.id
GROUP BY brand_name, year
ORDER BY brand_name ASC, YEAR ASC;

/*Проверка с использованием столбца сырых данных brand (который потом удалю в конце)*/

SELECT brand AS brand_name,
       EXTRACT(YEAR FROM date) AS year,
	   ROUND(AVG(price), 2) AS price_avg
FROM car_shop.sales
GROUP BY brand_name, year
ORDER BY brand_name ASC, year ASC;

/*Ответы совпали*/