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

## Data issues

