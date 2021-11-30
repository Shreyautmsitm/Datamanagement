--Dropping sequence
DROP SEQUENCE vendor_id_seq;
DROP SEQUENCE product_id_seq;
DROP SEQUENCE inventory_id_seq;
DROP SEQUENCE location_id_seq;


---CREATE SEQUENCE FOR VENDOR
CREATE SEQUENCE vendor_id_seq
START WITH 10 INCREMENT BY 1;

---CREATE SEQUENCE FOR PRODUCT_DETAIL
CREATE SEQUENCE product_id_seq
START WITH 1000 INCREMENT BY 1;

---CREATE SEQUENCE FOR LOCATION
CREATE SEQUENCE location_id_seq
START WITH 10 INCREMENT BY 1;

---CREATE SEQUENCE FOR INVENTORY_MAIN
CREATE SEQUENCE inventory_id_seq
START WITH 100 INCREMENT BY 1;


-------------------------
----DROP STATEMENTS
-------------------------

--drops for tables
DROP TABLE store_inventory_history;
DROP TABLE warehouse_distribution_history;
DROP TABLE product_detail;
DROP TABLE inventory_main;
DROP TABLE location;
DROP TABLE warehouse;
DROP TABLE store;
DROP TABLE vendor;
DROP TABLE category;
DROP TABLE department;

-------creates for tables
CREATE TABLE vendor (
  vendor_id                 NUMBER(5)       DEFAULT vendor_id_seq.NEXTVAL    PRIMARY KEY,
  vendor_name               VARCHAR(50)     NOT NULL UNIQUE,
  account_number            VARCHAR(15),
  credit_rating             NUMBER(5),
  vendor_address            VARCHAR(50) NOT NULL,
  vendor_city               VARCHAR(30) NOT NULL,
  vendor_state              VARCHAR(2),
  vendor_zip                VARCHAR(5),
  vendor_phone              CHAR(12)    NOT NULL,
  web_url                   VARCHAR(30),
  vendor_description        VARCHAR(500),
  vendor_contact_first_name VARCHAR(30),
  vendor_contact_last_name  VARCHAR(30)
);
 
CREATE TABLE store (
  store_id       NUMBER         NOT NULL  PRIMARY KEY,
  store_status   CHAR(1)        NOT NULL,
  store_name     VARCHAR(30)    NOT NULL UNIQUE,
  store_phone    CHAR(12)       NOT NULL,
  address_line_1 VARCHAR(30),
  address_line_2 VARCHAR(30)
  CONSTRAINT    store_status_check  CHECK (store_status IN ('A','I'))
);
 
CREATE TABLE department (
  department_id   NUMBER(5)     NOT NULL PRIMARY KEY,
  department_name VARCHAR(30)   NOT NULL UNIQUE
);

CREATE TABLE category (
  category_id     NUMBER(5)        PRIMARY KEY,
  department_id   NUMBER(5)        NOT NULL ,
  category_name   VARCHAR(30)      NOT NULL UNIQUE,
  CONSTRAINT    department_id_fk   FOREIGN KEY (department_id)   REFERENCES DEPARTMENT (department_id)
);

CREATE TABLE inventory_main (
  inventory_id     NUMBER(5)  DEFAULT inventory_id_seq.NEXTVAL  PRIMARY KEY,
  store_id         NUMBER(5)  NOT NULL,  
  department_id    NUMBER(5)  NOT NULL,
  CONSTRAINT    store_id_fk1            FOREIGN KEY (store_id)          REFERENCES store (store_id),
  CONSTRAINT    department_id_fk1       FOREIGN KEY (department_id)     REFERENCES department (department_id)
); 


CREATE TABLE warehouse (
    warehouse_id    NUMBER(5)   PRIMARY KEY,
    warehouse_name  NUMBER(10)  NOT NULL,
    warehouse_phone CHAR(12)
);

