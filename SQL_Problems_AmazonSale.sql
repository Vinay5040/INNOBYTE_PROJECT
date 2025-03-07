create database p1;

use p1;

select * from `amazon sale report`;                          ## {Duplicates were not removed because of large dataset..


## SALES OVERVIEW : 

### Question 1: What is the total quantity sold per date ?
### Solution 1 : 
select Date, SUM(Qty) as Total_Sales from `amazon sale report`
where amount is not null
group by Date
order by Date;


### Question 2: What is the total sales value by month, and how does it change over time?
### Solution 2 : 
select DATE_FORMAT(STR_TO_DATE(date, '%m-%d-%Y'), '%m-%b-%Y') as Month, SUM(amount*qty) as Total_Sales from `amazon sale report`
where amount is not null
group by Month
order by Month;


### Question 3: What is the number of completed and pending orders by sales channel?
### Solution 3 :
select `sales channel`, SUM(CASE WHEN status = 'Shipped - Delivered to Buyer' THEN 1
WHEN status = 'Shipped' THEN 1
WHEN status = 'Shipped - Returned to Seller' THEN 1
WHEN status = 'Shipped - Rejected by Buyer' THEN 1
WHEN status = 'Shipped - Lost in Transit' THEN 1
WHEN status = 'Shipped - Out for Delivery' THEN 1
WHEN status = 'Shipped - Returning to Seller' THEN 1
WHEN status = 'Shipped - Picked Up' THEN 1
WHEN status = 'Shipped - Damaged' THEN 1
ELSE 0 END) as Completed_Orders,
SUM(CASE 
WHEN status = 'Pending' THEN 1
WHEN status = 'Pending - Waiting for Pick Up' THEN 1
ELSE 0 END) as Pending_Orders
from `amazon sale report`
where amount is not null
group by `sales channel`;


### Question 4: How do sales vary by fulfillment method (e.g., fulfilled by the company vs third-party fulfillment)?
### Solution 4 :
select Fulfilment, SUM(amount*qty) as Total_Sales, COUNT(distinct `order id`) as Total_Orders
from `amazon sale report`
where amount is not null
group by Fulfilment;


### Question 5: Calculate total qty sold by size ?
### Solution 5 : 
select size, SUM(Qty) as Total_Qty 
from `amazon sale report`
where amount is not null
group by size
order by Total_Qty desc;


### Question 6: Calculate Total Sales by Courier Status ?
### Solution 6 :
select `Courier Status`, SUM(Amount*Qty) as Total_Sales
from `amazon sale report`
where amount is not null
group by `Courier Status`
order by Total_Sales desc;


###########################################################################################################################


## PRODUCT ANALYSIS :

### Question 1: Which product categories generate the most revenue?
### Solution 1 :
select category, SUM(amount*qty) as Total_Sales from `amazon sale report`
where amount is not null
group by category
order by Total_Sales desc;


### Question 2: What is the total quantity sold and total amount generated by product size and category?
### Solution 2 :
select category, size, SUM(qty) as Total_Quantity_Sold, SUM(amount*qty) as Total_Amount
from `amazon sale report`
where amount is not null
group by category, size
order by Total_Quantity_Sold desc;


### Question 3: Which product categories have the highest number of orders?
### Solution 3 :
select category, COUNT(distinct `order id`) as Total_Orders
from `amazon sale report`
where amount is not null  
group by category
order by Total_Orders desc;


#####################################################################################################################


## Fulfilment Analysis :

### Question 1: What is the total sales value and order count by fulfillment method?
### Solution 1 :
select Fulfilment, SUM(amount*qty) as Total_Sales, COUNT(distinct `order id`) as Total_Orders
from `amazon sale report`
where amount is not null
group by Fulfilment;


### Question 2: How effective is each fulfillment method in completing orders (i.e., completion rate)?
### Solution 2 :
select Fulfilment, (SUM(CASE WHEN status = 'Shipped - Delivered to Buyer' THEN 1
WHEN status = 'Shipped' THEN 1
WHEN status = 'Shipped - Returned to Seller' THEN 1
WHEN status = 'Shipped - Rejected by Buyer' THEN 1
WHEN status = 'Shipped - Lost in Transit' THEN 1
WHEN status = 'Shipped - Out for Delivery' THEN 1
WHEN status = 'Shipped - Returning to Seller' THEN 1
WHEN status = 'Shipped - Picked Up' THEN 1
WHEN status = 'Shipped - Damaged' THEN 1
ELSE 0 END) / COUNT(distinct `order id`))*100 as Completion_Rate
from `amazon sale report`
where amount is not null
group by Fulfilment;


### Question 3: What is the total quantity shipped by fulfillment method?
### Solution 3 :
select Fulfilment, SUM(qty) as Total_Quantity_Shipped
from `amazon sale report`

group by Fulfilment
order by Fulfilment;


#########################################################################################################################


