-- Most Sales 
SELECT jmp_customer_organization_id, SUM(sales_orders.omp_order_subtotal_base)::text::money AS total_sales
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
GROUP BY jobs.jmp_customer_organization_id
ORDER BY total_sales DESC
-- Most Volume of Jobs

SELECT COUNT (jobs.jmp_job_id) AS job_count, jobs.jmp_customer_organization_id
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
GROUP BY jobs.jmp_customer_organization_id
ORDER BY job_count DESC

--

SELECT jobs.jmp_job_id, jobs.jmp_customer_organization_id, jobs.jmp_production_due_date, jobs.jmp_job_date, jobs.jmp_scheduled_start_date, jobs.jmp_scheduled_due_date, jobs.jmp_completed_date, jobs.jmp_closed_date, jobs.jmp_schedule_complete
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id

---

SELECT jobs.jmp_completed_date,
COUNT(jobs.jmp_job_id) as job_count,
jobs.jmp_customer_organization_id
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE jobs.jmp_completed_date BETWEEN  '2023-01-01' and '2023-12-31'
GROUP BY jobs.jmp_completed_date, jobs.jmp_customer_organization_id
ORDER BY job_count DESC;


SELECT jobs.jmp_completed_date,
COUNT(jobs.jmp_job_id) as job_count,
jobs.jmp_customer_organization_id
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE jobs.jmp_completed_date BETWEEN  '2024-01-01' and '2024-12-31'
GROUP BY jobs.jmp_completed_date, jobs.jmp_customer_organization_id
ORDER BY job_count DESC

---month with most orders
SELECT 
TO_CHAR(jobs.jmp_completed_date, 'YYYY-MM') AS completed_month,
COUNT(jobs.jmp_job_id) AS job_count 
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE jobs.jmp_completed_date BETWEEN  '2023-01-01' and '2024-12-31'
GROUP BY completed_month
ORDER BY job_count DESC;

----
SELECT 
TO_CHAR(jobs.jmp_completed_date, 'YYYY-MM') AS completed_month,
COUNT(jobs.jmp_job_id) AS job_count,
jobs.jmp_customer_organization_id,
job_operations_2023.jmo_estimated_production_hours,
job_operations_2024.jmo_estimated_production_hours
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE jobs.jmp_completed_date BETWEEN  '2023-01-01' and '2024-12-31'
GROUP BY completed_month, jobs.jmp_customer_organization_id, job_operations_2023.jmo_estimated_production_hours, job_operations_2024.jmo_estimated_production_hours
ORDER BY job_count DESC;

SELECT 
TO_CHAR(jobs.jmp_completed_date, 'YYYY-MM') AS completed_month,
COUNT(jobs.jmp_job_id) AS job_count,
COUNT(DISTINCT jobs.jmp_customer_organization_id) AS customer_count
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE jobs.jmp_completed_date BETWEEN  '2023-01-01' and '2024-12-31'
GROUP BY completed_month

--- 

SELECT jobs.jmp_customer_organization_id, job_operations_2023.jmo_estimated_production_hours, TO_CHAR(jobs.jmp_completed_date, 'YYYY-MM') AS completed_month
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
GROUP BY completed_month, job_operations_2023.jmo_estimated_production_hours, jobs.jmp_customer_organization_id
ORDER BY  jobs.jmp_customer_organization_id

--
(SELECT 
    TO_CHAR(jobs.jmp_completed_date, 'YYYY-MM') AS completed_month,
    ROUND(AVG(job_operations_2023.jmo_estimated_production_hours)::numeric, 2) AS avg_production_hours
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE job_operations_2023.jmo_estimated_production_hours IS NOT NULL
GROUP BY completed_month
ORDER BY completed_month)

UNION ALL

(SELECT 
    TO_CHAR(jobs.jmp_completed_date, 'YYYY-MM') AS completed_month,
    ROUND(AVG(job_operations_2024.jmo_estimated_production_hours)::numeric, 2) AS avg_production_hours
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE job_operations_2024.jmo_estimated_production_hours IS NOT NULL
GROUP BY completed_month
ORDER BY completed_month);

-- 

SELECT 
job_operations_2023.jmo_process_short_description,
COUNT(DISTINCT jobs.jmp_customer_organization_id) AS customer_count
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE job_operations_2023.jmo_estimated_production_hours IS NOT NULL
GROUP BY job_operations_2023.jmo_process_short_description
ORDER BY customer_count DESC