CREATE TABLE location (
    location_id         NUMBER(5)   DEFAULT location_id_seq.NEXTVAL   PRIMARY KEY,
    warehouse_id        NUMBER(5)   UNIQUE,
    store_id            NUMBER(5)   UNIQUE,
    location_type       VARCHAR(20) NOT NULL,
    location_address    VARCHAR(30),
    location_city       VARCHAR(30),
    location_state      VARCHAR(30),
    location_zip        CHAR(5),
    CONSTRAINT warehouse_id_fk1 FOREIGN KEY (warehouse_id)  REFERENCES warehouse (warehouse_id)
);

CREATE TABLE product_detail (
    product_id          NUMBER(6)   DEFAULT product_id_seq.NEXTVAL   PRIMARY KEY,
    category_id         NUMBER(2)   NOT NULL,
    vendor_id           NUMBER(5)   NOT NULL,
    warehouse_id        NUMBER(5)   NOT NULL,
    product_name        VARCHAR(50) NOT NULL, 
    barcode_num         NUMBER(20)   NOT NULL UNIQUE,
    product_status      CHAR(1)     NOT NULL,
    unit_sales_price    FLOAT(15)   NOT NULL,
    unit_cost_price     FLOAT(15)   NOT NULL,
    color               VARCHAR(50),
    product_size        VARCHAR(30),
    description         VARCHAR(500),
    CONSTRAINT category_id_fk1  FOREIGN KEY (category_id)   REFERENCES category(category_id),
    CONSTRAINT vendor_id_fk2    FOREIGN KEY (vendor_id)     REFERENCES vendor (vendor_id),
    CONSTRAINT warehouse_id_fk2 FOREIGN KEY (warehouse_id)  REFERENCES warehouse (warehouse_id)
);

CREATE TABLE warehouse_distribution_history (
    inventory_id        NUMBER(5)   NOT NULL,
    warehouse_id        NUMBER(5)   NOT NULL,
    date_first_stock    DATE        NOT NULL,
    date_latest_stock   DATE        NOT NULL,
    date_first_ship     DATE,
    date_latest_ship    DATE,
    stock_status        CHAR(1)     NOT NULL,
    quantity_in_stock   NUMBER(10)  NOT NULL,
    quantity_shipped    NUMBER(10),
    warehouse_aisle     NUMBER(3),
    warehouse_shelf     NUMBER(3),
    CONSTRAINT warehouse_distribution_pk PRIMARY KEY (inventory_id, warehouse_id),
    CONSTRAINT inventory_id_fk1 FOREIGN KEY (inventory_id)  REFERENCES inventory_main (inventory_id),
    CONSTRAINT warehouse_id_fk3 FOREIGN KEY (warehouse_id)  REFERENCES warehouse (warehouse_id)
);

CREATE TABLE store_inventory_history (
    product_id          NUMBER(6)   NOT NULL,
    store_id            NUMBER(5)   NOT NULL,
    store_quantity      NUMBER(5)   NOT NULL,
    store_stock_status  CHAR(1)     NOT NULL,
    store_aisle         NUMBER(3),
    store_shelf         NUMBER(3),
    storage_aisle       NUMBER(3),
    storage_shelf       NUMBER(3),
    shipment_arrival    DATE        NOT NULL,
    packaging_type      VARCHAR(15),
    CONSTRAINT store_inventory_pk   PRIMARY KEY (product_id, store_id),
    CONSTRAINT product_id_fk1       FOREIGN KEY (product_id)    REFERENCES product_detail (product_id),
    CONSTRAINT store_id_fk2         FOREIGN KEY (store_id)      REFERENCES store (store_id)
);

-- vendor inserts
INSERT INTO vendor (vendor_name, account_number, credit_rating, vendor_address, vendor_city, vendor_state,
                    vendor_zip, vendor_phone, web_url, vendor_description, vendor_contact_first_name, 
                    vendor_contact_last_name)
            VALUES ('Tuttle and Co.', '5729281920', 820, '2000 Speedway', 'Austin', 'TX', '78705', '512-428-2991',
                    'tuttleandco.com', 'They sell kitchen stuff.', 'Clint', 'Tuttle');
