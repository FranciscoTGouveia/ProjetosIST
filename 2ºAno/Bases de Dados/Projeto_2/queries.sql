-- Qual o número e nome do(s) cliente(s) com maior valor total de encomendas pagas?
WITH cust_paid AS (
    SELECT o.cust_no, SUM(price * qty) AS tot
    FROM pay
    JOIN orders o USING(order_no)
    JOIN contains USING(order_no)
    JOIN product USING(SKU)
    GROUP BY o.cust_no
)
SELECT c.cust_no, c.name 
FROM cust_paid 
JOIN customer c USING (cust_no)
WHERE tot = (SELECT MAX(tot) FROM cust_paid);


-- Qual o nome dos empregados que processaram encomendas em todos os dias de 2022 em que houve encomendas?
SELECT e.name
FROM employee e
WHERE NOT EXISTS(
	SELECT DISTINCT odate
	FROM orders
	WHERE EXTRACT(YEAR FROM odate) = 2022
	EXCEPT
	SELECT DISTINCT odate
	FROM orders JOIN process p USING(order_no)
	WHERE EXTRACT(YEAR FROM odate) = 2022
		AND p.ssn = e.ssn
);

-- Quantas encomendas foram realizadas mas não pagas em cada mês de 2022?
SELECT months.month, COALESCE(unpaid.unpaid_orders, 0) AS num_unpaid_orders
FROM (SELECT TO_CHAR(dates, 'Month') AS month FROM
    generate_series('2022-01-01'::DATE, '2022-12-31'::DATE, '1 month') dates)
    AS months
    LEFT OUTER JOIN (
        SELECT TO_CHAR(o.odate, 'Month') AS month, COUNT(*) AS unpaid_orders
        FROM orders AS o
        LEFT OUTER JOIN pay p USING(order_no)
            WHERE EXTRACT(YEAR FROM o.odate) = 2022 AND p.order_no IS NULL
        GROUP BY TO_CHAR(o.odate, 'Month')
    ) unpaid USING(month);
