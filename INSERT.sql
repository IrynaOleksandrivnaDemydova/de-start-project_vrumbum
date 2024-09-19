/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме автосалона*/

/*Наполнение таблицы цветов машин color сырыми данными*/

INSERT INTO car_shop.color (color)
SELECT DISTINCT TRIM(SPLIT_PART(auto, ',', 2)) AS color
FROM raw_data.sales
ORDER BY color;

/*Наполнение таблицы person с данными клиентов*/

INSERT INTO car_shop.person (person, phone)
SELECT person, phone
FROM raw_data.sales
GROUP BY person, phone
ORDER BY person, phone;

/*Наполнение таблицы car_specification с данными машин*/

INSERT INTO car_shop.car_specification (brand, model, brand_origin, gasoline_consumption)
SELECT SPLIT_PART(auto, ' ', 1) AS brand, 
       REPLACE(SPLIT_PART(auto, ' ', 2), ',', '') AS model,
       brand_origin,
       gasoline_consumption
FROM raw_data.sales
GROUP BY brand, model, brand_origin, gasoline_consumption
ORDER BY brand, model, brand_origin, gasoline_consumption;

/*Наполнение таблицы car_specification_possible всеми возможными комбинациями спецификаций машин и цветов*/

INSERT INTO car_shop.car_specification_possible (car_specification_id, color_id)
SELECT car_specification.id, color.id
FROM car_shop.car_specification AS car_specification
CROSS JOIN car_shop.color AS color;

/*Наполнение таблицы car_sales сырыми данными по продажам. После заполнения сырыми данными этой таблицы
и после проведения анализов (task_1...6) я удалила не нужные столбцы (код в конце файла DDL.sql и этого файла)*/

INSERT INTO car_shop.sales (brand, model, color, gasoline_consumption, price, date, person, phone, discount, brand_origin)
SELECT 
    SPLIT_PART(auto, ' ', 1) AS brand, 
    REPLACE(SPLIT_PART(auto, ' ', 2), ',', '') AS model, 
	TRIM(SPLIT_PART(auto, ',', 2)) AS color,
    gasoline_consumption, 
    price,  
    date,  
    person,  
    phone, 
    discount,
    brand_origin  
FROM raw_data.sales

/*Наполнение таблицы sales нормализованными данными из таблицы person*/

UPDATE car_shop.sales
SET person_id = person.id
FROM car_shop.person
WHERE car_shop.sales.person = car_shop.person.person
	  AND car_shop.sales.phone = car_shop.person.phone;
	  
/*Проверка наполнения таблицы car_sales нормализованными данными из таблицы person,
все строки в столбце person_id заполнены*/

SELECT *
FROM car_shop.sales
WHERE person_id IS NULL;

/*Наполнение таблицы sales нормализованными данными из таблицы car_specification_possible*/

UPDATE car_shop.sales
SET car_id = car_specification_possible.id
FROM car_shop.car_specification_possible
INNER JOIN car_shop.color ON car_specification_possible.color_id = color.id
INNER JOIN car_shop.car_specification ON car_specification_possible.car_specification_id = car_specification.id
WHERE car_shop.sales.color = car_shop.color.color
	  AND car_shop.sales.brand = car_shop.car_specification.brand
	  AND car_shop.sales.model = car_shop.car_specification.model
	  AND (
			car_shop.sales.brand_origin = car_shop.car_specification.brand_origin 
			OR 
			(car_shop.sales.brand_origin IS NULL AND car_shop.car_specification.brand_origin IS NULL))
	  AND (
			car_shop.sales.gasoline_consumption = car_shop.car_specification.gasoline_consumption 
			OR 
			(car_shop.sales.gasoline_consumption IS NULL AND car_shop.car_specification.gasoline_consumption IS NULL));	  
	  
/*Проверка наполнения таблицы sales нормализованными данными из таблицы car_specification_possible,
все строки в столбце car_id заполнены*/*/

SELECT *
FROM car_shop.sales
WHERE car_id IS NULL;

/*Удаление из car_shop.sales столбцов сырых данных которые нам больше не нужны, а именно:

-- person, phone - нормализованные данные есть в таблице person, а в car_shop.sales остается person_id
-- color - нормализованные данные есть в таблице color и car_specification_possible (color_id)
-- brand, model, brand_origin, gasoline_consumption - нормализованные данные 
есть в таблице car_specification (id) и car_specification_possible (car_specification_id)*/

ALTER TABLE car_shop.sales
DROP COLUMN person,
DROP COLUMN phone,
DROP COLUMN color,
DROP COLUMN brand,
DROP COLUMN model,
DROP COLUMN brand_origin,
DROP COLUMN gasoline_consumption;