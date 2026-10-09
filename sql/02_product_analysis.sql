USE ecommerce_practice;

-- 1. Products that are out of stock but still marked available
SELECT product_name, category, brand
FROM products
WHERE stock_quantity = 0
  AND is_available = 1;

-- 2. Top 10 most expensive products
SELECT product_name, brand, price
FROM products
ORDER BY price DESC
LIMIT 10;

-- 3. Average rating and product count per category
SELECT category,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS total_products
FROM products
GROUP BY category
ORDER BY avg_rating DESC;

-- 4. Products launched in 2025 or later with rating above 4.0
SELECT product_name, rating, launch_date
FROM products
WHERE launch_date >= '2025-01-01'
  AND rating > 4.0
ORDER BY rating DESC;

-- 5. Gross profit per product (Delivered), top 10
-- profit = (price after discount - cost price) * quantity
SELECT p.product_id,
       p.product_name,
       ROUND(SUM((o.unit_price * (1 - o.discount_percent / 100) - p.cost_price) * o.quantity), 2) AS gross_profit
FROM orders o
JOIN products p ON p.product_id = o.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY gross_profit DESC
LIMIT 10;
