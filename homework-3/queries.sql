-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT customers.company_name, CONCAT(last_name, ' ', first_name) as employee
FROM customers JOIN orders USING(customer_id)
JOIN employees USING (employee_id)
JOIN shippers ON orders.ship_via = shippers.shipper_id
WHERE shippers.company_name = 'United Package' AND
customers.city = 'London' AND employees.city = 'London'


-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT products.product_name, products.units_in_stock, suppliers.contact_name, suppliers.phone FROM products
JOIN suppliers USING(supplier_id) WHERE products.units_in_stock < 25 AND products.discontinued <> 1 AND category_id IN
(SELECT category_id FROM categories WHERE category_name IN ('Dairy Products', 'Condiments')) ORDER BY products.units_in_stock;

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT company_name FROM customers LEFT JOIN orders USING(customer_id) WHERE order_id is NULL

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT DISTINCT product_name FROM products WHERE EXISTS
(SELECT 1 FROM order_details WHERE products.product_id = order_details.product_id AND quantity = 10);
