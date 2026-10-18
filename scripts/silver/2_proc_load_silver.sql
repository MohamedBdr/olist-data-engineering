/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
    Actions Performed:
        - Truncates Silver tables.
        - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
      This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';
        PRINT '';

        -- Loading silver.olist_customers_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_customers_dataset';
        TRUNCATE TABLE silver.olist_customers_dataset 
        PRINT '>> Inserting Data Into: silver.olist_customers_dataset';

        INSERT INTO silver.olist_customers_dataset (
            customer_id,
            customer_unique_id,
            customer_zip_code_prefix,
            customer_city,
            customer_state
        )
        SELECT
            TRIM(customer_id) AS customer_id,
            TRIM(customer_unique_id) AS customer_unique_id,
            CASE
                WHEN LEN(TRIM(customer_zip_code_prefix)) = 4
                    THEN '0' + TRIM(customer_zip_code_prefix)
                ELSE TRIM(customer_zip_code_prefix)
            END AS customer_zip_code_prefix,
            LOWER(TRIM(customer_city)) AS customer_city,
            UPPER(TRIM(customer_state)) AS customer_state
        FROM [OlistDW].[bronze].[olist_customers_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.olist_geolocation_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_geolocation_dataset';
        TRUNCATE TABLE silver.olist_geolocation_dataset 
        PRINT '>> Inserting Data Into: silver.olist_geolocation_dataset';
        
        INSERT INTO silver.olist_geolocation_dataset (
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            geolocation_city,
            geolocation_state
        )
        SELECT DISTINCT
            TRIM(geolocation_zip_code_prefix) AS geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            LOWER(TRIM(geolocation_city)) AS geolocation_city,
            UPPER(TRIM(geolocation_state)) AS geolocation_state
        FROM [OlistDW].[bronze].[olist_geolocation_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.olist_order_items_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_order_items_dataset';
        TRUNCATE TABLE silver.olist_order_items_dataset 
        PRINT '>> Inserting Data Into: silver.olist_order_items_dataset';

        INSERT INTO [OlistDW].[silver].[olist_order_items_dataset]
        (
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value
        )
        SELECT
            TRIM(order_id),
            order_item_id,
            TRIM(product_id),
            TRIM(seller_id),
            shipping_limit_date,
            price,
            freight_value
        FROM [OlistDW].[bronze].[olist_order_items_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.olist_order_payments_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_order_payments_dataset';
        TRUNCATE TABLE silver.olist_order_payments_dataset 
        PRINT '>> Inserting Data Into: silver.olist_order_payments_dataset';

        INSERT INTO [OlistDW].[silver].[olist_order_payments_dataset]
        (
            order_id,
            payment_sequential,
            payment_type,
            payment_installments,
            payment_value
        )
        SELECT
            TRIM(order_id) AS order_id,
            payment_sequential,
            LOWER(TRIM(payment_type)) AS payment_type,
            payment_installments,
            payment_value
        FROM [OlistDW].[bronze].[olist_order_payments_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.olist_order_reviews_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_order_reviews_dataset';
        TRUNCATE TABLE silver.olist_order_reviews_dataset 
        PRINT '>> Inserting Data Into: silver.olist_order_reviews_dataset';

        INSERT INTO [OlistDW].[silver].[olist_order_reviews_dataset]
        (
            review_id,
            order_id,
            review_score,
            review_comment_title,
            review_comment_message,
            review_creation_date,
            review_answer_timestamp
        )
        SELECT
            TRIM(review_id) AS review_id,
            TRIM(order_id) AS order_id,
            review_score,
            NULLIF(TRIM(review_comment_title), '') AS review_comment_title,
            NULLIF(TRIM(review_comment_message), '') AS review_comment_message,
            review_creation_date,
            review_answer_timestamp
        FROM [OlistDW].[bronze].[olist_order_reviews_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.olist_orders_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_orders_dataset';
        TRUNCATE TABLE silver.olist_orders_dataset 
        PRINT '>> Inserting Data Into: silver.olist_orders_dataset';

        INSERT INTO [OlistDW].[silver].[olist_orders_dataset]
        (
            order_id,
            customer_id,
            order_status,
            order_purchase_timestamp,
            order_approved_at,
            order_delivered_carrier_date,
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
        SELECT
            TRIM(order_id) AS order_id,
            TRIM(customer_id) AS customer_id,
            LOWER(TRIM(order_status)) AS order_status,
            order_purchase_timestamp,
            NULLIF(order_approved_at, '') AS order_approved_at,
            NULLIF(order_delivered_carrier_date, '') AS order_delivered_carrier_date,
            NULLIF(order_delivered_customer_date, '') AS order_delivered_customer_date,
            order_estimated_delivery_date
        FROM [OlistDW].[bronze].[olist_orders_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.olist_products_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_products_dataset';
        TRUNCATE TABLE silver.olist_products_dataset 
        PRINT '>> Inserting Data Into: silver.olist_products_dataset';

        INSERT INTO [OlistDW].[silver].[olist_products_dataset]
        (
            product_id,
            product_category_name,
            product_name_lenght,
            product_description_length,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm
        )
        SELECT
            TRIM(product_id) AS product_id,
            NULLIF(TRIM(product_category_name), '') AS product_category_name,
            product_name_lenght,
            product_description_lenght,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm
        FROM [OlistDW].[bronze].[olist_products_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.olist_sellers_dataset
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.olist_sellers_dataset';
        TRUNCATE TABLE silver.olist_sellers_dataset 
        PRINT '>> Inserting Data Into: silver.olist_sellers_dataset';

        INSERT INTO [OlistDW].[silver].[olist_sellers_dataset]
        (
            seller_id,
            seller_zip_code_prefix,
            seller_city,
            seller_state
        )
        SELECT
            TRIM(seller_id) AS seller_id,
            TRIM(seller_zip_code_prefix) AS seller_zip_code_prefix,
            LOWER(TRIM(seller_city)) AS seller_city,
            UPPER(TRIM(seller_state)) AS seller_state
        FROM [OlistDW].[bronze].[olist_sellers_dataset];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        --------------------------------------------------------
        -- Loading silver.product_category_name_translation
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.product_category_name_translation';
        TRUNCATE TABLE silver.product_category_name_translation 
        PRINT '>> Inserting Data Into: silver.product_category_name_translation';

        INSERT INTO [OlistDW].[silver].[product_category_name_translation]
        (
            product_category_name,
            product_category_name_english
        )
        SELECT
            LOWER(TRIM(product_category_name)) AS product_category_name,
            LOWER(TRIM(product_category_name_english)) AS product_category_name_english
        FROM [OlistDW].[bronze].[product_category_name_translation];

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '';

        SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=========================================='

    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END


