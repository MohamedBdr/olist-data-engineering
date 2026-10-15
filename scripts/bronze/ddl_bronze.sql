/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
      Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

USE [OlistDW];
GO

IF OBJECT_ID('bronze.olist_customers_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_customers_dataset;
GO

CREATE TABLE bronze.olist_customers_dataset
(
    customer_id               VARCHAR(32) NOT NULL,
    customer_unique_id        VARCHAR(32) NOT NULL,
    customer_zip_code_prefix  VARCHAR(10),
    customer_city             NVARCHAR(100),
    customer_state            CHAR(2)
);
GO


IF OBJECT_ID('bronze.olist_geolocation_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_geolocation_dataset;
GO

CREATE TABLE bronze.olist_geolocation_dataset
(
    geolocation_zip_code_prefix  VARCHAR(10),
    geolocation_lat              DECIMAL(11, 15),
    geolocation_lng              DECIMAL(11, 15),
    geolocation_city             NVARCHAR(100),
    geolocation_state            CHAR(2)
);
GO


IF OBJECT_ID('bronze.olist_order_items_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_items_dataset;
GO

CREATE TABLE bronze.olist_order_items_dataset
(
    order_id             VARCHAR(50) NOT NULL,
    order_item_id        INT NOT NULL,
    product_id           VARCHAR(50) NOT NULL,
    seller_id            VARCHAR(50) NOT NULL,
    shipping_limit_date  DATETIME,
    price                DECIMAL(12, 2),
    freight_value        DECIMAL(12, 2)
);
GO

IF OBJECT_ID('bronze.olist_order_payments_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_payments_dataset;
GO

CREATE TABLE bronze.olist_order_payments_dataset
(
    order_id                VARCHAR(50) NOT NULL,
    payment_sequential      INT NOT NULL,
    payment_type            VARCHAR(30),
    payment_installments    INT,
    payment_value           DECIMAL(12, 2)
);
GO

IF OBJECT_ID('bronze.olist_order_reviews_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_reviews_dataset;
GO

CREATE TABLE bronze.olist_order_reviews_dataset
(
    review_id                VARCHAR(50) NOT NULL,
    order_id                 VARCHAR(50) NOT NULL,
    review_score             INT,
    review_comment_title     NVARCHAR(500),
    review_comment_message   NVARCHAR(MAX),
    review_creation_date     DATETIME2(0),
    review_answer_timestamp  DATETIME2(0)
);
GO

IF OBJECT_ID('bronze.olist_orders_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_orders_dataset;
GO

CREATE TABLE bronze.olist_orders_dataset
(
    order_id                        VARCHAR(50) NOT NULL,
    customer_id                     VARCHAR(50) NOT NULL,
    order_status                    VARCHAR(20) NOT NULL,
    order_purchase_timestamp        DATETIME,
    order_approved_at               DATETIME,
    order_delivered_carrier_date    DATETIME,
    order_delivered_customer_date   DATETIME,
    order_estimated_delivery_date   DATETIME
);
GO

IF OBJECT_ID('bronze.olist_products_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_products_dataset;
GO

CREATE TABLE bronze.olist_products_dataset
(
    product_id                  VARCHAR(50) NOT NULL,
    product_category_name       NVARCHAR(100),
    product_name_lenght         INT,
    product_description_lenght  INT,
    product_photos_qty          INT,
    product_weight_g            INT,
    product_length_cm           INT,
    product_height_cm           INT,
    product_width_cm            INT
);
GO

IF OBJECT_ID('bronze.olist_sellers_dataset', 'U') IS NOT NULL
    DROP TABLE bronze.olist_sellers_dataset;
GO

CREATE TABLE bronze.olist_sellers_dataset
(
    seller_id               VARCHAR(50) NOT NULL,
    seller_zip_code_prefix  VARCHAR(10),
    seller_city             NVARCHAR(100),
    seller_state            CHAR(2)
);
GO


IF OBJECT_ID('bronze.product_category_name_translation', 'U') IS NOT NULL
    DROP TABLE bronze.product_category_name_translation;
GO

CREATE TABLE bronze.product_category_name_translation
(
    product_category_name          NVARCHAR(100) NOT NULL,
    product_category_name_english  NVARCHAR(100)
);
GO
