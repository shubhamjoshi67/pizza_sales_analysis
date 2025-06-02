create database pizza_sales;
use pizza_sales;
-- Creating the  table--
create table orders (
order_id int not null  primary key ,
order_date date not null,
order_time time not null 
)  ;
select * from order_details
where order_details_id is null or
order_id is null or
pizza_id is null ;

-- 1. Retrieve the total number of orders placed?
select count(*) as total_orders from orders; 
-- 2 . Calculate the total revenue generated from pizza sales?
select round(sum(price * quantity)) as total_revenue from pizzas
join order_details on
pizzas.pizza_id = order_details.pizza_id;
-- 3 .  Identify the highest prized pizza?
select name  as pizza_name , price as price
from pizza_types join
pizzas on
pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc limit 1;
select pizza_type_id  as pizza_name , price as price
from pizzas
order by price desc limit 1;
-- 4.Identify the most common pizza size ordered.
 select pizzas.size as pizza_size , count(order_details_id) as order_count
from pizzas join 
order_details on 
pizzas.pizza_id = order_details.pizza_id
group by pizzas.size limit 1;
-- List top 5 most ordered pizza types along with their quantities?
  select pizza_types.name as pizza_name , sum(quantity) as quantity
from pizza_types join pizzas on 
pizza_types.pizza_type_id = pizzas.pizza_type_id  join 
order_details on
pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by quantity desc limit 5;
-- Join the neccesary tables to find the total quantity of each pizza category ordered.
select pizza_types.category , sum(order_details.quantity) as quantity from 
pizza_types join pizzas on
pizza_types.pizza_type_id = pizzas.pizza_type_id join
order_details on
pizzas.pizza_id = order_details.pizza_id
group  by pizza_types.category 
