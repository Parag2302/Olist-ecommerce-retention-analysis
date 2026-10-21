-- to check the status or to check the data 
use olist;

select order_status, count(*) as total
from orders
group by order_status
order by total desc;


-- to find the missing and null values 
-- the querry will give the null values in numbers and the ones not null will be counted as 0 , 
-- basically 0 for non null values and 1 for nulls  
select order_status,
       count(*) as total,
       sum(order_approved_at is null) as no_approved,
       sum(order_delivered_carrier_date is null) as no_carrier,
       sum(order_delivered_customer_date is null) as no_delivered
from orders
group by order_status
order by total desc;


-- to list the orders with the null entries and the suspecious orders
select order_id, order_purchase_timestamp, order_approved_at,
       order_delivered_carrier_date, order_delivered_customer_date
from orders
where order_status = 'delivered'
  and (order_approved_at is null
       or order_delivered_carrier_date is null
       or order_delivered_customer_date is null);



-- checking for impossible dates 
select count(*) as total_orders,
       sum(order_approved_at < order_purchase_timestamp) as approved_before_purchase,
       sum(order_delivered_carrier_date < order_approved_at) as carrier_before_approved,
       sum(order_delivered_customer_date < order_delivered_carrier_date) as delivered_before_carrier,
       sum(order_delivered_customer_date < order_purchase_timestamp) as delivered_before_purchase
from orders;


-- Step 5: how big are the gaps on the 1,359 orders where the courier date
-- is earlier than the approval date? Returns min, avg and max in minutes.
select count(*) as orders,
       min(timestampdiff(minute, order_delivered_carrier_date, order_approved_at)) as min_minutes,
       round(avg(timestampdiff(minute, order_delivered_carrier_date, order_approved_at))) as avg_minutes,
       max(timestampdiff(minute, order_delivered_carrier_date, order_approved_at)) as max_minutes
from orders
where order_delivered_carrier_date < order_approved_at; -- this is for the investigation of the wrong data that is the date


-- Step 6: how many of those 1,359 orders fall into each gap-size bucket?
-- The previous query showed the range (min, avg, max), not how rows are spread across it.
select case
         when timestampdiff(minute, order_delivered_carrier_date, order_approved_at) < 60 then '1. under 1 hour'
         when timestampdiff(minute, order_delivered_carrier_date, order_approved_at) < 1440 then '2. 1 to 24 hours'
         when timestampdiff(minute, order_delivered_carrier_date, order_approved_at) < 10080 then '3. 1 to 7 days'
         else '4. over 7 days'
       end as gap_size,
       count(*) as orders
from orders
where order_delivered_carrier_date < order_approved_at
group by gap_size
order by gap_size;



-- this targets the rows where the delivery date is before the carrier date 
select order_id, order_status,
       order_purchase_timestamp,
       order_delivered_carrier_date,
       order_delivered_customer_date,
       timestampdiff(hour, order_delivered_customer_date, order_delivered_carrier_date) as hours_early
from orders
where order_delivered_customer_date < order_delivered_carrier_date
order by hours_early desc;




