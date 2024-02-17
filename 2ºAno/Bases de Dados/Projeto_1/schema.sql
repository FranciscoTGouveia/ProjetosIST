-- Table Cleanup
DROP TABLE IF EXISTS delivery;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS contains;
DROP TABLE IF EXISTS ean_product;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS pay;
DROP TABLE IF EXISTS sale;
DROP TABLE IF EXISTS processes;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS office;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS workplace;
DROP TABLE IF EXISTS department;


-- Table Creation
CREATE TABLE department (
  name VARCHAR(200) NOT NULL,
  CONSTRAINT pk_department PRIMARY KEY(name)
);

CREATE TABLE employee (
  ssn INTEGER NOT NULL,
  tin VARCHAR(20) NOT NULL UNIQUE,
  bdate DATE NOT NULL,
  name VARCHAR(80) NOT NULL,
  CONSTRAINT pk_employee PRIMARY KEY(ssn)
);

CREATE TABLE workplace (
  address VARCHAR(255) NOT NULL,
  latitude NUMERIC(8, 6) NOT NULL,
  longitude NUMERIC(9, 6) NOT NULL,
  CONSTRAINT pk_workplace PRIMARY KEY(address),
  UNIQUE(latitude, longitude),
  CHECK(latitude BETWEEN -90 AND 90 ),
  CHECK(longitude BETWEEN -180 AND 180)
);

CREATE TABLE works (
  ssn INTEGER NOT NULL,
  address VARCHAR(255) NOT NULL,
  name VARCHAR(200) NOT NULL, 
  CONSTRAINT pk_works PRIMARY KEY(ssn, address, name),
  CONSTRAINT fk_works_employee FOREIGN KEY(ssn) REFERENCES employee(ssn),
  CONSTRAINT fk_works_workplace FOREIGN KEY(address) REFERENCES workplace(address),
  CONSTRAINT fk_works_department FOREIGN KEY(name) REFERENCES department(name)
);

CREATE TABLE office (
  address VARCHAR(255) NOT NULL,
  CONSTRAINT pk_office PRIMARY KEY(address),
  CONSTRAINT fk_office_workplace FOREIGN KEY(address) REFERENCES workplace(address)
);

CREATE TABLE warehouse (
  address VARCHAR(255) NOT NULL,  
  CONSTRAINT pk_warehouse PRIMARY KEY(address),
  CONSTRAINT fk_warehouse_workplace FOREIGN KEY(address) REFERENCES workplace(address)
);

CREATE TABLE customer (
  -- Customers can only pay for an order they have placed themselves
  customer_no INTEGER NOT NULL,  
  name VARCHAR(80) NOT NULL,       
  email VARCHAR(254) NOT NULL UNIQUE,
  phone VARCHAR(15) NOT NULL,
  address VARCHAR(255) NOT NULL,
  CONSTRAINT pk_customer PRIMARY KEY(customer_no)
);

CREATE TABLE orders (
  order_no INTEGER NOT NULL,
  odate DATE NOT NULL,
  customer_no INTEGER NOT NULL,
  CONSTRAINT pk_orders PRIMARY KEY(order_no),
  CONSTRAINT fk_orders_customer FOREIGN KEY(customer_no) REFERENCES customer(customer_no)
);

CREATE TABLE processes (
  ssn INTEGER NOT NULL,
  order_no INTEGER NOT NULL,
  CONSTRAINT pk_processes PRIMARY KEY(ssn, order_no),
  CONSTRAINT fk_processes_employee FOREIGN KEY(ssn) REFERENCES employee(ssn),
  CONSTRAINT fk_processes_orders FOREIGN KEY(order_no) REFERENCES orders(order_no)
);

CREATE TABLE sale (
  order_no INTEGER NOT NULL,
  CONSTRAINT pk_sale PRIMARY KEY(order_no),
  CONSTRAINT fk_sale_orders FOREIGN KEY(order_no) REFERENCES orders(order_no)
);

CREATE TABLE pay (
  -- Customers can only pay for an order they have placed themselves
  order_no INTEGER NOT NULL,
  customer_no INTEGER NOT NULL,
  CONSTRAINT pk_pay PRIMARY KEY(order_no),
  CONSTRAINT fk_pay_sale FOREIGN KEY(order_no) REFERENCES sale(order_no),
  CONSTRAINT fk_pay_customer FOREIGN KEY(customer_no) REFERENCES customer(customer_no)
  
);

CREATE TABLE product (
  -- A product must take part in the suplly-contract association
  sku INTEGER NOT NULL,
  name VARCHAR(80) NOT NULL,
  description VARCHAR(255) NOT NULL,
  price NUMERIC(16,4) NOT NULL,
  CONSTRAINT pk_product PRIMARY KEY(sku),
  CHECK(price >= 0) 
);

CREATE TABLE ean_product (
  sku INTEGER NOT NULL,
  ean INTEGER NOT NULL,
  CONSTRAINT pk_ean_product PRIMARY KEY(sku),
  CONSTRAINT fk_ean_product_product FOREIGN KEY(sku) REFERENCES product(sku)
);

CREATE TABLE contains (
  quantity INTEGER NOT NULL,
  order_no INTEGER NOT NULL,
  sku INTEGER NOT NULL,
  CONSTRAINT pk_contains PRIMARY KEY(order_no, sku),
  CONSTRAINT fk_contains_orders FOREIGN KEY(order_no) REFERENCES orders(order_no),
  CONSTRAINT fk_contains_product FOREIGN KEY(sku) REFERENCES product(sku),
  CHECK(quantity > 0)

);

CREATE TABLE supplier (
  name VARCHAR(200) NOT NULL,
  address VARCHAR(255) NOT NULL,
  tin VARCHAR(20) NOT NULL,
  sku INTEGER NOT NULL,
  cdate DATE NOT NULL,
  CONSTRAINT pk_supplier PRIMARY KEY(tin),
  CONSTRAINT fk_supplier_product FOREIGN KEY(sku) REFERENCES product(sku)
);

CREATE TABLE delivery (
  -- Address must be in the warehouse table
  address VARCHAR(255) NOT NULL,
  tin VARCHAR(20) NOT NULL,
  CONSTRAINT pk_delivery PRIMARY KEY(address, tin),
  CONSTRAINT fk_delivery_warehouse FOREIGN KEY(address) REFERENCES warehouse(address),
  CONSTRAINT fk_delivery_supplier FOREIGN KEY(tin) REFERENCES supplier(tin)
);
