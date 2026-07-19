-- Retail Sales Performance Analysis - SQL Queries
-- Dataset: Superstore Sales (~9,994 orders, 2014-2017)


-- Q1: Which sub-categories are most/least profitable?
-- Finding: Tables lose $17,725 (-8.56% margin) despite $206k in sales -
-- worst performer. Bookcases and Supplies also unprofitable.
SELECT "Sub-Category", 
       ROUND(SUM(Sales), 2) AS total_sales, 
       ROUND(SUM(Profit), 2) AS total_profit,
       ROUND(SUM(Profit) * 1.0 / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM orders
GROUP BY "Sub-Category"
ORDER BY total_profit DESC;

-- Q2: Which region has the worst profit margin?
-- Finding: Central region has lowest margin (7.92%) despite solid sales
-- volume; West is strongest on both profit and margin (14.94%).
SELECT Region, 
       ROUND(SUM(Sales), 2) AS total_sales,
       ROUND(SUM(Profit), 2) AS total_profit,
       ROUND(SUM(Profit) * 1.0 / SUM(Sales) * 100, 2) AS margin_pct
FROM orders
GROUP BY Region
ORDER BY margin_pct ASC;

-- Q3: Does discount level affect profit?
-- Finding: Orders discounted above 20% are unprofitable on average.
-- 933 orders (9.3% of total) discounted 40%+ lost nearly $100k combined.
SELECT 
  CASE 
    WHEN Discount = 0 THEN 'No Discount'
    WHEN Discount <= 0.2 THEN 'Low (0-20%)'
    WHEN Discount <= 0.4 THEN 'Medium (20-40%)'
    ELSE 'High (40%+)'
  END AS discount_band,
  COUNT(*) AS num_orders,
  ROUND(AVG(Profit), 2) AS avg_profit,
  ROUND(SUM(Profit), 2) AS total_profit
FROM orders
GROUP BY discount_band
ORDER BY avg_profit DESC;

-- Q4: What does the monthly sales trend look like?
-- Finding: Strong seasonality - sales dip every Jan/Feb and peak every
-- Nov/Dec. Overall upward trend year-over-year, 2017 strongest.
SELECT 
  substr("Order Date", -4) || '-' || 
  CASE WHEN length(substr("Order Date", 1, instr("Order Date",'/')-1)) = 1 
       THEN '0' || substr("Order Date", 1, instr("Order Date",'/')-1)
       ELSE substr("Order Date", 1, instr("Order Date",'/')-1) END AS year_month,
  ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY year_month
ORDER BY year_month;

-- Q5: Which customer segment drives the most revenue and profit?
-- Finding: Consumer drives highest volume but lowest margin (11.55%).
-- Home Office is smallest segment but most profit-efficient (14.03%).
SELECT Segment,
       ROUND(SUM(Sales), 2) AS total_sales,
       ROUND(SUM(Profit), 2) AS total_profit,
       ROUND(SUM(Profit) * 1.0 / SUM(Sales) * 100, 2) AS margin_pct,
       COUNT(DISTINCT "Order ID") AS num_orders
FROM orders
GROUP BY Segment
ORDER BY total_profit DESC;