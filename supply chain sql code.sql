SELECT * FROM public.supply_chain
---Delivery Timeline Analysis--
--- Q1. Which shipping mode has highest average delay?
SELECT
Shipping_Mode,
ROUND(AVG(Delay_Days),2) avg_delay
FROM supply_chain
GROUP BY Shipping_Mode
ORDER BY avg_delay DESC;

-----Detect inefficient shipping modes.
-----Improve route planning
-----Reduce dependency on slow modes

----Q2. Which product categories rank highest in fulfilment time?
WITH fulfilment AS (
SELECT
Product_Category,
ROUND(
AVG(Total_Fullfilment_Time),2
) avg_time
FROM supply_chain
GROUP BY Product_Category
)

SELECT *,
RANK()
OVER(
ORDER BY avg_time DESC
) fulfilment_rank
FROM fulfilment;
-----Identify slow categories.
------Prioritize warehouse optimization.

--------------------Supplier Performance----------
----Q3. Which suppliers have lowest reliability?
SELECT
Supplier_ID,
AVG(Supplier_Reliability_Score),2

FROM supply_chain
GROUP BY Supplier_ID
ORDER BY AVG(
Supplier_Reliability_Score
);

---Find poor suppliers.
----Supplier review program.

---Q4. Rank suppliers by reliability and disruption history
WITH supplier_perf AS (
SELECT
Supplier_ID,
AVG(
Supplier_Reliability_Score
) reliability,
AVG(
Historical_Disruption_Count
) disruption
FROM supply_chain
GROUP BY Supplier_ID
)

SELECT *,
RANK()
OVER(
ORDER BY reliability DESC,
disruption ASC
)
FROM supplier_perf;
----Supplier leaderboard
-----Increase sourcing from top suppliers
--------------------Disruption Impact-----------------

-----Q5. Which disruption type occurs most?
SELECT
Disruption_Type,
COUNT(*) disruption_count
FROM supply_chain
GROUP BY Disruption_Type
ORDER BY disruption_count DESC;

---Most common issue
---Build prevention strategy
-----Q6. Which disruption severity increases fulfilment?
SELECT
Disruption_Severity,
AVG(
Total_Fullfilment_Time
),
DENSE_RANK()
OVER(
ORDER BY AVG(
Total_Fullfilment_Time
) DESC
)
FROM supply_chain
GROUP BY Disruption_Severity;

----Severe disruptions impact operations
----Faster escalation process
----------------Operational Efficiency-----------
-----Q7. Which categories consume highest energy?
SELECT
Product_Category,
AVG(
Energy_Consumption_Joules
)

FROM supply_chain
GROUP BY Product_Category
ORDER BY 2 DESC;
-----High operational cost
------Optimize energy usage

----Q8. Compare communication cost with fulfilment
WITH ops AS (
SELECT
Product_Category,
AVG(
Communication_Cost_MB
) comm,
AVG(
Total_Fullfilment_Time
) fulfil
FROM supply_chain
GROUP BY Product_Category
)

SELECT *
FROM ops
ORDER BY fulfil DESC;
-----Improve coordination
--------------------Order Trends----------------
----Q9. Which categories receive most demand?
SELECT
Product_Category,
SUM(
Quantity_Ordered
)
FROM supply_chain
GROUP BY Product_Category
ORDER BY 2 DESC;

------Increase inventory
-----Q10. Which categories contribute most value?
SELECT
Product_Category,
SUM(
Order_Value_USD
),
RANK()
OVER(
ORDER BY SUM(
Order_Value_USD
) DESC
)
FROM supply_chain
GROUP BY Product_Category;

----Prioritize profitable categories
------------------------Supply Risk------------------
-----Q11. Which suppliers create highest risk?
SELECT
Supplier_ID,
COUNT(*)
FROM supply_chain
WHERE Supply_Risk_Flag=1
GROUP BY Supplier_ID
ORDER BY 2 DESC;
-----Reduce supplier dependency.
------Q12. Rank suppliers by supply risk?
WITH risk AS (
SELECT
Supplier_ID,
COUNT(*) risk
FROM supply_chain
WHERE Supply_Risk_Flag=1
GROUP BY Supplier_ID
)

SELECT *,
RANK()
OVER(
ORDER BY risk DESC
)
FROM risk;
-----Diversify sourcing