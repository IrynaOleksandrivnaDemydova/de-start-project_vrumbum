/*сохраните в этом файле запросы для первоначальной загрузки данных - 
создание схемы raw_data и таблицы sales и наполнение их данными из csv файла*/

/*создание схемы raw_data*/
CREATE SCHEMA IF NOT EXISTS raw_data;

/*создание таблицы sales в схеме raw_data*/
CREATE TABLE IF NOT EXISTS raw_data.sales (
    id NUMERIC(4, 0) PRIMARY KEY,  
    auto VARCHAR(100),  
    gasoline_consumption NUMERIC(3, 1) NULL, 
    price NUMERIC(9, 2) NOT NULL,  
    date DATE NOT NULL,  
    person VARCHAR(100),  
    phone VARCHAR(30), 
    discount NUMERIC(4, 2),
    brand_origin VARCHAR(100)  
);

/*наполнение таблицы sales в схеме raw_data сырыми данными 
из файла cars.csv с помощью команды \copy в psql*/

\copy raw_data.sales (id, auto, gasoline_consumption, price, date, person, phone, discount, brand_origin) 
FROM 'C:\Temp\cars.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'null');