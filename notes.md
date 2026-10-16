# Olist: where does revenue come from, and why don't customers return?

My manager wants to know why customers don't place a second order, and
where our revenue comes from by month, product category and customer
state. The answer decides whether the team should focus on winning new
customers or on retaining existing ones. I'll look at delivered orders,
revenue and repeat purchases. Seller performance and marketing channels
are out of scope because the data doesn't cover them. My guess: only
about 3 to 5% of customers buy a second time, and I think late
deliveries and bad reviews may be part of the reason.

## Decisions

- Use customer_unique_id, not customer_id, to identify customers. customer_id is generated per order, so it would make every customer look like a one-time buyer.
- Renamed product_name_lenght and product_description_lenght to ..._length (typo in the source file). Columns are loaded by position, so the CSV header doesn't need to match.
- Zip prefixes are varchar(5), not numbers, so leading zeros like 09790 are kept.
- Delivery date columns in orders allow NULL, because canceled or in-transit orders have no delivery date.
- order_items and order_payments use two-column primary keys (order_id plus the item or payment number), because order_id alone repeats.
- order_reviews and geolocation have no primary key for now. I will test whether review_id repeats after loading, and geolocation has many rows per zip prefix.
- No foreign key from products to category_translation, because some categories may have no translation. I will check this after loading.

- Converted 610 empty product categories to NULL.
- Did not delete the repeated review_ids; they are different orders sharing
  one review.
- Tested that (review_id, order_id) is unique (99,224 distinct pairs for
  99,224 rows) before adding it, then used it as a composite primary key on
  order_reviews.
- Confirmed order_reviews already has an index on order_id (created by the
  foreign key), so no extra index is needed for joins to orders.



## Data issues

- geolocation table: 19,234 "data truncated" notes on geolocation_lat during load. Some coordinates have more than 15 decimal places and were rounded. No rows lost. Immaterial; geolocation isn't used for the revenue or retention analysis.
- products table: 610 of 32,951 rows have no product_category_name. Stored as empty text (''), not NULL (0 NULL rows). Will group them as 'unknown' in the category analysis.
- products table: 2 rows have no product_weight_g (NULL). Not needed for revenue or retention.
- products table: 4 rows have product_weight_g = 0, which is not a real weight. Exclude them from any weight-based analysis.
- geolocation table: initial load gave 19,234 "data truncated" notes because some coordinates had more than 15 decimals (column was decimal(18,15)). Widened lat/lng to decimal(24,20) and reloaded; 0 warnings, 1,000,163 rows.


- 2 products have no weight (found during load).
- geolocation: coordinates were rounded during load (see rounding notes from Phase 2).
- order_reviews: review_id is not unique. 99,224 rows but only 98,410 distinct
  review_ids (814 extra rows). Sampled ID 1fb4ddc9... appears on 3 different
  orders with the same score and date, so it is one review linked to several
  orders, not a duplicate row.
- products: 610 rows had product_category_name stored as '' (empty text)
  instead of NULL, because NULLIF was only applied to numeric columns.


  ## TO check later

  - Row counts took 14 to 58 sec on small tables, likely cold disk reads.
  Measure with EXPLAIN in the indexing phase.