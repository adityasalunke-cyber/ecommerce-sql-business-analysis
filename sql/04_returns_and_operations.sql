USE ecommerce_practice;

-- 1. Return rate (%) per category = Returned / all orders in the category
SELECT p.category,
       COUNT(*) AS total_orders,
       SUM(o.order_status = 'Returned') AS returned_orders,
       ROUND(100 * SUM(o.order_status = 'Returned') / COUNT(*), 2) AS return_rate_pct
FROM orders o
JOIN products p ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;

-- 2. Average delivery time (days) per shipping city, minimum 15 delivered orders
SELECT shipping_city,
       COUNT(*) AS delivered_orders,
       ROUND(AVG(DATEDIFF(delivery_date, order_date)), 2) AS avg_delivery_days
FROM orders
WHERE order_status = 'Delivered'
  AND delivery_date IS NOT NULL
GROUP BY shipping_city
HAVING COUNT(*) >= 15
ORDER BY avg_delivery_days;