SELECT 
job_operations_2024.jmo_process_short_description,
COUNT(DISTINCT jobs.jmp_customer_organization_id) AS customer_count
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
LEFT JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE job_operations_2024.jmo_estimated_production_hours IS NOT NULL
GROUP BY job_operations_2024.jmo_process_short_description
ORDER BY customer_count DESC

-- 

SELECT jobs.jmp_part_id, 
COUNT (jobs.jmp_job_id) as job_count
FROM jobs
GROUP BY jobs.jmp_part_id
ORDER BY job_count DESC;

-- 

SELECT jobs.jmp_part_id, job_operations_2023.jmo_actual_production_hours
FROM jobs
LEFT JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
WHERE job_operations_2023.jmo_actual_production_hours IS NOT NULL
GROUP BY job_operations_2023.jmo_actual_production_hours, jobs.jmp_part_id
ORDER BY job_operations_2023.jmo_actual_production_hours DESC;

-- Week and Month counts of Shipments

SELECT DATE_TRUNC('week', smp_ship_date) AS week_sort,
COUNT (smp_shipment_id) AS shipment_count
FROM shipments
GROUP BY week_sort
ORDER BY shipment_count DESC

SELECT DATE_TRUNC('month', smp_ship_date) AS month_sort,
COUNT (smp_shipment_id) AS shipment_count
FROM shipments
GROUP BY month_sort
ORDER BY shipment_count DESC

-- 

SELECT 
	jmp_part_id, 
	jmp_completed_date, 
	jmp_production_due_date,
	CASE WHEN jmp_completed_date <= jmp_production_due_date THEN 'On Time'
	ELSE 'Late'
	END AS delivery_status
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id

-- 

SELECT DATE_TRUNC('week', jmp_completed_date) AS delivery_week,
COUNT (*) AS total_jobs,
SUM (CASE WHEN jmp_completed_date <= jmp_production_due_date THEN 1 ELSE 0 END) AS on_time_jobs,
SUM (CASE WHEN jmp_completed_date > jmp_production_due_date THEN 1 ELSE 0 END) AS late_jobs
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id
GROUP BY delivery_week
ORDER BY delivery_week;


SELECT DATE_TRUNC('month', jmp_completed_date) AS delivery_month,
COUNT (*) AS total_jobs,
SUM (CASE WHEN jmp_completed_date <= jmp_production_due_date THEN 1 ELSE 0 END) AS on_time_jobs,
SUM (CASE WHEN jmp_completed_date > jmp_production_due_date THEN 1 ELSE 0 END) AS late_jobs
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id
GROUP BY delivery_month
ORDER BY delivery_month;

SELECT 
COUNT (*) AS total_jobs,
SUM (CASE WHEN jmp_completed_date <= jmp_production_due_date THEN 1 ELSE 0 END) AS on_time_jobs,
SUM (CASE WHEN jmp_completed_date > jmp_production_due_date THEN 1 ELSE 0 END) AS late_jobs
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id


SELECT *
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id

-- LATE JOBS PER PART PER MONTH

SELECT 
jmp_part_id,
DATE_TRUNC('month', jmp_completed_date) AS delivery_month,
COUNT (*) AS total_jobs,
SUM (CASE WHEN jmp_completed_date > jmp_production_due_date THEN 1 ELSE 0 END) AS late_jobs,
SUM (CASE WHEN jmp_completed_date <= jmp_production_due_date THEN 1 ELSE 0 END) AS on_time_jobs
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id
GROUP BY jmp_part_id, jobs.jmp_completed_date
ORDER BY jmp_part_id 


SELECT 
jmp_part_id,
DATE_TRUNC('month', jmp_completed_date) AS delivery_month,
COUNT (*) AS total_jobs
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id
GROUP BY jmp_part_id, delivery_month
ORDER BY total_jobs DESC

SELECT 
jmp_part_id,
DATE_TRUNC('month', jmp_completed_date) AS delivery_month,
SUM (CASE WHEN jmp_completed_date > jmp_production_due_date THEN 1 ELSE 0 END) AS late_jobs
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id
GROUP BY jmp_part_id, delivery_month
ORDER BY late_jobs DESC

SELECT 
jmp_part_id,
DATE_TRUNC('month', jmp_completed_date) AS delivery_month,
SUM (CASE WHEN jmp_completed_date <= jmp_production_due_date THEN 1 ELSE 0 END) AS on_time_jobs
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id
GROUP BY jmp_part_id, delivery_month
ORDER BY on_time_jobs DESC

SELECT *
FROM jobs
LEFT JOIN parts ON jobs.jmp_part_id = parts.imp_part_id
WHERE jmp_part_id = 'V007-0710'




