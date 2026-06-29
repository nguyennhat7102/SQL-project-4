
-- Tạo khoá chính cho các bảng để tạo các khoá tham chiếu.

ALTER TABLE dim_product 
ADD CONSTRAINT pk_product
PRIMARY KEY ("product_key");

ALTER TABLE dim_customer
ADD CONSTRAINT pk_customer
PRIMARY KEY ("customer_key");

ALTER TABLE dim_geography
ADD CONSTRAINT pk_geography
PRIMARY KEY ("geography_key");

ALTER TABLE dim_date 
ADD CONSTRAINT pk_date
PRIMARY KEY ("date_key");

ALTER TABLE dim_sales_territory 
ADD CONSTRAINT pk_sales_territory
PRIMARY KEY ("sales_territory_key");


-- Tạo khoá tham chiếu để dựng mối quan hệ giữa fact và demension (mặc dù sẽ chậm về ETL nhưng đảm bảo toàn vẹn dữ liệu)

ALTER TABLE fact_sales 
ADD CONSTRAINT fk_sales_product
FOREIGN KEY ("product_key")
REFERENCES dim_product("product_key");

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY ("customer_key")
REFERENCES dim_customer("customer_key");

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_date
FOREIGN KEY ("order_date_key")
REFERENCES dim_date("date_key"); 

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_territory
FOREIGN KEY ("sales_territory_key")
REFERENCES dim_sales_territory("sales_territory_key"); 

ALTER TABLE dim_customer 
ADD CONSTRAINT fk_customer_geo
FOREIGN KEY (geography_key)
REFERENCES dim_geography (geography_key);


-- Ép kiểu dữ liệu về dạng chuẩn
ALTER TABLE dim_product
ALTER COLUMN "standard_cost"
TYPE NUMERIC(18, 2)
	USING "standard_cost"::NUMERIC(18, 2);


ALTER TABLE fact_sales
ALTER COLUMN "sales_amount"
TYPE NUMERIC(18, 2)
	USING "sales_amount"::NUMERIC(18, 2);

ALTER TABLE fact_sales
ALTER COLUMN "product_standard_cost"
TYPE NUMERIC(18, 2)
	USING "product_standard_cost"::NUMERIC(18, 2);

-------------------------------------------
ALTER TABLE dim_product
ALTER COLUMN "product_key" SET NOT NULL;

ALTER TABLE dim_customer 
ALTER COLUMN "customer_key" SET NOT NULL;

ALTER TABLE dim_date
ALTER COLUMN "date_key" SET NOT NULL;

ALTER TABLE dim_geography 
ALTER COLUMN "geography_key" SET NOT NULL;

ALTER TABLE dim_sales_territory
ALTER COLUMN "sales_territory_key" SET NOT NULL;

---------------------------------------------
-- Tạo indexing 
CREATE INDEX idx_sales_product
ON fact_sales("product_key");

CREATE INDEX idx_sales_customer
ON fact_sales("customer_key");

CREATE INDEX idx_sales_date
ON fact_sales("order_date_key");

CREATE INDEX idx_sales_geo
ON fact_sales("sales_territory_key");


-- feature engineer sử dụng SQL ở project này đã feature engineer trong notebook. 

	----- feature engineering order_key 
	ALTER TABLE fact_sales
	ADD COLUMN order_key INT;
	
	WITH order_map AS (
	    SELECT
	        customer_key,
	        order_date,
	        DENSE_RANK() OVER(
	            ORDER BY customer_key, order_date
	        ) AS order_key
	    FROM (
	        SELECT DISTINCT
	            customer_key,
	            order_date
	        FROM fact_sales
	    ) t
	)
	UPDATE fact_sales f
	SET order_key = o.order_key
	FROM order_map o
	WHERE
	    f.customer_key = o.customer_key
	    AND f.order_date = o.order_date;
	
-- Feature Engineering Bổ sung thuộc tính AgeGroup được suy diễn từ BirthDate 
-- nhằm hỗ trợ phân tích phân khúc khách hàng theo độ tuổi.
ALTER TABLE dim_customer
ADD COLUMN age_group VARCHAR(20);

UPDATE dim_customer
SET age_group =
CASE
    WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) < 25 THEN 'Youth'
    WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) BETWEEN 25 AND 40 THEN 'Adult'
    WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) BETWEEN 41 AND 60 THEN 'Middle Age'
    ELSE 'Senior'
END;



-- Month: Giá trị từ 1–12, dùng để sắp xếp đúng thứ tự các tháng trong Power BI.
-- Quarter: Phân tích doanh thu theo quý và hỗ trợ Drill Down trên Dashboard.

ALTER TABLE dim_date
ADD COLUMN month INT,
ADD COLUMN quarter INT;

UPDATE dim_date
SET
    month = EXTRACT(MONTH FROM date),
    quarter = EXTRACT(QUARTER FROM date);








	
	
	
	
	
