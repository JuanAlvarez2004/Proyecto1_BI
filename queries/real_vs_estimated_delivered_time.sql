-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.
-- Solución:
SELECT
    month_no,
    month,
    Year2016_real_time,
    Year2017_real_time,
    Year2018_real_time,
    Year2016_estimated_time,
    Year2017_estimated_time,
    Year2018_estimated_time
FROM (
    SELECT
        '01' AS month_no, 'Jan' AS month
    UNION SELECT '02' AS month_no, 'Feb' AS month
    UNION SELECT '03' AS month_no, 'Mar' AS month
    UNION SELECT '04' AS month_no, 'Apr' AS month
    UNION SELECT '05' AS month_no, 'May' AS month
    UNION SELECT '06' AS month_no, 'Jun' AS month
    UNION SELECT '07' AS month_no, 'Jul' AS month
    UNION SELECT '08' AS month_no, 'Aug' AS month
    UNION SELECT '09' AS month_no, 'Sep' AS month
    UNION SELECT '10' AS month_no, 'Oct' AS month
    UNION SELECT '11' AS month_no, 'Nov' AS month
    UNION SELECT '12' AS month_no, 'Dec' AS month
) months
LEFT JOIN (
    SELECT
        STRFTIME('%m', o.order_delivered_customer_date) AS month_no,
        AVG(CASE WHEN STRFTIME('%Y', o.order_delivered_customer_date) = '2016' THEN julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp) ELSE NULL END) AS Year2016_real_time,
        AVG(CASE WHEN STRFTIME('%Y', o.order_delivered_customer_date) = '2017' THEN julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp) ELSE NULL END) AS Year2017_real_time,
        AVG(CASE WHEN STRFTIME('%Y', o.order_delivered_customer_date) = '2018' THEN julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp) ELSE NULL END) AS Year2018_real_time,
        AVG(CASE WHEN STRFTIME('%Y', o.order_estimated_delivery_date) = '2016' THEN julianday(o.order_estimated_delivery_date) - julianday(o.order_purchase_timestamp) ELSE NULL END) AS Year2016_estimated_time,
        AVG(CASE WHEN STRFTIME('%Y', o.order_estimated_delivery_date) = '2017' THEN julianday(o.order_estimated_delivery_date) - julianday(o.order_purchase_timestamp) ELSE NULL END) AS Year2017_estimated_time,
        AVG(CASE WHEN STRFTIME('%Y', o.order_estimated_delivery_date) = '2018' THEN julianday(o.order_estimated_delivery_date) - julianday(o.order_purchase_timestamp) ELSE NULL END) AS Year2018_estimated_time
    FROM
        olist_orders o
    WHERE
        o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
        AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY
        month_no
) data ON months.month_no = data.month_no
ORDER BY
    months.month_no;
