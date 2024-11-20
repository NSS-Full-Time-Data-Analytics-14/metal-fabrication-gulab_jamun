SELECT ima_part_id, COUNT(ima_part_id) AS part_count, ima_part_long_description_text AS part_description
FROM part_assemblies
GROUP BY ima_part_id, ima_part_long_description_text
ORDER BY part_count DESC;

--how many times did each company order a part 
WITH companies_parts_grouped AS (SELECT jmp_customer_organization_id, imp_part_id,
	ROW_NUMBER() OVER(PARTITION BY jmp_customer_organization_id ORDER BY COUNT(imp_part_id) DESC) AS number_of_parts_ordered
FROM jobs as j
	Inner JOIN parts AS p
		ON j.jmp_part_id = p.imp_part_id
GROUP BY  jmp_customer_organization_id, imp_part_id)

SELECT jmp_customer_organization_id, imp_part_id, number_of_parts_ordered
FROM companies_parts_grouped
	INNER JOIN parts USING(imp_part_id)
ORDER BY number_of_parts_ordered DESC;

SELECT DISTINCT jmp_customer_organization_id
FROM jobs
WHERE jmp_customer_organization_id IS NOT NULL;







WITH companies_parts_grouped AS (SELECT jmp_customer_organization_id, imp_part_id AS part_id, COUNT(imp_part_id),
	ROW_NUMBER() OVER(PARTITION BY jmp_customer_organization_id ORDER BY COUNT(imp_part_id) DESC) AS number_of_parts_ordered
FROM jobs as j
	Inner JOIN parts AS p
		ON j.jmp_part_id = p.imp_part_id
GROUP BY  jmp_customer_organization_id, imp_part_id)

SELECT jmp_customer_organization_id, imp_part_id, number_of_parts_ordered
FROM companies_parts_grouped
	INNER JOIN parts USING(imp_part_id)
ORDER BY number_of_parts_ordered DESC;

select *
from PARTS




WITH companies_parts_grouped AS (SELECT jmp_customer_organization_id, jmp_part_id AS part_id, COUNT(j.jmp_part_id) AS total_parts_ordered, imp_long_description_text,
    										ROW_NUMBER() OVER (PARTITION BY j.jmp_customer_organization_id ORDER BY COUNT(j.jmp_part_id) DESC) AS number_of_parts_ordered
  								  FROM jobs AS j
  									INNER JOIN parts AS p
    									ON j.jmp_part_id = p.imp_part_id
  												GROUP BY jmp_customer_organization_id, jmp_part_id, imp_long_description_text)

SELECT  jmp_customer_organization_id, part_id, total_parts_ordered, imp_long_description_text
FROM companies_parts_grouped

WHERE jmp_customer_organization_id IS NOT NULL
				AND number_of_parts_ordered = 1
ORDER BY jmp_customer_organization_id DESC;

SELECT *
FROM job_operations_2024
WHERE jmo_due_date <= '2024-11-17 00:00:00'

--2. Analyze parts. The part can be identified by the jmp_part_id from the jobs table or the jmp_part_id from the 
--job_operations_2023/job_operations_2024 tables. Here are some questions to get started:

--2a Break down parts by volume of jobs. 
--Which parts are making up the largest volume of jobs? 
--Which ones are taking the largest amount of production hours (based on the jmo_actual_production_hours in the job_operations tables)?

SELECT y23.jmo_part_id, imp_short_description, COUNT(DISTINCT y23.jmo_job_id) AS job_count, SUM(y23.jmo_actual_production_hours) as total_production_hours
FROM job_operations_2023 as y23
	LEFT JOIN job_operations_2024 AS y24 USING(jmo_job_id)
	INNER JOIN parts ON y23.jmo_part_id = parts.imp_part_id
WHERE y23.jmo_part_id IS NOT NULL
GROUP BY y23.jmo_part_id, imp_short_description

SELECT *
FROM parts





-- WITH most_jobs_per_part AS (SELECT jmp_part_id, COUNT(jmp_job_id) AS job_count, imp_long_description_text
-- FROM jobs 
--   INNER JOIN parts 
--     	ON jobs.jmp_part_id = parts.imp_part_id
-- GROUP BY jmp_part_id, imp_long_description_text
-- ORDER BY job_count DESC)


-- SELECT jmp_part_id, job_count, SUM(y23.jmo_actual_production_hours) AS time_consuming_by_hour, imp_long_description_text
-- FROM job_operations_2023 AS y23
-- 	LEFT JOIN job_operations_2024 AS y24 USING(jmo_job_id)
-- 	INNER JOIN most_jobs_per_part
-- 			ON most_jobs_per_part.jmp_part_id = y23.jmo_part_id
-- GROUP BY jmp_part_id, job_count, imp_long_description_text
-- ORDER BY time_consuming_by_hour DESC



