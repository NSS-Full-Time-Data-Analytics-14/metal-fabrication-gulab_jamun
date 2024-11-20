--------------------------------------------
-- A few tips for navigating the database --
--------------------------------------------
-- Each job can have multiple job operations in the job_operations_2023/job_operations_2024 table. 

-- You can connect the jobs to the job_operations.

-- The jmp_job_id references jmo_job_id in the job_operations_2023/job_operations_2024 tables.

-- Jobs can be connected to sales orders through the sales_order_job_links table. 
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------
-- NOTES --
-----------
-- There is a typo in  #2 at the beginning when it says:
-- "The part can be identified by the jmp_part_id from the jobs table or the jmp_part_id from the job_operations_2023/job_operations_2024 tables." 

-- It should say: 
-- "jmo_part_id" when referring to the job_operations_2023/job_operations_2024 tables. 

-----------
-- There is a typo on the ERD when referring to the keys it says:
-- "oml_part_id = imp_job_id"

-- It should be: 
-- "oml_part_id = imp_part_id"

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Just doing some basic looking around at first --
SELECT * 
FROM jobs;

SELECT *
FROM job_operations_2023;

SELECT *
FROM job_operations_2024;

--------------------------
-- total number of parts in the 2023 table                  -- 6584 -- 
SELECT 
	COUNT(jmo_part_id)                                       
FROM job_operations_2023;

-- how many different parts in 2023 table                    -- 1130 -- ♫
SELECT 
	COUNT(DISTINCT jmo_part_id)                                              -- ♫ + ♪ = 2445 --
FROM job_operations_2023;

-- how many different parts in 2024 table                    -- 1315 -- ♪
SELECT 
	COUNT(DISTINCT jmo_part_id)
FROM job_operations_2024;

-- total number of parts in the 2024 table                  -- 6718 -- 
SELECT 
	COUNT(jmo_part_id)                                       
FROM job_operations_2024;

-- how many different parts in the jobs table                -- 3697 --
SELECT 
	COUNT(DISTINCT jmp_part_id)
FROM jobs;

-- the total number of parts in the jobs table              -- 14,815 --
SELECT 
	COUNT(jmp_part_id)
FROM jobs;



-- looking for the difference between oml_extended_price_base and oml_extended_price_foreign columns in the sales_order_lines table
SELECT 
	SUM(oml_extended_price_base)
FROM sales_order_lines;

SELECT 
	SUM(oml_extended_price_foreign)
FROM sales_order_lines;
												-- confirmed that they are the same






-- Analyze parts.                                                             ↓
-- The part can be identified by the jmp_part_id from the jobs table or the jmo_part_id from the job_operations_2023/job_operations_2024 tables. 
------------------------------------------------------------------------------------------------------------------------------------------------
-- Break down parts by volume of jobs. 
-- Which parts are making up the largest volume of jobs? 
-- Which ones are taking the largest amount of production hours (based on the jmo_actual_production_hours in the job_operations tables)?  



-- Joining jobs table to job operations 2023 
SELECT *
FROM jobs t1
INNER JOIN job_operations_2023 t23 ON t23.jmo_job_id = t1.jmp_job_id   -- 42437 -- 

SELECT *
FROM jobs t1
LEFT JOIN job_operations_2023 t23 ON t23.jmo_job_id = t1.jmp_job_id    -- 48528 --

	
-- Joining jobs table to job operations 2024 
SELECT *
FROM jobs t1
INNER JOIN job_operations_2024 t24 ON t24.jmo_job_id = t1.jmp_job_id   -- 42152 --

SELECT *
FROM jobs t1
LEFT JOIN job_operations_2024 t24 ON t24.jmo_job_id = t1.jmp_job_id	-- 50917 --

	
-- Joining all 3 ----------------------------------------------------------------------------------------
--SELECT *
--FROM jobs t1
--RIGHT JOIN job_operations_2023 t23 ON t23.jmo_job_id = t1.jmp_job_id
--RIGHT JOIN job_operations_2024 t24 ON t23.jmo_job_id = t1.jmp_job_id   -- HUSTON, WE HAVE A PROBLEM. --
---------------------------------------------------------------------------------------------------------

	
-- Breaking down parts by volume of jobs.. I think ♪♫♪♪ -----------------------------------------	
SELECT 
	t1.jmp_job_id AS job_table_id,
	t23.jmo_job_id AS job_2023_id,
	COUNT(*) AS job_count
