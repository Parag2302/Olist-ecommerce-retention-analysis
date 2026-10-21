use olist;


-- joining the tables -> order and order_items 
select count(*) as orders_without_items
from orders o
left join order_items oi on oi.order_id = o.order_id
where oi.order_id is null;