# Pizza Sales Analysis SQL Project

## Project Overview

**Project Title**: Pizza Sales Analysis  
**Level**: Beginner  

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a pizza sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named project.
- **Table Creation**: A table named order_details is created to store the sales data and  we import these tables  pizza_type , pizzas , orders from database.

```sql
CREATE DATABASE 'pizza_sales';

CREATE TABLE orders (
    order_id INT NOT NULL PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL
);

```

### 2. Data Exploration & Cleaning

- **Orders Count**: Determine the total number of unique orders in the dataset.
- **CategoryCount**: Find out total categories of pizzas are in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT 
    COUNT(order_details_id)
FROM
    order_details;
  SELECT 
    COUNT(distinct category) AS category
FROM
    pizza_types;

SELECT 
    *
FROM
    order_details
WHERE
    order_details_id IS NULL
        OR order_id IS NULL
        OR pizza_id IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **-- 1. Retrieve the total number of orders placed?**:
```sql
SELECT 
    COUNT(*) AS total_orders
FROM
    orders;
```

2. **Calculate the total revenue generated from pizza sales?**:
```sql
SELECT 
    ROUND(SUM(price * quantity)) AS total_revenue
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id;
```

3. **Identify the highest prized pizza?**:
```sql
SELECT 
    name AS pizza_name, price AS price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;

```

4. **Identify the most common pizza size ordered.**:
```sql
SELECT 
    pizzas.size AS pizza_size,
    COUNT(order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
LIMIT 1;
```

5. **List top 5 most ordered pizza types along with their quantities?**:
```sql
SELECT 
    pizza_types.name AS pizza_name, SUM(quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;
```

6. **Join the neccesary tables to find the total quantity of each pizza category ordered.**:
```sql
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category;
```

7. **Determine the distribution of orders by hour of the day.**:
```sql
SELECT 
    EXTRACT(HOUR FROM order_time) AS hours,
    COUNT(order_id) AS orders_per_hour
FROM
    orders
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY EXTRACT(HOUR FROM order_time);
```

8. **Join relevent tables to find the category - wise distribution of pizzas.**:
```sql
SELECT 
    pizza_types.category,
    COUNT(pizza_types.name) AS total_pizzas
FROM
    pizza_types
GROUP BY category
ORDER BY COUNT(pizza_types.name) DESC;
```

9. **Group the Orders by date and calculate the average number of pizzas ordered per day.**:
```sql
SELECT 
    ROUND(AVG(quantities)) AS avg_quantity_per_day
FROM
    (SELECT 
        orders.order_date AS dates,
            SUM(order_details.quantity) AS quantities
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS orders_quantity;
```

10. **Determine the top 3 most orderder pizzas types based on revenue.**:
```sql
SELECT 
    pizza_types.name, ROUND(SUM(price * quantity)) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY ROUND(SUM(price * quantity)) DESC
LIMIT 3;
```
11 . **Calculate the percentage contribution of each pizza type to total revenue.**
```sql
SELECT 
    pizza_types.category,
    ROUND(ROUND(SUM(price * quantity)) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS percentages
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY ROUND(SUM(price * quantity)) DESC;
```
12. **Analyze the commulative revenue generated over time.**
```sql
SELECT order_date , SUM(revenue) OVER (ORDER BY order_date)AS cum_revenue FROM
 (SELECT orders.order_date , ROUND(SUM(pizzas.price *order_details.quantity) , 2) AS revenue  FROM
 pizzas JOIN  order_details ON
 pizzas.pizza_id = order_details.pizza_id JOIN
 orders ON
 order_details.order_id = orders.order_id 
GROUP BY order_date) AS sales;
```

13. **Determine the top 3 most ordered pizza types based on revenue for each pizza category.**
```sql
SELECT name , revenue FROM 
(SELECT category , name , revenue  , rank() over (PARTITION BY category ORDER BY revenue desc) AS rn FROM 
(SELECT 
    pizza_types.category , pizza_types.name ,
    ROUND(SUM(pizzas.price * order_details.quantity),
            2) AS revenue
FROM
    pizzas
        JOIN
 order_details ON pizzas.pizza_id = order_details.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY category , name
ORDER BY category DESC) as t1) as t2
where rn <= 3;
```

## Findings
- **Total Orders and Revenue**

The total number of orders placed is calculated using the orders table, showing the overall customer activity.
The total revenue generated from pizza sales is calculated as the product of the price and quantity of pizzas sold, providing an overview of financial performance.
Popular Pizzas and Sizes

- **The most expensive pizza is identified, revealing high-value menu items.**
The most common pizza size ordered reflects customer preferences, helping refine inventory management.
Top Pizza Types and Categories

- **The top 5 most ordered pizza types are identified along with their quantities, showing customer favorites.**
Analysis of pizza categories reveals which categories dominate sales, assisting in menu optimization.
Order Patterns

- **Distribution of orders by hour highlights peak times for customer orders, which is essential for staffing and operations planning.**
Grouping orders by date and calculating the average number of pizzas ordered per day provide insights into daily trends.
Revenue Analysis

- **The cumulative revenue over time illustrates business growth trends.**
Revenue contribution by pizza type and the identification of top-performing pizza types per category help allocate resources effectively.


## Reports
- **Revenue Report**
A detailed analysis of revenue generated by each pizza type and category, showing their percentage contribution to total revenue.

   **Customer Behavior**
Insights into customer ordering patterns by time, size preferences, and pizza categories.

- **Menu Optimization**
Performance of pizza types based on quantity and revenue, aiding in menu adjustments to maximize profitability.

- **Daily Performance**
Average daily orders and cumulative revenue trends, helping monitor performance over time.

- **Peak Demand Hours**
Hours with the highest order activity, useful for planning marketing campaigns and promotions.

## Conclusion

**Customer Preferences**
Insights into the most ordered pizza types and sizes show customer preferences, which can guide future product offerings.

**Operational Efficiency**
Knowledge of peak order hours and daily trends allows for better staffing, inventory, and preparation management.

**Revenue Growth**
Tracking cumulative revenue provides a clear picture of business performance over time, enabling strategic planning.

**Category Contribution**
Understanding revenue contributions by category can help prioritize promotional efforts on high-performing categories.

**Top Performers**
Identifying top pizzas and categories helps maintain a strong focus on bestsellers, ensuring continued customer satisfaction and profitability.


## Author - Sahil rawat

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


Thank you for your support, and I look forward to connecting with you!
