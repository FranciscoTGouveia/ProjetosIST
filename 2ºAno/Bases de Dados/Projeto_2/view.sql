DROP VIEW IF EXISTS product_sales;
CREATE VIEW product_sales(SKU, order_no, qty, total_price, year, month, day, weekday, city) AS
SELECT SKU,
    order_no,
    qty,
    cont.qty * p.price,
    EXTRACT(YEAR FROM o.odate),
    EXTRACT(MONTH FROM o.odate),
    EXTRACT(DAY FROM o.odate),
    EXTRACT(DOW FROM o.odate),
    SUBSTRING(c.address FROM '[^ ]+$')
FROM pay
NATURAL JOIN contains cont
NATURAL JOIN product p
NATURAL JOIN orders o
JOIN customer c USING(cust_no);


DROP TABLE IF EXISTS d_date;

-- Date dimension table for 2022 dates
CREATE TABLE d_date (
    month NUMERIC(2, 0),
    day NUMERIC(2, 0),
    weekday NUMERIC(1, 0),
    PRIMARY KEY (month, day)
);

INSERT INTO d_date (month, day, weekday)
    SELECT EXTRACT(MONTH FROM dd),
        EXTRACT(DAY FROM dd),
        EXTRACT(DOW FROM dd)
    FROM GENERATE_SERIES(
        (DATE('2022-01-01')),
        (DATE('2022-12-31')),
        '1 day'::INTERVAL) dd;
