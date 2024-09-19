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