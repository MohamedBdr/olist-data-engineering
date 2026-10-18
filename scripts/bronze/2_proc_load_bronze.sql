/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
      This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

Note:
    The BULK INSERT paths point to 'E:\Projects\olist-data-engineering\data\'.
===============================================================================
*/
USE [OlistDW];
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '========================================';
           
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_customers_dataset';
        TRUNCATE TABLE bronze.olist_customers_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_customers_dataset';
        BULK INSERT bronze.olist_customers_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_customers_dataset.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_geolocation_dataset';
        TRUNCATE TABLE bronze.olist_geolocation_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_geolocation_dataset';
        BULK INSERT bronze.olist_geolocation_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_geolocation_dataset.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_items_dataset';
        TRUNCATE TABLE bronze.olist_order_items_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_order_items_dataset';
        BULK INSERT bronze.olist_order_items_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_order_items_dataset.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_payments_dataset';
        TRUNCATE TABLE bronze.olist_order_payments_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_order_payments_dataset';
        BULK INSERT bronze.olist_order_payments_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_order_payments_dataset.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_reviews_dataset';
        TRUNCATE TABLE bronze.olist_order_reviews_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_order_reviews_dataset';
        BULK INSERT bronze.olist_order_reviews_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_order_reviews_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_orders_dataset';
        TRUNCATE TABLE bronze.olist_orders_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_orders_dataset';
        BULK INSERT bronze.olist_orders_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_orders_dataset.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_products_dataset';
        TRUNCATE TABLE bronze.olist_products_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_products_dataset';
        BULK INSERT bronze.olist_products_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_products_dataset.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_sellers_dataset';
        TRUNCATE TABLE bronze.olist_sellers_dataset;

        PRINT '>> Inserting Data Into: bronze.olist_sellers_dataset';
        BULK INSERT bronze.olist_sellers_dataset
        FROM 'E:\Projects\olist-data-engineering\data\olist_sellers_dataset.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';

        --
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.product_category_name_translation';
        TRUNCATE TABLE bronze.product_category_name_translation;

        PRINT '>> Inserting Data Into: bronze.product_category_name_translation';
        BULK INSERT bronze.product_category_name_translation
        FROM 'E:\Projects\olist-data-engineering\data\product_category_name_translation.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIRSTROW = 2,
            CODEPAGE = '65001',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '## Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------';
        PRINT '';


        SET @batch_end_time = GETDATE();
        PRINT '========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '========================================';

    END TRY

    BEGIN CATCH
        PRINT '----------------------------------------'
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '----------------------------------------'
    END CATCH
END