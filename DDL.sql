/*НОВЫЕ КОММЕНТАРИИ от 22 сентября 2024*/

/*Создание таблицы стран country*/

CREATE TABLE car_shop.country (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
    brand_origin VARCHAR(100) /* в названии страны могут быть и цифры (по ошибке), и буквы, поэтому varchar.*/
);

/*Создание таблицы брэндов brand*/

CREATE TABLE car_shop.brand (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
    brand VARCHAR(100), /* в названии страны могут быть и цифры (по ошибке), и буквы, поэтому varchar.*/
    country_id INTEGER /*внешний ключ к таблице country*/
    CONSTRAINT fk_brand_country_id REFERENCES car_shop.country(id) ON DELETE RESTRICT
    /*внешний ключ к таблице car_specification*/
);

/*Создание таблицы моделей model*/

CREATE TABLE car_shop.model (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
    model VARCHAR(30), /* в названии модели могут быть и цифры, и буквы, поэтому varchar.*/
    gasoline_consumption NUMERIC(3, 1) NULL, /*потребление бензина не может быть трехзначным, поэтому оставляем двухзначную
    цифру и одну цифру после запятой. У numeric повышенная точность при работе с дробными числами*/
    brand_id INTEGER /*внешний ключ к таблице brand*/
    CONSTRAINT fk_model_brand_id REFERENCES car_shop.brand(id) ON DELETE RESTRICT
    /*внешний ключ к таблице car_specification*/
);

/*Удаление старой таблицы car_specification*/
DROP TABLE car_shop.car_specification CASCADE;

/*Удаление старой таблицы car_specification_possible*/
DROP TABLE car_shop.car_specification_possible CASCADE;

/*Создание таблицы car_specification, со всеми возможными комбинациями model + color*/

CREATE TABLE car_shop.car_specification (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
	model_id INTEGER CONSTRAINT fk_car_specification_model_id 
    REFERENCES car_shop.model(id) ON DELETE RESTRICT,
    /*внешний ключ к таблице car_specification*/
	color_id INTEGER CONSTRAINT fk_car_specification_color_id 
    REFERENCES car_shop.color(id) ON DELETE RESTRICT
    /*внешний ключ к таблице color*/
);

/*Добавление CONSTRAINT car_id в таблицу shop.sales*/

ALTER TABLE car_shop.sales
ADD CONSTRAINT fk_sales_car_specification_id FOREIGN KEY (car_id)
REFERENCES car_shop.car_specification(id)
ON DELETE RESTRICT;

/*СТАРЫЕ КОММЕНТАРИИ от 19 сентября 2024*/
/*Добавьте в этот файл все запросы, для создания схемы данных автосалона и
 таблиц в ней в нужном порядке*/

/*Создание схемы данных автосалона car_shop*/

 CREATE SCHEMA IF NOT EXISTS car_shop;

/*Создание таблицы цветов машин color*/

CREATE TABLE car_shop.color (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
    color VARCHAR(30) UNIQUE /* в названии цвета могут быть и цифры, и буквы, поэтому varchar.*/
);

/*Создание таблицы person с данными клиентов*/

CREATE TABLE car_shop.person (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
    person VARCHAR(100),  /* в имени человека могут быть разные символы, кто-то может оставить псевдонивм с цифрами, поэтому varchar.*/
    phone VARCHAR(30) /* в телефоне могут быть цифры, скобки и "-", поэтому varchar.*/
);

/*Создание таблицы car_specification с данными машин*/

CREATE TABLE car_shop.car_specification (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
    brand VARCHAR(100), /* в названии бренда могут быть и цифры, и буквы, поэтому varchar.*/
    model VARCHAR(30), /* в названии модели могут быть и цифры, и буквы, поэтому varchar.*/
	brand_origin VARCHAR(100), /* в названии страны могут быть и цифры (по ошибке), и буквы, поэтому varchar.*/
	gasoline_consumption NUMERIC(3, 1) NULL /*потребление бензина не может быть трехзначным, поэтому оставляем двухзначную
    цифру и одну цифру после запятой. У numeric повышенная точность при работе с дробными числами*/
);

/*Создание таблицы car_specification_possible со всеми возможными комбинациями спецификаций машин и цветов*/

CREATE TABLE car_shop.car_specification_possible (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
	car_specification_id INTEGER CONSTRAINT fk_car_specification_possible_car_specification_id 
    REFERENCES car_shop.car_specification(id) ON DELETE RESTRICT,
    /*внешний ключ к таблице car_specification*/
	color_id INTEGER CONSTRAINT fk_car_specification_possible_color_id 
    REFERENCES car_shop.color(id) ON DELETE RESTRICT
    /*внешний ключ к таблице color*/
);

/*Создание таблицы car_sales с данными по продажам. Я создала вначале с колонками всеми для заполнения сырыми
данными, а также для заполнения нормализованными данными. После заполнения сырыми данными этой таблицы
(файл INSERT.sql) и после проведения анализов (task_1...6) я удалила (код ниже)*/

CREATE TABLE IF NOT EXISTS car_shop.sales (
    id SERIAL PRIMARY KEY, /*первичный ключ с автоинкрементом*/
	brand VARCHAR(100), /* в названии бренда могут быть и цифры, и буквы, поэтому varchar.*/
    model VARCHAR(30),  /* в названии модели могут быть и цифры, и буквы, поэтому varchar.*/
	color VARCHAR(30), /* в названии цвета могут быть и цифры, и буквы, поэтому varchar.*/
    gasoline_consumption NUMERIC(3, 1) NULL, 
    /*потребление бензина не может быть трехзначным, поэтому оставляем двухзначную
    цифру и одну цифру после запятой. У numeric повышенная точность при работе с дробными числами*/
    price NUMERIC(9, 2) NOT NULL,  
    /*цена может содержать только сотые и не может быть больше семизначной суммы. 
    У numeric повышенная точность при работе с дробными числами, 
    поэтому при операциях c этим типом данных, дробные числа не потеряются.*/
    date DATE NOT NULL,   /* формат для даты в формате YYYY-MM-DD*/
    person VARCHAR(100),  /* в имени человека могут быть разные символы, кто-то может оставить псевдонивм с цифрами, поэтому varchar.*/
    phone VARCHAR(30), /* в телефоне могут быть цифры, скобки и "-", поэтому varchar.*/
    discount NUMERIC(4, 2), /*скидка может быть двухзначной с точностью до сотых*/
    brand_origin VARCHAR(100), /* в названии страны могут быть и цифры (по ошибке), и буквы, поэтому varchar.*/
    car_id INTEGER CONSTRAINT fk_sales_car_specification_possible_id 
    REFERENCES car_shop.car_specification_possible(id) ON DELETE RESTRICT,
    /*внешний ключ к таблице car_specification_possible*/
	person_id INTEGER CONSTRAINT fk_sales_person_id 
    REFERENCES car_shop.person(id) ON DELETE RESTRICT
    /*внешний ключ к таблице person*/
);