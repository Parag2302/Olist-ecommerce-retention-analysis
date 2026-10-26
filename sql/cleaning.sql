use olist;

update products
set product_category_name = null
where product_category_name = '';

-- alter table order_reviews add primary key (review_id, order_id); made the changes in the table.sql  file 


