/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
      Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/

USE [OlistDW];
GO

IF SCHEMA_ID('silver') IS NULL
    EXEC('CREATE SCHEMA silver');
GO

IF OBJECT_ID('silver.olist_customers_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_customers_dataset;
GO

CREATE TABLE silver.olist_customers_dataset
(
    customer_id               VARCHAR(32) NOT NULL,
    customer_unique_id        VARCHAR(32) NOT NULL,
    customer_zip_code_prefix  VARCHAR(10),
    customer_city             NVARCHAR(100),
    customer_state            CHAR(2),

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_customers
        PRIMARY KEY (customer_id)
);
GO


IF OBJECT_ID('silver.olist_geolocation_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_geolocation_dataset;
GO

CREATE TABLE silver.olist_geolocation_dataset
(
    geolocation_id INT IDENTITY(1,1) NOT NULL,

    geolocation_zip_code_prefix  VARCHAR(10),
    geolocation_lat              DECIMAL(11, 8),
    geolocation_lng              DECIMAL(11, 8),
    geolocation_city             NVARCHAR(100),
    geolocation_state            CHAR(2),

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_geolocation
        PRIMARY KEY (geolocation_id)
);
GO


IF OBJECT_ID('silver.olist_order_items_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_items_dataset;
GO

CREATE TABLE silver.olist_order_items_dataset
(
    order_id             VARCHAR(32) NOT NULL,
    order_item_id        INT NOT NULL,
    product_id           VARCHAR(32) NOT NULL,
    seller_id            VARCHAR(32) NOT NULL,
    shipping_limit_date  DATETIME,
    price                DECIMAL(12, 2),
    freight_value        DECIMAL(12, 2),

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_order_items
        PRIMARY KEY (order_id, order_item_id)
);
GO

IF OBJECT_ID('silver.olist_order_payments_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_payments_dataset;
GO

CREATE TABLE silver.olist_order_payments_dataset
(
    order_id                VARCHAR(32) NOT NULL,
    payment_sequential      INT NOT NULL,
    payment_type            VARCHAR(30),
    payment_installments    INT,
    payment_value           DECIMAL(12, 2),

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_order_payments
        PRIMARY KEY (order_id, payment_sequential)
);
GO

IF OBJECT_ID('silver.olist_order_reviews_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_reviews_dataset;
GO

CREATE TABLE silver.olist_order_reviews_dataset
(
    review_id                VARCHAR(32) NOT NULL,
    order_id                 VARCHAR(32) NOT NULL,
    review_score             INT,
    review_comment_title     NVARCHAR(500),
    review_comment_message   NVARCHAR(MAX),
    review_creation_date     DATETIME2(0),
    review_answer_timestamp  DATETIME2(0),

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_order_reviews
        PRIMARY KEY (review_id, order_id)
);
GO

IF OBJECT_ID('silver.olist_orders_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_orders_dataset;
GO

CREATE TABLE silver.olist_orders_dataset
(
    order_id                        VARCHAR(32) NOT NULL,
    customer_id                     VARCHAR(32) NOT NULL,
    order_status                    VARCHAR(20) NOT NULL,
    order_purchase_timestamp        DATETIME,
    order_approved_at               DATETIME,
    order_delivered_carrier_date    DATETIME,
    order_delivered_customer_date   DATETIME,
    order_estimated_delivery_date   DATETIME,

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_orders
        PRIMARY KEY (order_id)
);
GO

IF OBJECT_ID('silver.olist_products_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_products_dataset;
GO

CREATE TABLE silver.olist_products_dataset
(
    product_id                  VARCHAR(32) NOT NULL,
    product_category_name       NVARCHAR(100),
    product_name_lenght         INT,
    product_description_length  INT,
    product_photos_qty          INT,
    product_weight_g            INT,
    product_length_cm           INT,
    product_height_cm           INT,
    product_width_cm            INT,

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_products
        PRIMARY KEY (product_id)
);
GO

IF OBJECT_ID('silver.olist_sellers_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_sellers_dataset;
GO

CREATE TABLE silver.olist_sellers_dataset
(
    seller_id               VARCHAR(32) NOT NULL,
    seller_zip_code_prefix  VARCHAR(10),
    seller_city             NVARCHAR(100),
    seller_state            CHAR(2),

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_sellers
        PRIMARY KEY (seller_id)
);
GO


IF OBJECT_ID('silver.product_category_name_translation', 'U') IS NOT NULL
    DROP TABLE silver.product_category_name_translation;
GO

CREATE TABLE silver.product_category_name_translation
(
    translation_id INT IDENTITY(1,1) NOT NULL,

    product_category_name          NVARCHAR(100) NOT NULL,
    product_category_name_english  NVARCHAR(100),

    dwh_create_date           DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_silver_product_category_name_translation
        PRIMARY KEY (translation_id),

    CONSTRAINT uq_silver_product_category_name
        UNIQUE(product_category_name)
);
GO