FROM jobs t1
INNER JOIN job_operations_2023 t23 ON t23.jmo_job_id = t1.jmp_job_id	  
GROUP BY job_table_id, job_2023_id
ORDER BY job_count DESC;                                               -- jobs + 2023 --


SELECT 
	t1.jmp_job_id AS job_table_id,
	t24.jmo_job_id AS job_2024_id,
	COUNT(*) AS job_count
FROM jobs t1
INNER JOIN job_operations_2024 t24 ON t24.jmo_job_id = t1.jmp_job_id	  
GROUP BY job_table_id, job_2024_id
ORDER BY job_count DESC;                                               -- jobs + 2024 --


-- Since I cant seem to join all 3 of them yet, I will attempt to union.. maybe a CTE setup.. -- ♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪♪

------------------------------------------------------------------------------------------------


-- Figuring out which parts are making up the largest volume of jobs

SELECT
	jmp_part_id,
	COUNT(*) AS job_count
FROM jobs
GROUP BY jmp_part_id                 
ORDER BY job_count DESC;            
                                      
-- jmp_part_id | job_count |  what_it_is     
-----------------------------------------------------
--   M030-0204 |        88 |  WHEEL BX END PANEL RH        
--   M030-0203 |        87 |  WHEEL BX END PANEL LH
--   M030-0401 |        74 |  BRKT H/SHLD
--   S025-0508 |        70 |  C FRAME (REAR)
--   M030-0400 |        65 |  C/P PR D/FLR
-----------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- TEAM PIVOT TO #3 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--  3. Inspect the type of operation for each job, as indicated by the jmo_process_short_description in the job_operations_2023 or job_operations_2024 table.    

SELECT * FROM job_operations_2023;                  -- 42685 rows --

SELECT * FROM job_operations_2024;                  -- 42303 rows --
----------------------------------------------------------------------

-- peeping at the two tables through the different kind of joins
SELECT * 
FROM job_operations_2023 t23
INNER JOIN job_operations_2024 t24 USING(jmo_job_id)  -- 3348 rows --

SELECT * 
FROM job_operations_2023 t23
LEFT JOIN job_operations_2024 t24 USING(jmo_job_id)   -- 45870 rows --

SELECT * 
FROM job_operations_2023 t23
RIGHT JOIN job_operations_2024 t24 USING(jmo_job_id)  -- 45594 rows --

SELECT * 
FROM job_operations_2023 t23
FULL JOIN job_operations_2024 t24 USING(jmo_job_id)   -- 88116 rows --

SELECT * 
FROM job_operations_2023 t23
CROSS JOIN job_operations_2024 t24                   -- NOT GONNA HAPPEN --
-----------------------------------------------------------------------------
-- Counting how many time each short description is logged for 2023 / 2024

SELECT 
	jmo_process_short_description,
	COUNT(jmo_process_short_description) descrip_count_2023
FROM job_operations_2023 t23
GROUP BY t23.jmo_process_short_description, t23.jmo_part_id
ORDER BY descrip_count_2023 DESC;                                  -- For 2023


SELECT 
	jmo_process_short_description,
	COUNT(jmo_process_short_description) descrip_count_2024
FROM job_operations_2024 t24
GROUP BY t24.jmo_process_short_description, t24.jmo_part_id
ORDER BY descrip_count_2024 DESC;                                 -- For 2024


-- a. Are there certain operations, such as welding, which generate more revenue per production hour?

-- looking at anything to do with production hours
SELECT 
--  jmo_start_hour,
--  jmo_due_hour,
--  jmo_estimated_production_hours,
--  jmo_completed_setup_hours,
	jmo_completed_production_hours,
	jmo_actual_production_hours  
--  jmo_actual_setup_hours
FROM job_operations_2023 t23;

SELECT 
--  jmo_start_hour,
--  jmo_due_hour,
--  jmo_estimated_production_hours,
--  jmo_completed_setup_hours,
	jmo_completed_production_hours,
	jmo_actual_production_hours 
