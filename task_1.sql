/*НОВЫЕ КОММЕНТАРИИ от 22 сентября 2024*/

SELECT 
    (COUNT(DISTINCT id) FILTER (WHERE gasoline_consumption IS NULL) * 100.0) 
    / 
    COUNT(DISTINCT id) AS nulls_percentage_gasoline_consumption
FROM car_shop.model;

/*СТАРЫЕ КОММЕНТАРИИ от 19 сентября 2024*/
/*добавьте сюда запрос для решения задания 1*/

/*РЕШЕНИЕ. Запрос к финальной таблице*/

SELECT 
    (COUNT(DISTINCT id) FILTER (WHERE gasoline_consumption IS NULL) * 100.0) 
    / 
    COUNT(DISTINCT id) AS nulls_percentage_gasoline_consumption
FROM car_shop.car_specification cs;

/*Проверка с использованием столбца gasoline_consumption сырых данных (который потом удалила в конце работы)*/ 

SELECT 
    (COUNT(DISTINCT car_id) FILTER (WHERE gasoline_consumption IS NULL) * 100.0) 
    / 
    COUNT(DISTINCT car_id) AS nulls_percentage_gasoline_consumption
FROM car_shop.sales;

/* Ответ в обоих случаяхх 6.25 */
