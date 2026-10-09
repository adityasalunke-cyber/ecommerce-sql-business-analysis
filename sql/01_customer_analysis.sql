USE ecommerce_practice;

-- 1. Active Gold and Platinum customers for the email campaign
SELECT CONCAT(first_name, ' ', last_name) AS full_name, email, city
FROM customers
WHERE loyalty_tier IN ('Gold', 'Platinum')
  AND is_active = 1;

-- 2. Customers who never placed an order
SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       c.signup_date,
       c.loyalty_tier
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 3. Customers whose shipping city differs from their registered city on 3+ orders
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       c.city AS registered_city,
       COUNT(*) AS mismatched_orders
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.shipping_city <> c.city
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
HAVING COUNT(*) >= 3
ORDER BY mismatched_orders DESC;

-- 4. Loyalty tier with the highest average order value
SELECT c.loyalty_tier,
       COUNT(*) AS total_orders,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.loyalty_tier
ORDER BY avg_order_value DESC;

-- 5. Top 10 customers by total spend (Delivered only)
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       c.city,
       COUNT(*) AS orders_count,
       SUM(o.total_amount) AS total_spend
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spend DESC
LIMIT 10;