--  jmo_actual_setup_hours
FROM job_operations_2024 t24;
---------------------------------------------------------------------
-- taking a gander at all dat $money data 

SELECT * FROM sales_orders;  

SELECT * FROM sales_order_job_links;  

SELECT * FROM jobs;  

SELECT * FROM job_operations_2023;                  

SELECT * FROM job_operations_2024;  

---------------------------------------------------------------------
-- just building a join for all the necessary tables to look some more

SELECT                                                            
	*
FROM jobs j1
INNER JOIN sales_order_job_links s2 ON j1.jmp_job_id = s2.omj_job_id
INNER JOIN sales_orders s3 ON s3.omp_sales_order_id = s2.omj_sales_order_id
INNER JOIN job_operations_2023 t23 ON j1.jmp_job_id = t23.jmo_job_id
INNER JOIN job_operations_2024 t24 ON j1.jmp_job_id = t24.jmo_job_id;
---------------------------------------------------------------------

-- Searching for the revenue column I should use to calculate with the production hour
	
SELECT * FROM sales_order_job_links;

SELECT * FROM sales_order_lines; 

SELECT * FROM sales_orders;
-- omp_order_full_order_subtotal_base
-- omp_full_order_subtotal_foreign
   omp_order_subtotal_base ---------------- Using Jennas' suggestion!
-- omp_order_sub_total_foreign
-- omp_order_total_base
-- omp_order_total_foreign

 
-- hmmmmm....... 😵‍💫
-------------------------------------------------------------------------
-- considering a CTE approach...

--------------------
-- COLUMNS NEEDED --
--------------------

-- jmo_process_short_description (table = job_operations_2023 | job_operations_2024)
-- COUNT(jmo_process_short_description) descrip_count_2023
-- jmo_completed_production_hours (table = job_operations_2023 | job_operations_2024)
   SUM(jmo_completed_production_hours)
-- SUM(omp_order_subtotal_base) (table = sales_orders)
   


-- putting it together one step at a time ♥
SELECT 
	jmo_process_short_description AS how_its_made,
	COUNT(jmo_process_short_description) AS made_count_2023,
	ROUND(SUM(jmo_completed_production_hours::text::numeric),0) AS total_hours_making
FROM job_operations_2023 t23
GROUP BY t23.jmo_process_short_description, t23.jmo_part_id
ORDER BY total_hours_making DESC;                                  -- For 2023


SELECT 
	jmo_process_short_description AS how_its_made,
	COUNT(jmo_process_short_description) AS made_count_2024,
	ROUND(SUM(jmo_completed_production_hours::text::numeric),0) AS total_hours_making
FROM job_operations_2024 t24
GROUP BY t24.jmo_process_short_description, t24.jmo_part_id
ORDER BY total_hours_making DESC;                              -- For 2024


-- now adding the revenue in to wrap it up ----------------------------------------------


-- 2024 ----------------------------
SELECT                                                            
	t24.jmo_process_short_description AS how_its_made,
	COUNT(t24.jmo_process_short_description) AS made_count_2024,
	ROUND(SUM(t24.jmo_completed_production_hours::TEXT::NUMERIC),0) AS total_hours_making,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0)::MONEY AS total_revenue_made_2024 -- ← ← ← ← ← ← ← ← ← ← ← ←
FROM jobs j1
INNER JOIN sales_order_job_links s2 ON j1.jmp_job_id = s2.omj_job_id
INNER JOIN sales_orders s3 ON s3.omp_sales_order_id = s2.omj_sales_order_id
INNER JOIN job_operations_2024 t24 ON j1.jmp_job_id = t24.jmo_job_id
GROUP BY t24.jmo_process_short_description
ORDER BY total_revenue_made_2024 DESC; 


-- 2023 ---------------------------
SELECT                                                            
	t23.jmo_process_short_description AS how_its_made,
	COUNT(t23.jmo_process_short_description) AS made_count_2023,
	ROUND(SUM(t23.jmo_completed_production_hours::TEXT::NUMERIC),0) AS total_hours_making,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0)::MONEY AS total_revenue_made_2023 -- ← ← ← ← ← ← ← ← ← ← ← ←
