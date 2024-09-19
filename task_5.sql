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