--2B: How have the parts produced changed over time? Are there any trends? 
--Are there parts that were prominent in 2023 but are no longer being produced or are being produced at much lower volumes in 2024? 
--Have any new parts become more commonly produced over time?   

SELECT DISTINCT jmo_part_id, imp_short_description,imp_long_description_text, COUNT(jmo_part_id) AS parts_count
FROM job_operations_2023
	INNER JOIN parts
		ON job_operations_2023.jmo_part_id = parts.imp_part_id
GROUP BY jmo_part_id,imp_short_description, imp_long_description_text
EXCEPT
SELECT DISTINCT jmo_part_id, imp_short_description, imp_long_description_text, COUNT(jmo_part_id) AS parts_count
FROM job_operations_2024
	INNER JOIN parts
		ON job_operations_2024.jmo_part_id = parts.imp_part_id
GROUP BY jmo_part_id,imp_short_description, imp_long_description_text
ORDER BY parts_count DESC
-- found rows that are found in 2023 but not in 2024


--2C Are there parts that frequently exceed their planned production hours 
--(determined by comparing the jmo_estimated_production_hours to the jmo_actual_production_hours in the job_operations tables)?  
SELECT *
FROM parts

SELECT y23.jmo_part_id, imp_short_description, imp_long_description_text, COUNT(*) AS frequent_exceed
FROM job_operations_2023 AS y23
	LEFT JOIN job_operations_2023 as y24 USING(jmo_part_id)
	INNER JOIN parts ON y23.jmo_part_id = parts.imp_part_id
WHERE jmo_part_id IS NOT NULL
		AND y23.jmo_actual_production_hours > y23.jmo_estimated_production_hours
GROUP BY jmo_part_id, imp_short_description, imp_long_description_text
HAVING COUNT(*) > 10
ORDER BY frequent_exceed DESC;











--2D Are the most high-volume parts also ones that are generating the most revenue per production hour? 
SELECT y23.jmo_part_id, COUNT(y23.jmo_job_id) AS job_count, SUM(y23.jmo_actual_production_hours) 
FROM job_operations_2023 as y23
	LEFT JOIN job_operations_2024 AS y24 USING(jmo_job_id)
WHERE y23.jmo_part_id IS NOT NULL
GROUP BY y23.jmo_part_id;

SELECT *
FROM jobs
-- from jobs - jmporder_quntity

SELECT imp_part_id, imp_long_description_text, imo_unit_cost1
FROM parts
	LEFT JOIN part_operations
			ON parts.imp_part_id = part_operations.imo_part_id
WHERE imo_unit_cost1 IS NOT NULL
ORDER BY imo_unit_cost1 DESC




-- How many parts are orderd between Jan 2023 & Halloween 2024
SELECT imp_part_id, imp_short_description, imp_long_description_text, COUNT(imp_part_id) AS part_counts
FROM parts
	INNER JOIN part_operations AS j_ops ON J_ops.imo_part_id = parts.imp_part_id
	INNER JOIN job_operations_2023 as y23
		ON y23.jmo_part_id = parts.imp_part_id
	LEFT JOIN job_operations_2024 as y24 
				USING(jmo_part_id)
WHERE j_ops.imo_created_date >= '2023-01-01 00:00:00' AND j_ops.imo_created_date <= '2024-10-31 23:59:59'
GROUP BY imp_part_id, imp_short_description, imp_long_description_text
ORDER BY part_counts DESC





SELECT *
FROM part_operations;



--2023
SELECT imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, COUNT(imp_part_id) AS part_counts,
																			CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2023'
																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2023'
        																				WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quarter 3 - 2023'
        																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2023'
    																	END AS year_quarter
FROM parts
	INNER JOIN part_operations AS j_ops ON J_ops.imo_part_id = parts.imp_part_id
	INNER JOIN job_operations_2023 as y23
		ON y23.jmo_part_id = parts.imp_part_id
WHERE j_ops.imo_created_date >= '2023-01-01 00:00:00' AND j_ops.imo_created_date <= '2024-10-31 23:59:59'
GROUP BY imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, j_ops.imo_created_date	
UNION ALL
SELECT imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, COUNT(imp_part_id) AS part_counts,
																			CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2024'
																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2024'
        																				WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quearter 3 - 2024'
        																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2024'
    																	END AS year_quarter
FROM parts
	INNER JOIN part_operations AS j_ops ON J_ops.imo_part_id = parts.imp_part_id
	INNER JOIN job_operations_2024 as y24
		ON y24.jmo_part_id = parts.imp_part_id
WHERE j_ops.imo_created_date >= '2023-01-01 00:00:00' AND j_ops.imo_created_date <= '2024-10-31 23:59:59'
GROUP BY imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, j_ops.imo_created_date
ORDER BY year_quarter ASC


-- --Window function for diving data by year quarter
-- ROW_NUMBER() OVER(PARTITION BY CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2023'
-- WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2023'
-- WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quarter 3 - 2023'
-- WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2023'
-- END
--  	ORDER BY ORDER BY COUNT(imp_part_id) DESC) AS parts_ranked_quarter