FROM jobs j1
INNER JOIN sales_order_job_links s2 ON j1.jmp_job_id = s2.omj_job_id
INNER JOIN sales_orders s3 ON s3.omp_sales_order_id = s2.omj_sales_order_id
INNER JOIN job_operations_2023 t23 ON j1.jmp_job_id = t23.jmo_job_id
GROUP BY t23.jmo_process_short_description
ORDER BY total_revenue_made_2023 DESC;  


-- refining the final product -------------------------------------------------------------

-- 2023 -- 
SELECT                                                            
	t23.jmo_process_short_description AS how_its_made,
	COUNT(t23.jmo_process_short_description) AS made_count_2023,
	ROUND(SUM(t23.jmo_completed_production_hours::TEXT::NUMERIC),0) AS total_hours_making,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0)::MONEY AS total_revenue_made_2023,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0 / NULLIF(SUM(t23.jmo_completed_production_hours::TEXT::NUMERIC), 0), 2) AS rev_an_hour
FROM jobs j1
INNER JOIN sales_order_job_links s2 ON j1.jmp_job_id = s2.omj_job_id
INNER JOIN sales_orders s3 ON s3.omp_sales_order_id = s2.omj_sales_order_id
INNER JOIN job_operations_2023 t23 ON j1.jmp_job_id = t23.jmo_job_id
GROUP BY t23.jmo_process_short_description
ORDER BY rev_an_hour DESC; 

-- hmmmm.......
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2024 --
SELECT                                                            
	t24.jmo_process_short_description AS how_its_made,
	COUNT(t24.jmo_process_short_description) AS made_count_2024,
	ROUND(SUM(t24.jmo_completed_production_hours::TEXT::NUMERIC), 0) AS total_hours_making,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0)::MONEY AS total_revenue_made_2024,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0 / NULLIF(SUM(t24.jmo_completed_production_hours::TEXT::NUMERIC), 0), 2) AS rev_an_hour
FROM jobs j1
INNER JOIN sales_order_job_links s2 ON j1.jmp_job_id = s2.omj_job_id
INNER JOIN sales_orders s3 ON s3.omp_sales_order_id = s2.omj_sales_order_id
INNER JOIN job_operations_2024 t24 ON j1.jmp_job_id = t24.jmo_job_id
GROUP BY t24.jmo_process_short_description
ORDER BY 
	CASE WHEN ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0 / NULLIF(SUM(t24.jmo_completed_production_hours::TEXT::NUMERIC), 0), 2) IS NULL THEN 1 ELSE 0 END,
    ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0 / NULLIF(SUM(t24.jmo_completed_production_hours::TEXT::NUMERIC), 0), 2) DESC;

-- 2023 --
SELECT                                                            
	t23.jmo_process_short_description AS how_its_made,
	COUNT(t23.jmo_process_short_description) AS made_count_2023,
	ROUND(SUM(t23.jmo_completed_production_hours::TEXT::NUMERIC),0) AS total_hours_making,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0)::MONEY AS total_revenue_made_2023,
	ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0 / NULLIF(SUM(t23.jmo_completed_production_hours::TEXT::NUMERIC), 0), 2) AS rev_an_hour
FROM jobs j1
INNER JOIN sales_order_job_links s2 ON j1.jmp_job_id = s2.omj_job_id
INNER JOIN sales_orders s3 ON s3.omp_sales_order_id = s2.omj_sales_order_id
INNER JOIN job_operations_2023 t23 ON j1.jmp_job_id = t23.jmo_job_id
GROUP BY t23.jmo_process_short_description
ORDER BY 
	CASE WHEN ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0 / NULLIF(SUM(t23.jmo_completed_production_hours::TEXT::NUMERIC), 0), 2) IS NULL THEN 1 ELSE 0 END,
    ROUND(SUM(s3.omp_order_subtotal_base::NUMERIC)* 1.0 / NULLIF(SUM(t23.jmo_completed_production_hours::TEXT::NUMERIC), 0), 2) DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--    b. Are certain operations consistently generating more revenue per production hour than others or has it changed over time?  






--    c. Which operations are most frequently associated with the company's top customers? 
--       Are they also the ones that are generating the most revenue per production hour?  