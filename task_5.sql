/*НОВЫЕ КОММЕНТАРИИ от 22 сентября 2024*/

SELECT c.brand_origin AS brand_origin,
       ROUND(MAX((price * 100) / (100 - discount)), 2) AS price_max,
	   ROUND(MIN((price * 100) / (100 - discount)), 2) AS price_min
FROM car_shop.sales AS s
LEFT JOIN car_shop.car_specification AS cs ON s.car_id = cs.id
LEFT JOIN car_shop.model AS m ON cs.model_id = m.id
LEFT JOIN car_shop.brand AS b ON m.brand_id = b.id
LEFT JOIN car_shop.country AS c ON b.country_id = c.id
GROUP BY c.brand_origin;

/*СТАРЫЕ КОММЕНТАРИИ от 19 сентября 2024*/
/*добавьте сюда запрос для решения задания 5*/

/*РЕШЕНИЕ. Запрос к финальной таблице*/

SELECT cs.brand_origin AS brand_origin,
       MAX((price * 100) / (100 - discount)) AS price_max,
	   MIN((price * 100) / (100 - discount)) AS price_min
FROM car_shop.sales AS s
INNER JOIN car_shop.car_specification_possible AS csp ON s.car_id = csp.id
INNER JOIN car_shop.car_specification AS cs ON csp.car_specification_id = cs.id
GROUP BY cs.brand_origin;

/*Проверка с использованием столбца сырых данных brand_origin (которые потом удалила в конце)*/

SELECT brand_origin AS brand_origin,
       MAX((price * 100) / (100 - discount)) AS price_max,
	   MIN((price * 100) / (100 - discount)) AS price_min
FROM car_shop.sales
GROUP BY brand_origin;
