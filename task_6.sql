/*добавьте сюда запрос для решения задания 6*/

/*РЕШЕНИЕ. Запрос к финальной таблице*/

SELECT COUNT(DISTINCT id) AS persons_from_usa_count
FROM car_shop.person
WHERE phone LIKE '+1%';

/*Проверка с использованием столбца сырых данных person (которые потом удалю в конце)*/

SELECT COUNT(DISTINCT person) AS persons_from_usa_count
FROM car_shop.sales
WHERE phone LIKE '+1%';

/* По обоим вариантам ответ 131 человек*/
