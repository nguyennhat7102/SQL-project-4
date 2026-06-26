-- Tạo khoá chính cho các bảng để tạo các khoá tham chiếu.

ALTER TABLE products
ADD CONSTRAINT pk_products
PRIMARY KEY ("ProductKey");

ALTER TABLE customer
ADD CONSTRAINT pk_customer
PRIMARY KEY ("CustomerKey");

ALTER TABLE geography
ADD CONSTRAINT pk_geography
PRIMARY KEY ("GeographyKey");

ALTER TABLE date
ADD CONSTRAINT pk_date
PRIMARY KEY ("DateKey");

-- Tạo khoá tham chiếu để dựng mối quan hệ giữa fact và demension (mặc dù sẽ chậm về ETL nhưng đảm bảo toàn vẹn dữ liệu)

ALTER TABLE sales
ADD CONSTRAINT fk_sales_product
FOREIGN KEY ("ProductKey")
REFERENCES products("ProductKey");

ALTER TABLE sales
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY ("CustomerKey")
REFERENCES customer("CustomerKey");

ALTER TABLE sales
ADD CONSTRAINT fk_sales_date
FOREIGN KEY ("OrderDateKey")
REFERENCES date("DateKey"); 

ALTER TABLE dim_customer 
ADD CONSTRAINT fk_customer_geo
FOREIGN KEY (geography_key)
REFERENCES dim_geography (geography_key);



---------------------------------------

ALTER TABLE sales
RENAME COLUMN "SalesTerritoryKey" TO "GeographyKey";

-- Ép kiểu dữ liệu về dạng chuẩn
UPDATE
	products
SET
	"StandardCost" = NULL
WHERE
	TRIM("StandardCost") = 'NULL';


ALTER TABLE products
ALTER COLUMN "StandardCost"
TYPE NUMERIC(18, 2)
	USING "StandardCost"::NUMERIC(18, 2);


SELECT
	*
FROM
	products p
WHERE
	"StandardCost" IS NULL;


ALTER TABLE sales
ALTER COLUMN "SalesAmount"
TYPE NUMERIC(18, 2)
	USING "SalesAmount"::NUMERIC(18, 2);

ALTER TABLE sales
ALTER COLUMN "ProductStandardCost"
TYPE NUMERIC(18, 2)
	USING "ProductStandardCost"::NUMERIC(18, 2);

ALTER TABLE date
ALTER COLUMN "Date"
TYPE Date
	USING "Date"::Date;

-------------------------------------------

ALTER TABLE products
ALTER COLUMN "ProductKey" SET NOT NULL;

ALTER TABLE customer 
ALTER COLUMN "CustomerKey" SET NOT NULL;

ALTER TABLE date
ALTER COLUMN "DateKey" SET NOT NULL;

ALTER TABLE geography 
ALTER COLUMN "GeographyKey" SET NOT NULL;

---------------------------------------------

SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM geography;
SELECT COUNT(*) FROM date;

---------------------------------------------
-- Tạo indexing 
CREATE INDEX idx_sales_product
ON sales("ProductKey");

CREATE INDEX idx_sales_customer
ON sales("CustomerKey");

CREATE INDEX idx_sales_date
ON sales("OrderDateKey");

CREATE INDEX idx_sales_geo
ON sales("GeographyKey");

---------------------------------------------

ALTER TABLE sales
RENAME TO fact_sales;

ALTER TABLE dim_products
RENAME TO dim_product;

ALTER TABLE geography
RENAME TO dim_geography;

ALTER TABLE date
RENAME TO dim_date;

ALTER TABLE customer
RENAME TO dim_customer;

---------------------------------------------

ALTER TABLE fact_sales
RENAME COLUMN "ProductKey" TO product_key;

ALTER TABLE fact_sales
RENAME COLUMN "OrderDateKey" TO order_date_key;

ALTER TABLE fact_sales
RENAME COLUMN "CustomerKey" TO customer_key;

ALTER TABLE fact_sales
RENAME COLUMN "GeographyKey" TO geography_key;

ALTER TABLE fact_sales
RENAME COLUMN "OrderQuantity" TO order_quantity;

ALTER TABLE fact_sales
RENAME COLUMN "ProductStandardCost" TO product_standard_cost;

ALTER TABLE fact_sales
RENAME COLUMN "SalesAmount" TO sales_amount;

ALTER TABLE fact_sales
RENAME COLUMN "OrderDate" TO order_date; 

---------------------------------------------

ALTER TABLE dim_customer
RENAME COLUMN "CustomerKey" TO customer_key;

ALTER TABLE dim_customer
RENAME COLUMN "GeographyKey" TO geography_key;

ALTER TABLE dim_customer
RENAME COLUMN "CustomerName" TO customer_name;

ALTER TABLE dim_customer
RENAME COLUMN "BirthDate" TO birth_date;

ALTER TABLE dim_customer
RENAME COLUMN "MaritalStatus" TO marital_status;

ALTER TABLE dim_customer
RENAME COLUMN "Gender" TO gender;

---------------------------------------------

ALTER TABLE dim_date
RENAME COLUMN "DateKey" TO date_key;

ALTER TABLE dim_date
RENAME COLUMN "Date" TO date;

ALTER TABLE dim_date
RENAME COLUMN "Day" TO day_name;

ALTER TABLE dim_date
RENAME COLUMN "Month" TO month_name;

ALTER TABLE dim_date
RENAME COLUMN "Year" TO year;

---------------------------------------------

ALTER TABLE dim_geography
RENAME COLUMN "GeographyKey" TO geography_key;

ALTER TABLE dim_geography
RENAME COLUMN "City" TO city;

ALTER TABLE dim_geography
RENAME COLUMN "CountryName" TO country_name;

ALTER TABLE dim_geography
RENAME COLUMN "SalesTerritoryRegion" TO sales_territory_region;

ALTER TABLE dim_geography
RENAME COLUMN "SalesTerritoryGroup" TO sales_territory_group;

ALTER TABLE dim_geography
RENAME COLUMN "PostalCode" TO postal_code;

ALTER TABLE dim_geography
RENAME COLUMN "SalesTerritoryKey" TO sales_territory_key;

-------------------------------------------------

ALTER TABLE dim_product
RENAME COLUMN "ProductKey" TO product_key;

ALTER TABLE dim_product
RENAME COLUMN "ProductSubcategoryKey" TO product_subcategory_key;

ALTER TABLE dim_product
RENAME COLUMN "ProductName" TO product_name;

ALTER TABLE dim_product
RENAME COLUMN "Category" TO category;

ALTER TABLE dim_product
RENAME COLUMN "SubCategory" TO sub_category;

ALTER TABLE dim_product
RENAME COLUMN "StandardCost" TO standard_cost;

ALTER TABLE dim_product
RENAME COLUMN "Color" TO color;

ALTER TABLE dim_product
RENAME COLUMN "ModelName" TO model_name;

ALTER TABLE dim_product
RENAME COLUMN "Status" TO status;























