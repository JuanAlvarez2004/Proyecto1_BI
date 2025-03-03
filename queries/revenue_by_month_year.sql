-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
-- Solución:
SELECT
    month_no,
    month,
    COALESCE(Year2016, 0.0) AS Year2016,
    COALESCE(Year2017, 0.0) AS Year2017,
    COALESCE(Year2018, 0.0) AS Year2018
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
        SUM(CASE WHEN CAST(STRFTIME('%Y', o.order_delivered_customer_date) AS INTEGER) = 2016 THEN p.payment_value ELSE 0 END) AS Year2016,
        SUM(CASE WHEN CAST(STRFTIME('%Y', o.order_delivered_customer_date) AS INTEGER) = 2017 THEN p.payment_value ELSE 0 END) AS Year2017,
        SUM(CASE WHEN CAST(STRFTIME('%Y', o.order_delivered_customer_date) AS INTEGER) = 2018 THEN p.payment_value ELSE 0 END) AS Year2018
    FROM
        olist_orders o
    JOIN
        olist_order_payments p ON o.order_id = p.order_id
    WHERE
        o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY
        month_no
) data ON months.month_no = data.month_no
ORDER BY
    months.month_no;
