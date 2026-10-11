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


## Data issues

