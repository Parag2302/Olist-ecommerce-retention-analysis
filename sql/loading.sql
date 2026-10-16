use olist ;

-- 1. customers
load data local infile 'C:/olist/olist_customers_dataset.csv'
into table customers
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- 2. products (category not wrapped in NULLIF, so blanks load as '')
load data local infile 'C:/olist/olist_products_dataset.csv'
into table products
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(product_id, product_category_name, @name_len, @desc_len, @photos,
 @weight, @length, @height, @width)
set product_name_lenght        = nullif(@name_len, ''),
    product_description_lenght = nullif(@desc_len, ''),
    product_photos_qty         = nullif(@photos, ''),
    product_weight_g           = nullif(@weight, ''),
    product_length_cm          = nullif(@length, ''),
    product_height_cm          = nullif(@height, ''),
    product_width_cm           = nullif(@width, '');

-- 3. sellers
load data local infile 'C:/olist/olist_sellers_dataset.csv'
into table sellers
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- 4. geolocation
load data local infile 'C:/olist/olist_geolocation_dataset.csv'
into table geolocation
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- 5. category_translation
load data local infile 'C:/olist/product_category_name_translation.csv'
into table category_translation
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- 6. orders
load data local infile 'C:/olist/olist_orders_dataset.csv'
into table orders
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(order_id, customer_id, order_status, order_purchase_timestamp,
 @approved, @carrier, @delivered, order_estimated_delivery_date)
set order_approved_at              = nullif(@approved, ''),
    order_delivered_carrier_date   = nullif(@carrier, ''),
    order_delivered_customer_date  = nullif(@delivered, '');

-- 7. order_items
load data local infile 'C:/olist/olist_order_items_dataset.csv'
into table order_items
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- 8. order_payments
load data local infile 'C:/olist/olist_order_payments_dataset.csv'
into table order_payments
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- 9. order_reviews (loaded before the primary key was added)
load data local infile 'C:/olist/olist_order_reviews_dataset.csv'
into table order_reviews
character set utf8mb4
fields terminated by ',' optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(review_id, order_id, review_score, @title, @message,
 review_creation_date, review_answer_timestamp)
set review_comment_title   = @title,
    review_comment_message = @message;