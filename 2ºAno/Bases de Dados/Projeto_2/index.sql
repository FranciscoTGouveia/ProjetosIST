-- QUERY 1

DROP INDEX IF EXISTS order_date;
-- This index helps the dbms fetch the rows from orders where the year in odate is equal to 2023
-- With a hash index on the year, it becomes trivial finding all the rows with odate year = 2023
CREATE INDEX order_date ON orders USING BTREE(EXTRACT(YEAR FROM odate), order_no);

DROP INDEX IF EXISTS prod_price;
-- This index helps the dbms fetch the product rows where product.price is greater than 50
-- The BTree will sort itself by the price, so we won't need to scan the whole product table
-- in order to find the target rows.
CREATE INDEX prod_price ON product USING BTREE(price, SKU);

-- DROP INDEX IF EXISTS contains_order_no;
-- This index will allow for a much quicker join algorithm to be used.
-- With a hash on the order_no, the process of finding matching rows is done very efficiently.
-- However, the contains table's primary key compound index should serve this purpose already.
-- CREATE INDEX contains_order_no ON contains USING HASH(order_no);

-- An index on product.SKU is not needed since we can use the table's primary index

EXPLAIN ANALYZE VERBOSE SELECT order_no
FROM orders
JOIN contains USING (order_no)
JOIN product USING (SKU)
WHERE price > 50 AND
EXTRACT(YEAR FROM odate) = 2023;
-- The dbms should start by filtering both the product and orders tables
-- using the indexes above and then, perform the joins.

-- ---------------------------------------------------------------------------------------

-- QUERY 2

-- This index makes the aggregation procedure faster.
-- However, the contains table's primary key compound index should serve this purpose already.
-- CREATE INDEX contains_order_no ON contains USING HASH(order_no);

DROP INDEX IF EXISTS prod_name;
-- This index helps make the regex filtering of product.name more efficient.
-- This index works for this query because the regex filter used is a prefix
-- and since the btree keeps the names ordered lexicographically, it becomes
-- easier to find the names which start with the letter 'A'.
CREATE INDEX prod_name ON product USING BTREE(name text_pattern_ops, price, sku);

EXPLAIN ANALYZE VERBOSE SELECT order_no, SUM(qty*price)
FROM contains
JOIN product USING (SKU)
WHERE name LIKE 'A%'
GROUP BY order_no;
