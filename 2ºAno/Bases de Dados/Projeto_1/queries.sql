-- Liste o nome de todos os clientes que fizeram encomendas contendo produtos de preço superior a €50 no ano de 2023
SELECT c.name
    FROM customer AS c
    NATURAL JOIN orders
    NATURAL JOIN contains AS cc
    INNER JOIN product AS p ON cc.sku = p.sku
    WHERE p.price > 50 AND odate BETWEEN '2023-01-01' AND '2023-12-31';

-- Liste o nome de todos os empregados que trabalham em armazéns e não em escritórios e processaram encomendas em Janeiro de 2023
SELECT e.name
    FROM employee AS e
    NATURAL JOIN processes
    NATURAL JOIN orders AS o
    WHERE e.ssn IN (
        SELECT ssn FROM works
        NATURAL JOIN warehouse
        EXCEPT
        SELECT ssn FROM works
        NATURAL JOIN office)
    AND o.odate BETWEEN '2023-01-01' AND '2023-01-31';

-- Indique o nome do produto mais vendido
SELECT p.name
FROM product AS p
    NATURAL JOIN contains
    NATURAL JOIN sale
GROUP BY sku
HAVING SUM(quantity) >= ALL (
    SELECT SUM(quantity)
    FROM contains
    NATURAL JOIN sale
    GROUP BY sku
);

-- Indique o valor total de cada venda realizada
SELECT order_no AS sale_no, SUM(c.quantity * p.price) AS total_value
    FROM sale
    NATURAL JOIN contains AS c
    NATURAL JOIN product AS p
    GROUP BY order_no;
