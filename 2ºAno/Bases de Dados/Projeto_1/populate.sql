INSERT INTO employee (ssn, tin, bdate, name) values
  (123123123, '111111111', '2003-01-01', 'Jose Cid'),
  (234234234, '333333333', '2003-01-02', 'Rui Veloso'),
  (345345345, '444444444', '2003-02-02', 'Don Quixote'),
  (456456456, '555555555', '2003-03-04', 'Juan'),
  (567567567, '666666666', '2003-10-06', 'Alan Turing'),
  (678678678, '777777777', '2003-11-07', 'Djikstra'),
  (789789789, '888888888', '2003-01-12', 'Florence Prim');

INSERT INTO department (name) values
  ('Sales'),
  ('Marketing'),
  ('Finances'),
  ('Investments'),
  ('Software'),
  ('Human Resources');

INSERT INTO workplace (address, latitude, longitude) values
  ('Massama', 38.755510, -9.277690),
  ('Casal de Cambra', 38.794020, -9.233970),
  ('Porto', 41.157944, -8.629105),
  ('Coimbra', 40.2033, -8.4103),
  ('Algarve', 37.0180, -7.9308);

INSERT INTO works (ssn, address, name) values
  (123123123, 'Porto', 'Sales'),
  (123123123, 'Algarve', 'Sales'),
  (345345345, 'Massama', 'Human Resources'),
  (567567567, 'Casal de Cambra', 'Software'),
  (678678678, 'Algarve', 'Marketing'),
  (234234234, 'Coimbra', 'Investments'),
  (789789789, 'Casal de Cambra', 'Sales');

INSERT INTO office (address) values
  ('Porto'),
  ('Massama');

INSERT INTO warehouse (address) values
  ('Casal de Cambra'),
  ('Algarve'),
  ('Coimbra');

INSERT INTO customer (customer_no, name, email, phone, address) values
  (132132, 'Pedro Freitas', 'pedro.freitas@gmail.com', 931231234, 'Massama'),
  (243243, 'Francisco Gouveia', 'francisco.gouveia@gmail.com', 961231234, 'Coimbra'),
  (345345, 'Rui Amaral', 'rui.amaral@gmail.com', 911231234, 'Casal de Cambra');

INSERT INTO orders (order_no, odate, customer_no) values
  (117, '2022-12-25', 132132),
  (118, '2022-11-30', 243243),
  (119, '2022-10-05', 345345),
  (120, '2023-01-02', 243243);

INSERT INTO processes (ssn, order_no) values
  (123123123, 117),
  (345345345, 118),
  (789789789, 119),
  (789789789, 120);

INSERT INTO sale (order_no) values
  (117),
  (118);

INSERT INTO pay (order_no, customer_no) values
  (117, 132132);

INSERT INTO product (sku, name, description, price) values
  (747474, 'CIF Limpa-Nodoas', 'Limpa as nodoas', 1.50),
  (121212, 'Mavic Cosmic SL', 'Roda bicicleta', 1350),
  (848484, 'Polpa de Tomate', 'Tomatada', 2.25);

INSERT INTO ean_product (sku, ean) values
  (747474, 12),
  (848484, 13);

INSERT INTO contains (quantity, order_no, sku) values
  (5, 117, 747474),
  (4, 118, 848484),
  (5, 119, 747474),
  (2, 120, 121212),
  (1, 117, 121212);

INSERT INTO supplier (name, address, tin, sku, cdate) values
  ('Guloso', 'Vendas Novas', '123456789', 848484, '2022-01-01'),
  ('CIF', 'Golega', '234567891', 747474, '2022-01-01'),
  ('Mavic Wheels', 'Taiwan', '345678923', 121212, '2022-12-04');

INSERT INTO delivery (address, tin) values
  ('Casal de Cambra', '234567891'), 
  ('Algarve', '123456789');
