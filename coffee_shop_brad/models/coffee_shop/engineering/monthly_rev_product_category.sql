with

customers as (
    select * from {{ ref('stg_coffee_shop__customers') }}
),

order_items as (
    select * from {{ ref('stg_coffee_shop__order_items') }}
),

orders as (
    select * from {{ ref('stg_coffee_shop__orders') }}
),

product_prices as (
    select * from {{ ref('stg_coffee_shop__product_prices') }}
),

products as (
    select * from {{ ref('stg_coffee_shop__products') }}
),

final as (
    select 
        format_timestamp('%Y-%m', orders.created_at) as month,
        products.category,
        sum(product_prices.price) as revenue
        
    from orders
    left join order_items on orders.order_id = order_items.order_id
    left join products on order_items.product_id = products.product_id
    left join product_prices on products.product_id = product_prices.product_id
        and orders.created_at between product_prices.created_at and product_prices.ended_at
    group by 1,2
    order by 1,3 desc
)

select * from final



