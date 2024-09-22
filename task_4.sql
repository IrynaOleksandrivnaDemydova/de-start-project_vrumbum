/*НОВЫЕ КОММЕНТАРИИ от 22 сентября 2024*/

SELECT p.person,
       STRING_AGG(b.brand || ' ' || m.model, ', ') AS cars
FROM car_shop.sales AS s
LEFT JOIN car_shop.car_specification AS cs ON s.car_id = cs.id
LEFT JOIN car_shop.model AS m ON cs.model_id = m.id
LEFT JOIN car_shop.brand AS b ON m.brand_id = b.id
LEFT JOIN car_shop.person AS p ON s.person_id = p.id
GROUP BY p.person
ORDER BY p.person ASC;

/*СТАРЫЕ КОММЕНТАРИИ от 19 сентября 2024*/
/*добавьте сюда запрос для решения задания 4*/

/*РЕШЕНИЕ. Запрос к финальной таблице*/

SELECT p.person,
       STRING_AGG(cs.brand || ' ' || cs.model, ', ') AS cars
FROM car_shop.sales AS s
INNER JOIN car_shop.car_specification_possible AS csp ON s.car_id = csp.id
INNER JOIN car_shop.car_specification AS cs ON csp.car_specification_id = cs.id
INNER JOIN car_shop.person AS p ON s.person_id = p.id
GROUP BY p.person
ORDER BY p.person ASC;

/*Проверка с использованием столбца сырых данных person, brand, model (которые потом удалила в конце работы)*/

SELECT person,
       STRING_AGG(brand || ' ' || model, ', ') AS cars
FROM car_shop.sales
GROUP BY person
ORDER BY person ASC;