CREATE DATABASE ECOMMERCE_DB;
USE ECOMMERCE_DB;
CREATE TABLE Customers (
customer_id int PRIMARY KEY IDENTITY(1,1),
cust_name VARCHAR(50) NOT NULL,
cust_email VARCHAR(50) NOT NULL,
cust_phone VARCHAR(20) NOT NULL,
cust_address VARCHAR(20) NOT NULL);

CREATE TABLE Orders (
order_id INT PRIMARY KEY IDENTITY(1,1),
order_date DATE NOT NULL,
order_status VARCHAR(20) NOT NULL,
customer_id INT NOT NULL,
CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
REFERENCES Customers (customer_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE Products (
	product_id INT PRIMARY KEY IDENTITY(1,1),
	product_name VARCHAR(30) NOT NULL,
	product_category VARCHAR(30) NOT NULL,
	product_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE OrderItems (
	order_item_id INT PRIMARY KEY IDENTITY(1,1),
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT,
	price_at_purchase DECIMAL(10,2),
	CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_id)
	REFERENCES Orders (order_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_OrderItems_Products FOREIGN KEY (product_id)
	REFERENCES Products(product_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE Payments (
	payment_id INT PRIMARY KEY IDENTITY(1,1),
	order_id INT NOT NULL,
	amount DECIMAL(10,2) NOT NULL,
	payment_date DATE NOT NULL,
	payment_method VARCHAR(20) NOT NULL,
	CONSTRAINT FK_Payments_Orders FOREIGN KEY (order_id)
	REFERENCES Orders (order_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

INSERT INTO Customers (cust_name, cust_email, cust_phone, cust_address)
VALUES 
('Alice Smith', 'alice.smith@example.com', '1234567890', '123 Main St'),
('Bob Johnson', 'bob.johnson@example.com', '9876543210', '456 Elm St'),
('Charlie Brown', 'charlie.brown@example.com', '5551234567', '789 Oak St');

INSERT INTO Orders (order_date, order_status, customer_id)
VALUES 
('2024-11-01', 'Shipped', 1), 
('2024-11-02', 'Processing', 2),
('2024-11-03', 'Delivered', 3); 

INSERT INTO Products (product_name, product_category, product_price)
VALUES 
('Laptop', 'Electronics', 1200.00),
('Headphones', 'Electronics', 150.00),
('Office Chair', 'Furniture', 300.00),
('Desk Lamp', 'Furniture', 50.00),
('Smartphone', 'Electronics', 800.00);

INSERT INTO OrderItems (order_id, product_id, quantity, price_at_purchase)
VALUES 
(1, 1, 1, 1200.00), -- Laptop for Order 1
(1, 2, 2, 150.00), -- Headphones for Order 1
(2, 3, 1, 300.00), -- Office Chair for Order 2
(2, 4, 2, 50.00), -- Desk Lamp for Order 2
(3, 5, 1, 800.00); -- Smartphone for Order 3

INSERT INTO Payments (order_id, amount, payment_date, payment_method)
VALUES 
(1, 1500.00, '2024-11-02', 'Credit Card'), -- Payment for Order 1
(2, 400.00, '2024-11-03', 'Debit Card'), -- Payment for Order 2
(3, 800.00, '2024-11-04', 'PayPal'); -- Payment for Order 3

SELECT * FROM Customers;

--1.Retrieve all customers who haven’t placed any orders yet.
SELECT * 
FROM Customers
LEFT JOIN Orders 
ON Customers.customer_id = Orders.customer_id
WHERE order_id IS NULL;

--2.Update the phone number of a customer with a specific customer_id.
UPDATE Customers
SET cust_phone = '9897969594'
WHERE customer_id = 3;

--3.List all orders placed in the last 30 days, along with the corresponding customer name and email.
SELECT O.customer_id, C.cust_name, C.cust_email, O.order_date
FROM Orders O
JOIN  Customers C
ON O.customer_id = C.customer_id
WHERE DATEDIFF(DAY, order_date, GETDATE()) < 30;

--4.Calculate the total number of orders for each customer and display the customer’s name, email, and total order count.
SELECT C.cust_name, C.cust_email, COUNT(O.order_id) AS total_order_count
FROM Customers C
LEFT JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY C.cust_name, C.cust_email;

--5.Find all orders with a status of "Pending" that were placed more than 7 days ago.
SELECT customer_id, order_date
FROM Orders
WHERE order_status = 'Processing' 
	AND order_date >= DATEADD(DAY, -16,GETDATE());

--7.Find the product category with the highest average price.
SELECT product_category, AVG(product_price) AS average_price
FROM Products 
GROUP BY product_category 
ORDER BY average_price DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS ONLY;

--8.Calculate the total quantity of each product sold and display the product_name along with the total quantity.
SELECT * FROM OrderItems;
SELECT * FROM Products;

SELECT P.product_name, O.quantity AS TotalQuantity
FROM Products P
LEFT  JOIN OrderItems O
ON P.product_id = O.product_id;

--9.Retrieve the total revenue generated from each product, sorted by revenue in descending order.
SELECT * FROM OrderItems;
SELECT * FROM Products;
--using sub-query
SELECT product_name, 
(SELECT quantity*price_at_purchase AS revenue FROM OrderItems WHERE product_id = Products.product_id) AS total_revenue 
FROM Products
ORDER BY total_revenue DESC;

--using joins
SELECT product_name, quantity*price_at_purchase AS  total_revenue 
FROM Products
LEFT JOIN OrderItems
ON Products.product_id = OrderItems.product_id
ORDER BY total_revenue DESC;

--10.Find all orders that have been paid using the "Credit Card" payment method and display the customer_name and payment_date.
SELECT * FROM Payments;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT C.cust_name, P.payment_method, P.payment_date
FROM Customers C
LEFT JOIN Orders O ON C.customer_id = O.customer_id
LEFT JOIN Payments P ON O.order_id = P.order_id
WHERE P.payment_method = 'Credit Card';

--11.Calculate the total payment amount received per payment_method.
SELECT payment_method, amount
FROM Payments;

--12.Find the top 3 customers who have spent the most, including their name, total amount, and the number of orders they placed.
SELECT * FROM OrderItems;

SELECT C.cust_name, P.amount, COUNT(O.order_id) AS Number_Of_Orders
FROM Customers C
INNER JOIN Orders O ON C.customer_id = O.customer_id
INNER JOIN OrderItems OI ON O.order_id = OI.order_id
INNER JOIN Payments P ON OI.order_id = P.order_id
GROUP BY C.cust_name, P.amount
ORDER BY P.amount DESC
OFFSET 0 ROWS 
FETCH FIRST 3 ROWS ONLY;

--13.Retrieve all orders where the total amount (sum of price_at_purchase * quantity for all items in the order) exceeds 500.
SELECT O.order_id, SUM(OI.quantity*OI.price_at_purchase) AS TotalAmount
FROM Orders O
JOIN OrderItems OI
ON O.order_id = OI.order_id
GROUP BY O.order_id
HAVING SUM(OI.quantity*OI.price_at_purchase) > 500;

--14.Display the order details (order ID, order date, total amount, and status) for customers who have placed more than or equal to 2 orders.
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;

SELECT DISTINCT O.order_id, O.order_date, P.amount, O.order_status
FROM Orders O
INNER JOIN OrderItems OI ON O.order_id = OI.order_id
INNER JOIN Payments P ON OI.order_id = P.order_id
WHERE O.order_id IN (SELECT order_id FROM OrderItems  GROUP BY order_id HAVING COUNT(order_id) >= 2);

--15.Find the percentage of orders with "Processing" status out of the total number of orders.
SELECT COUNT(*)
FROM Orders
WHERE order_status = 'Processing';

WITH cte_TotalNoOfOrders
AS
(
	SELECT COUNT(order_id) AS total_orders
	FROM Orders
),
cte_SpecificOrders
AS
(
	SELECT COUNT(order_id) AS processing_orders
	FROM Orders
	WHERE order_status = 'Processing'
)
SELECT 
    (processing_orders * 100.0) / total_orders AS processing_percentage
FROM 
    cte_TotalNoOfOrders, cte_SpecificOrders;



SELECT s.customer_id, SUM(m.price) AS Total_Amount
FROM sales s
LEFT JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id;