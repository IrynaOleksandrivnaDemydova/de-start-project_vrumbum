/*НОВЫЕ КОММЕНТАРИИ от 22 сентября 2024*/

/*Наполнение таблицы стран country*/

INSERT INTO car_shop.country (brand_origin)
SELECT DISTINCT COALESCE(brand_origin, 'Unknown')
FROM raw_data.sales
ORDER BY COALESCE(brand_origin, 'Unknown');

/*Наполнение таблицы брэндов brand, кроме поля country_id*/

INSERT INTO car_shop.brand (brand)
SELECT DISTINCT SPLIT_PART(auto, ' ', 1) AS brand
FROM raw_data.sales
ORDER BY brand;

/*Наполнение поля country_id таблицы брэндов brand*/

WITH temporary_table_1 AS (
   SELECT DISTINCT SPLIT_PART(auto, ' ', 1) AS brand,
          COALESCE(brand_origin, 'Unknown')  AS country
   FROM raw_data.sales
),
temporary_table_2 AS (
   SELECT t.brand, t.country, c.id
   FROM temporary_table_1 AS t
   RIGHT JOIN car_shop.brand AS b ON t.brand = b.brand
   LEFT JOIN car_shop.country AS c ON t.country = c.brand_origin
)
UPDATE car_shop.brand
SET country_id = temporary_table_2.id
FROM temporary_table_2
WHERE car_shop.brand.brand = temporary_table_2.brand;

/*Наполнение таблицы моделей model, кроме поля brand_id*/

INSERT INTO car_shop.model (model, gasoline_consumption)
SELECT REPLACE(SPLIT_PART(SPLIT_PART(auto, ' ', 2) || ' ' || SPLIT_PART(auto, ' ', 3), ', ', 1), ',', '') AS model,
       gasoline_consumption
FROM raw_data.sales
GROUP BY model, gasoline_consumption;

/*Наполнение поля brand_id таблицы моделей model*/

WITH temporary_table_1 AS (
   SELECT DISTINCT SPLIT_PART(auto, ' ', 1) AS brand,
          REPLACE(SPLIT_PART(SPLIT_PART(auto, ' ', 2) || ' ' || SPLIT_PART(auto, ' ', 3), ', ', 1), ',', '') AS model
   FROM raw_data.sales
),
temporary_table_2 AS (
   SELECT t.brand, t.model, b.id
   FROM temporary_table_1 AS t
   RIGHT JOIN car_shop.model AS m ON t.model = m.model
   LEFT JOIN car_shop.brand AS b ON t.brand = b.brand
)
UPDATE car_shop.model
SET brand_id = temporary_table_2.id
FROM temporary_table_2
WHERE car_shop.model.model = temporary_table_2.model;

/*Удаление таблицы car_specification*/
DROP TABLE car_shop.car_specification CASCADE;

/*Удаление таблицы car_specification_possible*/
DROP TABLE car_shop.car_specification_possible CASCADE;

/*Наполнение таблицы car_specification всеми возможными комбинациями моделей и цветов*/

INSERT INTO car_shop.car_specification (model_id, color_id)
SELECT model.id, color.id
FROM car_shop.model AS model
CROSS JOIN car_shop.color AS color;

/*Тестовый запрос, чтобы посмотреть, какой car_id из таблицы car_specification нужно взять, чтобы внести его
в таблицу sales*/
WITH sraw AS (
    SELECT 
        id, 
        auto, 
        REPLACE(
            SPLIT_PART(SPLIT_PART(auto, ' ', 2) || ' ' || SPLIT_PART(auto, ' ', 3), ', ', 1), 
            ',', ''
        ) AS model, 
        TRIM(SPLIT_PART(auto, ',', 2)) AS color
    FROM raw_data.sales
)
SELECT 
    snew.id, 
    snew.car_id, 
    sraw.id, 
    sraw.auto, 
    sraw.model, 
    sraw.color,
    m.id AS model_id, 
    m.model,
    c.id AS color_id,
    c.color,
    cs.id AS car_id
FROM car_shop.sales AS snew
INNER JOIN sraw ON sraw.id = snew.id
LEFT JOIN car_shop.model AS m ON m.model = sraw.model
LEFT JOIN car_shop.color AS c ON c.color = sraw.color
LEFT JOIN car_shop.car_specification AS cs ON (m.id = cs.model_id AND c.id = cs.color_id)
WHERE m.model = sraw.model AND c.color = sraw.color
ORDER BY snew.id;

/*Наполнение поля car_id таблицы продаж car_shop.sales*/

WITH sraw AS (
    SELECT 
        id, 
        auto, 
        REPLACE(
            SPLIT_PART(SPLIT_PART(auto, ' ', 2) || ' ' || SPLIT_PART(auto, ' ', 3), ', ', 1), 
            ',', ''
        ) AS model, 
        TRIM(SPLIT_PART(auto, ',', 2)) AS color
    FROM raw_data.sales
),
temporary_table AS (
SELECT 
    snew.id, 
    cs.id AS car_id
FROM car_shop.sales AS snew
INNER JOIN sraw ON sraw.id = snew.id
LEFT JOIN car_shop.model AS m ON m.model = sraw.model
LEFT JOIN car_shop.color AS c ON c.color = sraw.color
LEFT JOIN car_shop.car_specification AS cs ON (m.id = cs.model_id AND c.id = cs.color_id)
WHERE m.model = sraw.model AND c.color = sraw.color
ORDER BY snew.id  
)
UPDATE car_shop.sales
SET car_id = temporary_table.car_id
FROM temporary_table
WHERE car_shop.sales.id = temporary_table.id;

/*СТАРЫЕ КОММЕНТАРИИ от 19 сентября 2024*/
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