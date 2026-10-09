USE ecommerce_practice;

-- 1. Brands with revenue above the average brand revenue
WITH brand_revenue AS (
  SELECT p.brand, SUM(o.total_amount) AS revenue
  FROM orders o
  JOIN products p ON p.product_id = o.product_id
  WHERE o.order_status = 'Delivered'
  GROUP BY p.brand
)
SELECT brand, revenue
FROM brand_revenue
WHERE revenue > (SELECT AVG(revenue) FROM brand_revenue)
ORDER BY revenue DESC;

-- 2. Best-selling product by revenue in each category
WITH product_revenue AS (
  SELECT p.category, p.product_id, p.product_name,
         SUM(o.total_amount) AS revenue
  FROM orders o
  JOIN products p ON p.product_id = o.product_id
  WHERE o.order_status = 'Delivered'
  GROUP BY p.category, p.product_id, p.product_name
),
ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk
  FROM product_revenue
)
SELECT category, product_id, product_name, revenue
FROM ranked
WHERE rnk = 1
ORDER BY category;