INSERT INTO vendor (vendor_name, account_number, credit_rating, vendor_address, vendor_city, vendor_state,
                    vendor_zip, vendor_phone, web_url, vendor_description)
            VALUES ('Hartzell Farms', '928000291024', 750, '29194 Jay Blvd.', 'Austin', 'TX', '78705', '512-235-2245',
                    'hartzellfarms.com', 'Veggies galore!');
INSERT INTO vendor (vendor_name, account_number, credit_rating, vendor_address, vendor_city, vendor_state,
                    vendor_zip, vendor_phone, web_url, vendor_description)
            VALUES ('Nuggets and More', '572910259955', 800, '58934 Chick Chick Ln.', 'Savannah', 'GA', '72841', '435-231-3387',
                    'nuggetsandmore.com', 'They sell nuggets and other stuff like that.');
COMMIT;

-- store inserts
INSERT INTO store(store_id, store_status, store_name, store_phone, address_line_1) 
            VALUES (200, 'A', 'MART', '827-248-2399', '700 Lighthouse Ln.');
INSERT INTO store(store_id, location_id, store_status, store_name, store_phone, address_line_1 ) 
            VALUES (201, 'A', 'MARTJ', '482-484-2841', '8822 Corner St.');
INSERT INTO store(store_id, location_id, store_status, store_name, store_phone, address_line_1 , address_line_2) 
            VALUES (202,'I', 'MARTL', '229-339-2910', '2732 Lucky Av.', 'Unit 561');
COMMIT;

-- department inserts
INSERT INTO department (department_id, department_name) 
            VALUES (110, 'frozen food');
INSERT INTO department (department_id, department_name) 
            VALUES (111, 'Home and Outdoor');

-- category inserts
INSERT INTO category (category_id, department_id, category_name) 
            VALUES (210, 110, 'veggies');
INSERT INTO category (category_id, department_id, category_name) 
            VALUES (211,110, 'nuggets');
INSERT INTO category (category_id, department_id, category_name) 
            VALUES (212, 111, 'kitchen');
            
-- inventory inserts
INSERT INTO inventory_main (store_id, department_id)
            VALUES (200, 110);
INSERT INTO inventory_main (store_id, department_id)
            VALUES (200, 111);
INSERT INTO inventory_main (store_id, department_id)
            VALUES (201, 110);
INSERT INTO inventory_main (store_id, department_id)
            VALUES (202, 111);
COMMIT;

-- warehouse inserts
INSERT INTO warehouse (warehouse_id, warehouse_name, warehouse_phone)
            VALUES (3000, 111000, '422-683-2920');
INSERT INTO warehouse (warehouse_id, warehouse_name, warehouse_phone)
            VALUES (3001, 111001, '592-501-4481');
INSERT INTO warehouse (warehouse_id, warehouse_name, warehouse_phone)
            VALUES (3002, 111006, '929-291-7284');
COMMIT;

-- location inserts
INSERT INTO location (warehouse_id, location_type, location_address, 
                      location_city, location_state, location_zip)
            VALUES (3001, 'Warehouse', '4858 Bevo Blvd.', 'Austin', 'TX',
                    '78705');
INSERT INTO location (warehouse_id, location_type, location_address, 
                      location_city, location_state, location_zip)
            VALUES (3002, 'Warehouse', '582 Texas St.', 'Oklahoma City', 'OK',
                    '77291');
INSERT INTO location (warehouse_id, location_type, location_address, 
                      location_city, location_state, location_zip)
            VALUES (3000, 'Warehouse', '91 Backpack Av.', 'Boston', 'MA',
                    '79102');
INSERT INTO location (store_id, location_type, location_address, 
                      location_city, location_state, location_zip)
            VALUES (200, 'Store', '811 Franklin St.', 'Sacramento', 'CA',
                    '79281');
INSERT INTO location (store_id, location_type, location_address, 
                      location_city, location_state, location_zip)
            VALUES (201, 'Store', '72471 Miracle Dr.', 'San Diego', 'CA',
                    '72914');
