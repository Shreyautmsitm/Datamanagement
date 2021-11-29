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
  vendor_name               VARCHAR(50) NOT NULL UNIQUE,
  account_number            CHAR(30),
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
  store_id       NUMBER NOT NULL  PRIMARY KEY,
  store_status   CHAR(1) NOT NULL,
  store_name     VARCHAR(30) NOT NULL UNIQUE,
  store_phone    CHAR(12) NOT NULL,
  address_line_1 VARCHAR(30),
  address_line_2 VARCHAR(30)
);
 
CREATE TABLE department (
  department_id   NUMBER  NOT NULL PRIMARY KEY,
  department_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE category (
  category_id     NUMBER(2)        PRIMARY KEY,
  department_id   NUMBER           NOT NULL ,
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
    warehouse_phone CHAR(10)
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
    barcode_num         NUMBER(2)   NOT NULL UNIQUE,
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