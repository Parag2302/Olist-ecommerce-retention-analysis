create table if not exists customers( 
    customer_id varchar(32) not null,
    customer_unique_id varchar(32) not null,
    customer_zip_code_prefix varchar(5),
    customer_city varchar(100),
    customer_state char(2),
    primary key (customer_id)
);

create table if not exists orders( 
    order_id varchar(32) not null,
    customer_id varchar(32) not null,
    order_status varchar(100),
    order_purchase_timestamp datetime,
    order_approved_at datetime,
    order_delivered_carrier_date datetime,
    order_delivered_customer_date datetime,
    order_estimated_delivery_date datetime,
    primary key (order_id),
    foreign key (customer_id) references customers (customer_id)
);

create table if not exists sellers (
    seller_id               varchar(32) not null,
    seller_zip_code_prefix  varchar(5),
    seller_city             varchar(100),
    seller_state            char(2),
    primary key (seller_id)
);

create table if not exists products (
    product_id varchar(32) not null,
    product_category_name varchar(100),
    product_name_length int,
    product_description_length int,
    product_photos_qty int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int,
    primary key (product_id)
);

create table if not exists category_translation (
    product_category_name varchar(100) not null,
    product_category_name_english varchar(100),
    primary key (product_category_name) 
);