INSERT INTO location (store_id, location_type, location_address, 
                      location_city, location_state, location_zip)
            VALUES (202, 'Store', '700 Victoria St.', 'Portland', 'OR',
                    '70244');
COMMIT;

-- product inserts
INSERT INTO product_detail (category_id, vendor_id, warehouse_id, product_name,
                            barcode_num, product_status, unit_sales_price, 
                            unit_cost_price)
            VALUES (210, 11, 3000, 'Organic Lettuce', 4820481924, 'A', 1.20, 0.65);
INSERT INTO product_detail (category_id, vendor_id, warehouse_id, product_name,
                            barcode_num, product_status, unit_sales_price, 
                            unit_cost_price)
            VALUES (210, 11, 3001, 'Spinach', 4820481923, 'A', 1.00, 0.40);
INSERT INTO product_detail (category_id, vendor_id, warehouse_id, product_name,
                            barcode_num, product_status, unit_sales_price, 
                            unit_cost_price)
            VALUES (212, 10, 3001, 'Blender', 2949285014, 'I', 79.99, 59.99); 
INSERT INTO product_detail (category_id, vendor_id, warehouse_id, product_name,
                            barcode_num, product_status, unit_sales_price, 
                            unit_cost_price)
            VALUES (211, 12, 3002, 'Dinosaur Nuggets', 58295194812, 'A', 3.99, 1.40); 
COMMIT;

-- warehouse distribution inserts
INSERT INTO warehouse_distribution_history (inventory_id, warehouse_id, date_first_stock,
                                            date_latest_stock, date_first_ship, date_latest_ship,
                                            stock_status, quantity_in_stock, quantity_shipped,
                                            warehouse_aisle, warehouse_shelf)
            VALUES (100, 3002, '07-APR-2016', '20-NOV-2021', '12-APR-2016', '25-NOV-2021', 'I',
                    1000, 10200, 245, 599);
INSERT INTO warehouse_distribution_history (inventory_id, warehouse_id, date_first_stock,
                                            date_latest_stock, date_first_ship, date_latest_ship,
                                            stock_status, quantity_in_stock, quantity_shipped,
                                            warehouse_aisle, warehouse_shelf)
            VALUES (100, 3001, '01-JAN-2012', '07-NOV-2021', '10-JAN-2012', '13-NOV-2021', 'I',
                    500, 15100, 592, 550);
INSERT INTO warehouse_distribution_history (inventory_id, warehouse_id, date_first_stock,
                                            date_latest_stock, date_first_ship, date_latest_ship,
                                            stock_status, quantity_in_stock, quantity_shipped,
                                            warehouse_aisle, warehouse_shelf)
            VALUES (101, 3000, '18-JUL-2019', '31-OCT-2021', '21-JUL-2019', '02-NOV-2021', 'A',
                    78, 870, 492, 102);
INSERT INTO warehouse_distribution_history (inventory_id, warehouse_id, date_first_stock,
                                            date_latest_stock, date_first_ship, date_latest_ship,
                                            stock_status, quantity_in_stock, quantity_shipped,
                                            warehouse_aisle, warehouse_shelf)
            VALUES (102, 3000, '21-AUG-2014', '20-OCT-2021', '30-AUG-2014', '20-NOV-2021', 'A',
                    91, 830, 194, 951);
COMMIT;

-- store inventory inserts
INSERT INTO store_inventory_history (product_id, store_id, store_quantity, store_stock_status, 
                                     store_aisle, store_shelf, storage_aisle, storage_shelf, 
                                     shipment_arrival, packaging_type)
            VALUES (1000, 200, 90, 'A', 28, 10, 285, 291, '30-NOV-2021', 'Box');
INSERT INTO store_inventory_history (product_id, store_id, store_quantity, store_stock_status, 
                                     store_aisle, store_shelf, storage_aisle, storage_shelf, 
                                     shipment_arrival, packaging_type)
            VALUES (1003, 201, 55, 'I', 291, 12, 58, 19, '25-NOV-2021', 'Large Box');
COMMIT;