-- ROW_NUMBER() OVER(PARTITION BY CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2024'
-- WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2024'
-- WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quarter 3 - 2024'
-- WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2024'
-- END
--  	ORDER BY ORDER BY COUNT(imp_part_id) DESC) AS parts_ranked_quarter


-- SELECT * 
-- FROM year_quarter_parts_rank
-- ORDER BY year_quarter ASC, parts_ranked_quarter;



WITH year_quarter_parts_rank AS (SELECT imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, COUNT(imp_part_id) AS part_counts,
																			CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2023'
																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2023'
        																				WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quarter 3 - 2023'
        																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2023'
    																	END AS year_quarter, ROW_NUMBER() OVER(PARTITION BY CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2023'
WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2023'
WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quarter 3 - 2023'
WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2023'
END
 	ORDER BY  COUNT(imp_part_id) DESC) AS parts_ranked_quarter
FROM parts
	INNER JOIN part_operations AS j_ops ON J_ops.imo_part_id = parts.imp_part_id
	INNER JOIN job_operations_2023 as y23
		ON y23.jmo_part_id = parts.imp_part_id
WHERE j_ops.imo_created_date >= '2023-01-01 00:00:00' AND j_ops.imo_created_date <= '2024-10-31 23:59:59'
GROUP BY imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, j_ops.imo_created_date
UNION ALL
SELECT imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, COUNT(imp_part_id) AS part_counts,
																			CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2024'
																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2024'
        																				WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quearter 3 - 2024'
        																					WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2024'
    																	END AS year_quarter, ROW_NUMBER() OVER(PARTITION BY CASE WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 1 AND 3 THEN 'Quarter 1 - 2024'
WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 4 AND 6 THEN 'Quarter 2 - 2024'
WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 7 AND 9 THEN 'Quarter 3 - 2024'
WHEN EXTRACT(MONTH FROM imo_created_date) BETWEEN 10 AND 12 THEN 'Quarter 4 - 2024'
END
 	ORDER BY COUNT(imp_part_id) DESC) AS parts_ranked_quarter
FROM parts
	INNER JOIN part_operations AS j_ops ON J_ops.imo_part_id = parts.imp_part_id
	INNER JOIN job_operations_2024 as y24
		ON y24.jmo_part_id = parts.imp_part_id
WHERE j_ops.imo_created_date >= '2023-01-01 00:00:00' AND j_ops.imo_created_date <= '2024-10-31 23:59:59'
GROUP BY imp_part_id, imp_short_description, imp_long_description_text, imo_unit_cost1, j_ops.imo_created_date
ORDER BY year_quarter ASC)


SELECT * 
FROM year_quarter_parts_rank
ORDER BY year_quarter ASC, parts_ranked_quarter;













-- Hunter's code
SELECT jmo_process_id, COUNT(jmo_process_id) AS count_process_2023
FROM jobs
		INNER JOIN job_operations_2023 ON jobs.jmp_job_id = job_operations_2023.jmo_job_id
WHERE jmo_start_date>= '2023-01-01 00:00:00' AND jmo_start_date<= '2023-10-31 00:00:00'
GROUP BY jmo_process_id
ORDER BY count_process_2023 DESC;

SELECT jmo_process_id, COUNT(jmo_process_id) AS count_process_2024
FROM jobs
		INNER JOIN job_operations_2024 ON jobs.jmp_job_id = job_operations_2024.jmo_job_id
WHERE jmo_start_date>= '2024-01-01 00:00:00' AND jmo_start_date<= '2024-10-31 00:00:00'
GROUP BY jmo_process_id
ORDER BY count_process_2024 DESC;









-- Chris's code
WITH job_operations AS(SELECT jmo_job_id, jmo_process_short_description, jmo_estimated_production_hours
					  FROM job_operations_2023
					  UNION 
					  SELECT jmo_job_id, jmo_process_short_description, jmo_estimated_production_hours
					  FROM job_operations_2024),

other_tables AS 
(SELECT * 
FROM sales_order_job_links INNER JOIN jobs ON omj_job_id = jmp_job_id
                           INNER JOIN job_operations ON jmp_job_id = jmo_job_id)
						   
SELECT DISTINCT oml_sales_order_line_id, jmo_process_short_description, jmo_estimated_production_hours, jmp_scheduled_due_date, jmp_scheduled_start_date, jmp_completed_date, 
								oml_sales_order_id, oml_part_id, oml_part_short_description, oml_order_quantity, oml_full_unit_price_base, oml_full_extended_price_base, omp_full_order_subtotal_base
FROM sales_order_lines INNER JOIN sales_orders ON omp_sales_order_id = oml_sales_order_id
                       INNER JOIN other_tables ON oml_sales_order_id = omj_sales_order_id

