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