## CUSTOMER SEGMENTATION :

### Question 1: What is the average amount spent by customers based on state?
### Solution 1 :
select  IFNULL(`ship-state`, 'Unknown') as ShipState, AVG(amount*qty) as Average_Spent
from `amazon sale report`
where amount is not null
group by ShipState
order by ShipState;


### Question 2:  Which cities generate the most revenue and the highest order volume?
### Solution 2 :
select IFNULL(`ship-city`, 'Unknown') as `ship-city`, SUM(amount*qty) as Total_Revenue, COUNT(distinct `order id`) as Total_Orders
from `amazon sale report`
where amount is not null
group by `ship-city`
order by Total_Revenue desc, Total_Orders desc;


### Question 3: What is the number of orders and total spend for each customer segment based on location (country)?
### Solution 3 :
select COALESCE(`ship-country`, 'unknown') as `ship-country`, COUNT(distinct `order id`) as Num_Orders, SUM(amount*qty) as Total_Spent
from `amazon sale report`
where amount is not null
group by `ship-country`
order by `ship-country`;


##########################################################################################################################


## GEOGRAPHICAL ANALYSIS :

### Question 1: What is the total sales value by city and country?
### Solution 1 :
select IFNULL(`ship-city`, 'Unknown') as `ship-city`,  IFNULL(`ship-country`, 'Unknown') as `ship-country`, SUM(amount * qty) as Total_Sales
from `amazon sale report`
where amount is not null
group by `ship-city`, `ship-country`
order by Total_Sales desc;


### Question 2: Which states have the highest number of orders?
### Solution 2 :
select COALESCE(`ship-state`,'Unknown') as `ship-state`, COUNT(distinct `order id`) as Num_Orders
from `amazon sale report`
where amount is not null
group by `ship-state`
order by Num_Orders desc;


### Question 3: What are the total quantities shipped by state and country?
### Solution 3 :
select COALESCE(`ship-state`,'Unknown') as `ship-state`, IFNULL(`ship-country`,'Unknown') as `ship-country`, SUM(qty) as Total_Qty_Shipped
from `amazon sale report`
where amount is not null
group by `ship-state`, `ship-country`
order by Total_Qty_Shipped desc;


### Question 4:  Which top 10 states generates the higher sales?
### Solution 4 :
select COALESCE(`ship-state`,'Unknown') as `ship-state`, SUM(amount*qty) as Total_Sales
from `amazon sale report`
where amount is not null
group by `ship-state`
order by Total_Sales desc
limit 10;


################################################################################################################


## ORDER ANALYSIS :

### Question 1: Calculate Number of Orders by Order_Status ?
### Solution 1 :
select status, COUNT(distinct `Order ID`) as Num_Orders
from `amazon sale report`
group by status
order by Num_Orders desc;


### Question 2: Calculate sales percentage by status ?
### Solution 2 :
select status, SUM(amount*qty) as Total_Sales, (SUM(amount*qty) / (select SUM(amount*qty) from `amazon sale report`))*100 as Sales_Percentage
from `amazon sale report`
where amount is not null
group by status
order by Sales_Percentage desc;


###################################################################################################################################################


## BUSINESS INSIGHTS :

### Question 1: Which combination of product category, fulfillment method, and sales channel leads to the highest sales?
### Solution 1 :
select category, Fulfilment, `sales channel`, SUM(amount*qty) as Total_Sales
from `amazon sale report`
where amount is not null
group by category, Fulfilment, `sales channel`
order by Total_Sales desc
limit 10;


### Question 2: What is the customer order behavior (total spend and order frequency) by fulfillment method?
### Solution 2 :
select Fulfilment, SUM(amount*qty) as Total_Spent, COUNT(distinct `order id`) as Total_Orders, AVG(amount) as Average_order_value
from `amazon sale report`
group by Fulfilment
order by Total_Spent desc;


### Question 3: Which geographic region (city, state, country) has the highest order volume and sales value?
### Solution 3 :
select IFNULL(`ship-city`, 'Unknown') as `ship-city`, IFNULL(`ship-state`, 'Unknown') as `ship-state`, IFNULL(`ship-country`, 'Unknown') as `ship-country`, 
COUNT(distinct `order id`) as Total_Orders, SUM(amount*qty) as Total_Sales
from `amazon sale report`
where amount is not null
group by `ship-city`, `ship-state`, `ship-country`
order by Total_Orders desc, Total_Sales desc
limit 10;


###############################################################################################################################################

### KEY INSIGHTS :

# Focus on Amazon fulfillment, particularly for high-performing product categories like T-shirts, Shirts, and Blazzers.
# Invest in key metropolitan cities and states such as Bengaluru, Mumbai, Maharashtra, and Karnataka.
# Additionally,streamline order fulfillment processes to reduce pending orders and ensure timely deliveries to maintain high sales volume and customer satisfaction.

#################################################################################################################################################