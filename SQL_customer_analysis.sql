-- Most jobs Overall 
SELECT 
jobs.jmp_customer_organization_id, 
COUNT(jobs.jmp_job_id) AS job_count
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
GROUP BY jobs.jmp_customer_organization_id
ORDER BY job_count  DESC

-- Most Jobs in 2023 and 2024 

SELECT 
	EXTRACT(YEAR FROM jmp_job_date) AS year, 
	EXTRACT(MONTH FROM jmp_job_date) AS month, 
	jobs.jmp_customer_organization_id,
	COUNT(jobs.jmp_job_id) AS job_count
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE EXTRACT(YEAR FROM jmp_job_date) = 2023
GROUP BY year, month, jmp_customer_organization_id
ORDER BY year, month, job_count DESC;

SELECT 
	EXTRACT(YEAR FROM jmp_job_date) AS year, 
	EXTRACT(MONTH FROM jmp_job_date) AS month, 
	jobs.jmp_customer_organization_id,
	COUNT(jobs.jmp_job_id) AS job_count
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE EXTRACT(YEAR FROM jmp_job_date) = 2024
GROUP BY year, month, jmp_customer_organization_id
ORDER BY year, month, job_count DESC;


-- Total Revenue

SELECT 
jobs.jmp_customer_organization_id,
SUM(sales_orders.omp_order_subtotal_base)::TEXT::MONEY AS total_sales
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
GROUP BY jobs.jmp_customer_organization_id
ORDER BY total_sales DESC


SELECT 
jobs.jmp_customer_organization_id,
SUM(sales_orders.omp_order_subtotal_base)::TEXT::MONEY AS total_sales,
EXTRACT(YEAR FROM jmp_job_date) AS year
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE EXTRACT(YEAR FROM jmp_job_date) = '2023'
GROUP BY year, jobs.jmp_customer_organization_id
ORDER BY total_sales DESC;

SELECT 
jobs.jmp_customer_organization_id,
SUM(sales_orders.omp_order_subtotal_base)::TEXT::MONEY AS total_sales,
EXTRACT(YEAR FROM jmp_job_date) AS year
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE EXTRACT(YEAR FROM jmp_job_date) = '2024'
GROUP BY year, jobs.jmp_customer_organization_id
ORDER BY total_sales DESC;


-- Top X as % of total revenue


SELECT 
jobs.jmp_customer_organization_id, 
SUM(sales_orders.omp_order_subtotal_base)::TEXT::MONEY AS total_revenue,
SUM(sales_orders.omp_order_subtotal_base) * 100 / SUM(SUM(sales_orders.omp_order_subtotal_base)) OVER () AS revenue_percent,
EXTRACT(YEAR FROM jmp_job_date) AS year
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE EXTRACT(YEAR FROM jmp_job_date) = 2023
GROUP BY jobs.jmp_customer_organization_id, EXTRACT(YEAR FROM jmp_job_date)
ORDER BY total_revenue DESC

-- 2023

SELECT 
jobs.jmp_customer_organization_id, 
SUM(sales_orders.omp_order_subtotal_base)::TEXT::MONEY AS total_revenue,
SUM(sales_orders.omp_order_subtotal_base) * 100 / SUM(SUM(sales_orders.omp_order_subtotal_base)) OVER () AS revenue_percent,
EXTRACT(YEAR FROM jmp_job_date) AS year
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
WHERE EXTRACT(YEAR FROM jmp_job_date) = 2024
GROUP BY jobs.jmp_customer_organization_id, EXTRACT(YEAR FROM jmp_job_date)
ORDER BY total_revenue DESC

-- 2024

SELECT 
jobs.jmp_customer_organization_id, 
SUM(sales_orders.omp_order_subtotal_base)::TEXT::MONEY AS total_revenue,
SUM(sales_orders.omp_order_subtotal_base) * 100 / SUM(SUM(sales_orders.omp_order_subtotal_base)) OVER () AS revenue_percent
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
GROUP BY jobs.jmp_customer_organization_id
ORDER BY total_revenue DESC;

-- Top X as % of jobs

SELECT 
COUNT(jobs.jmp_job_id) AS total_jobs
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id

SELECT 
jobs.jmp_customer_organization_id, 
COUNT(jobs.jmp_job_id) AS total_jobs,
(COUNT(jobs.jmp_job_id) * 100 / total_jobs.total_job_count) AS job_pertentage
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id
CROSS JOIN 
(SELECT COUNT(jmp_job_id) AS total_job_count
FROM JOBS) AS total_jobs
GROUP BY jobs.jmp_customer_organization_id, total_jobs.total_job_count
ORDER BY total_jobs DESC;



-- Top X as % of hours worked

SELECT *
FROM jobs
LEFT JOIN sales_order_job_links ON jobs.jmp_job_id = sales_order_job_links.omj_job_id
LEFT JOIN sales_orders ON sales_orders.omp_sales_order_id = sales_order_job_links.omj_sales_order_id




 