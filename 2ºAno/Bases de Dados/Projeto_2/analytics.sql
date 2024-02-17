-- 1. As quantidades e valores totais de venda de cada produto em 2022,
-- globalmente, por cidade, por mês, dia do mês e dia da semana
SELECT SKU,
    city,
    month,
    day,
    weekday,
    SUM(qty) AS quantity,
    SUM(total_price) AS total
FROM product_sales
WHERE year = 2022
GROUP BY GROUPING SETS (
    (SKU, city),
    (SKU, month),
    (SKU, day),
    (SKU, weekday),
    (SKU)
)
ORDER BY city, month, day, weekday, SKU;

-- 2. O valor médio diário das vendas de todos os produtos em 2022,
-- globalmente, por mês e dia da semana
WITH daily_sales AS (
		-- Use coalesce to set the total_price of days with no sales to 0 from NULL
    SELECT d.month, d.weekday, COALESCE(SUM(total_price), 0) AS total
    FROM product_sales ps
    RIGHT OUTER JOIN d_date d -- Add all days to the table
        ON ps.month = d.month
        AND ps.year = 2022
        AND ps.day = d.day
    GROUP BY (d.month, d.day)
)
SELECT month, weekday, AVG(total)
FROM daily_sales
GROUP BY GROUPING SETS (
    (weekday),
    (month),
    ()
)
ORDER BY month, weekday;
