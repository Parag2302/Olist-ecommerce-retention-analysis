## Decisions

- Use customer_unique_id, not customer_id, to identify customers. customer_id is generated per order, so it would make every customer look like a one-time buyer.
- Renamed product_name_lenght and product_description_lenght to ..._length (typo in the source file). Columns are loaded by position, so the CSV header doesn't need to match.
- Zip prefixes are varchar(5), not numbers, so leading zeros like 09790 are kept.
- Delivery date columns in orders allow NULL, because canceled or in-transit orders have no delivery date.
- order_items and order_payments use two-column primary keys (order_id plus the item or payment number), because order_id alone repeats.
- order_reviews has a composite primary key (review_id, order_id). geolocation has no primary key, because it has many rows per zip prefix.
- Added foreign key order_reviews.order_id to orders after confirming 0 reviews without an order. MySQL keeps an index on order_id for it.
- No foreign key from products to category_translation, because some categories may have no translation. I will check this after loading.
- Converted 610 empty product categories to NULL. Label them 'unknown' only in reports.
- Did not delete the repeated review_ids; they are different orders sharing one review. Tested that (review_id, order_id) is unique (99,224 distinct pairs for 99,224 rows) before adding the composite key. Phase 7 still needs one review per order.
- Revenue and retention use delivered orders only (96,478 of 99,441 orders; 2,963 excluded).
- Kept all 23 delivered orders with missing dates and all orders with out-of-order dates. Excluded them only from approval-time and delivery-time calculations. Delivery time = purchase to customer delivery, because the courier date is the unreliable timestamp.
- Skipped checks for items or payments with no order, and duplicates in customers, sellers and products, because primary and foreign keys make them impossible.
- 02_load_data.sql corrected to match the loaded database (length spelling, data/raw paths, order_reviews escaped by '' and nullif). Full re-run test on olist_test pending.

## Data issues

- geolocation: 19,234 "data truncated" notes on geolocation_lat during load, because some coordinates had more than 15 decimals (column was decimal(18,15)). Widened lat/lng to decimal(24,20) and reloaded; 0 warnings, 1,000,163 rows.
- products: 610 of 32,951 rows had product_category_name stored as '' instead of NULL, because NULLIF was only applied to numeric columns. Now NULL.
- products: 2 rows have no product_weight_g (NULL). 4 rows have product_weight_g = 0, which is not a real weight. Exclude them from any weight-based analysis.
- order_reviews: review_id is not unique. 99,224 rows but only 98,410 distinct review_ids (814 extra rows). Sampled ID 1fb4ddc9... appears on 3 different orders with the same score and date, so it is one review linked to several orders, not a duplicate row.
- orders: 2,963 orders (about 3%) are not delivered and are excluded from revenue.
- orders: 23 delivered orders have date gaps (14 missing approval date, from Jan-Feb 2017; 8 missing delivery date, 6 from Jun-Jul 2018 and 2 from 2017 (May, Nov); 2 missing carrier date; 1 order is missing two dates). The gaps cluster by date, so they look like source recording gaps.
- orders: of 1,359 orders with courier date before approval date, 242 differ by under 1 hour, 659 by 1 to 24 hours, 444 by 1 to 7 days, and 14 by over 7 days (max about 171 days).
- orders: 23 delivered orders have a delivery date earlier than the courier date. Gaps range from 0 to 386 hours (about 16 days); 7 are 5 to 8 days. The purchase date is the earliest date in every case, so the courier date is the likely bad timestamp.
- orders: 775 orders (about 0.78%) have no items. Status breakdown pending.

## TO check later

- Row counts took 14 to 58 sec on small tables, likely cold disk reads. Measure with EXPLAIN in the indexing phase.