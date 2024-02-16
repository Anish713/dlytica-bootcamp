-- Handson for Bootcamp

-- DDL Statements (Data Definition Language)
CREATE DATABASE bootcamp_db;

-- \l -> list all available databases 
-- \c bootcamp_db -> connect to a database

-- Create syntax
CREATE TABLE product (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(150),
  price FLOAT NOT NULL,
  category VARCHAR(20)
);

CREATE TABLE store (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  city VARCHAR(50),
  state VARCHAR(20)
);

CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES Product(id) ON DELETE CASCADE,
  store_id INTEGER REFERENCES Store(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL,
  sale_price FLOAT NOT NULL,
  sales_time TIMESTAMP NOT NULL
);

CREATE TABLE Users (
    id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    product_id INTEGER NOT NULL
);

-- \dt -> display all tables
-- \d table name -> display schema of a table 

-- Alter syntax
ALTER TABLE Store ADD COLUMN country VARCHAR(50);

ALTER TABLE Product RENAME COLUMN description TO product_description;

ALTER TABLE Users ALTER COLUMN name TYPE varchar(100);
-- DROP syntax
DROP TABLE Users;

--- DML Statements
-- Inserting data
INSERT INTO Product (name, price, product_description, category)
VALUES ('Headphones', 59.99, 'Noise-canceling wireless headphones with excellent sound quality', 'Electronics'),
       ('T-shirt', 14.99, 'Comfortable and stylish cotton T-shirt', 'Clothing'),
       ('Book', 29.95, 'Informative and engaging non-fiction book' ,'Books'),
       ('The book of engineering', 45.95, 'Learn engineering from scratch the professional way' ,'Books'),
       ('The Python cookbook', 25.95, 'Python Crash Course for Beginners' ,'Books'),
       ('Smartwatch', 199.99, 'Fitness tracker and smartwatch', 'Electronics'),
       ('Desk Lamp', 24.99, 'Adjustable LED desk lamp', 'Homeware'),
       ('Sweatshirt', 29.99, 'Cozy and comfortable pullover sweatshirt', 'Clothing'),
       ('Novel', 15.99, 'Award-winning fiction novel', 'Books'),
       ('Cookbook', 22.99, 'Collection of delicious and easy recipes', 'Books');


INSERT INTO Store (name, city, state, country)
VALUES ('Tech City', 'San Francisco', 'CA', 'USA'),
       ('Bookstore Chain', 'New York', 'NY', 'USA'),
       ('Grocery Market', 'San Diego', 'CA', 'USA'),
       ('Department Store', 'London', 'UK', 'England'),
       ('Bookstore', 'Chicago', 'IL', 'USA'),
       ('Clothing Outlet', 'Berlin', 'DE', 'Germany'),
       ('Electronics Chain', 'Tokyo', 'JP', 'Japan');

INSERT INTO Sales (product_id, store_id, quantity, sale_price, sales_time)
VALUES (1, 2, 10, 49.99, CURRENT_TIMESTAMP),
       (2, 1, 5, 12.99, CURRENT_TIMESTAMP),
       (1, 3, 3, 24.95, CURRENT_TIMESTAMP),
       (2, 2, 20, 189.99, CURRENT_TIMESTAMP),
       (3, 1, 5, 22.99, CURRENT_TIMESTAMP),
       (4, 1, 7, 27.99, CURRENT_TIMESTAMP),
       (5, 2, 8, 14.99, CURRENT_TIMESTAMP),
       (2, 1, 3, 24.99, CURRENT_TIMESTAMP),
       (8, 2, 0, 49.99, '2022-01-12'),
       (2, 5, 0, 0, '2019-07-03');

-- Select
SELECT * FROM product;

SELECT name, city, country from store;

select * from sales limit 5;

--- Filtering data  

SELECT * FROM Product WHERE price < 20;

SELECT * FROM Product WHERE name LIKE '%book%';

SELECT * FROM Store WHERE state = 'CA';

SELECT * FROM Sales WHERE sales_time < '2024-01-01';

-- Updating data
UPDATE Product SET price = price * 1.1 WHERE category = 'Electronics';

UPDATE Store SET city = 'Seattle' WHERE state = 'IL';

-- Deleting data
DELETE FROM Store WHERE name LIKE '%Market';

DELETE FROM Sales WHERE quantity <= 0;

--- DCL Statements
-- view all available roles
-- \du -> display all available roles
SELECT * FROM pg_catalog.pg_roles;

-- view all available users;
SELECT * from pg_catalog.pg_user;

-- RBAC
CREATE ROLE sales;
CREATE ROLE client;

-- Grant statement
-- Grant SELECT, INSERT, UPDATE, DELETE on all tables
GRANT ALL ON Product, Store, Sales TO sales;

GRANT USAGE, SELECT ON SEQUENCE product_id_seq TO sales;

-- Grant SELECT on Product and Store tables
GRANT SELECT ON Product, Store TO client;

-- Creating new users
CREATE USER john_sales WITH PASSWORD 'john123';
GRANT sales TO john_sales;

CREATE USER jane_client WITH PASSWORD 'jane123';
GRANT client TO jane_client;

-- \q -> logout from psql
-- psql -U <user_name> -d <db_name> -> To login to a database as a user


-- Deny access to Product table
REVOKE ALL ON Product FROM sales;

-- Delete users and roles
DROP USER john_sales;
DROP USER jane_client;
DROP ROLE sales;
DROP ROLE client;


-- Data Aggregation
-- Aggregation functions
select count(*) as total_sales from sales;

select MAX(price) as highest_price from product;

select SUM(sale_price) as total_sales_amount from sales;
-- Group By and Order By
SELECT category, COUNT(*) AS product_count
FROM Product
GROUP BY category
ORDER BY product_count;

SELECT category, AVG(price) AS average_category_price
FROM Product
GROUP BY category
ORDER BY average_category_price DESC;

--filtering in group by
SELECT category, AVG(price) AS average_category_price
FROM Product
GROUP BY category
HAVING AVG(price) > 100
ORDER BY average_category_price DESC;

--- Illustrating joins 
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    product_id INTEGER NOT NULL
);

INSERT INTO Users (name, product_id) VALUES ('Ram',1),('Shyam',5),('Gita',20),('Sita',11),('Sushant',100);

--- Inner join
SELECT P.name, P.price, U.name
FROM Product P INNER JOIN Users U ON P.id = U.product_id;
-- Left Join
SELECT P.name, P.price, U.name
FROM Product P LEFT JOIN Users U ON P.id = U.product_id;
-- Right Join
SELECT P.name, P.price, U.name
FROM Product P RIGHT JOIN Users U ON P.id = U.product_id;
-- Full Outer Join
SELECT P.name, P.price, U.name
FROM Product P FULL JOIN Users U ON P.id = U.product_id;

-- DELETE The DATABASE
-- \c postgres -> connect to some other database
DROP DATABASE bootcamp_db;

