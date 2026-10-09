USE ecommerce_practice;

-- 1. Orders per status
SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 2. Cancelled Cash on Delivery orders
SELECT order_id, order_date, total_amount
FROM orders
WHERE payment_method = 'Cash on Delivery'
  AND order_status = 'Cancelled';

-- 3. Total units sold in Delivered orders
SELECT SUM(quantity) AS total_units_sold
FROM orders
WHERE order_status = 'Delivered';

-- 4. Most used payment method
SELECT payment_method, COUNT(*) AS order_count
FROM orders
GROUP BY payment_method
ORDER BY order_count DESC;

-- 5. Revenue by product category
SELECT p.category, SUM(o.total_amount) AS revenue
FROM orders o
JOIN products p ON p.product_id = o.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY revenue DESC;
