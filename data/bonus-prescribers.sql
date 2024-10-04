-- 1. How many npi numbers appear in the prescriber table but not in the prescription table?

-- SELECT COUNT(npi)
-- FROM prescriber
-- 	EXCEPT
-- SELECT COUNT(npi)
-- FROM prescription;

--25050

-- 2.
--     a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.

-- SELECT generic_name
-- FROM drug
-- INNER JOIN prescription
-- 	USING(drug_name)
-- INNER JOIN prescriber
-- 	USING(npi)
-- WHERE prescriber.specialty_description = 'Family Practice'
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5;

-- "OXYCODONE HCL"
-- "LISINOPRIL"
-- "GABAPENTIN"
-- "HYDROCODONE/ACETAMINOPHEN"
-- "LEVOTHYROXINE SODIUM"

--     b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.

-- SELECT generic_name
-- FROM drug
-- INNER JOIN prescription
-- 	USING(drug_name)
-- INNER JOIN prescriber
-- 	USING(npi)
-- WHERE prescriber.specialty_description = 'Cardiology'
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5;

-- "ATORVASTATIN CALCIUM"
-- "ATORVASTATIN CALCIUM"
-- "CLOPIDOGREL BISULFATE"
-- "ATORVASTATIN CALCIUM"
-- "CARVEDILOL"

--     c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.

-- (SELECT generic_name
-- FROM drug
-- INNER JOIN prescription
-- USING(drug_name)
-- INNER JOIN prescriber
-- USING(npi)
-- WHERE prescriber.specialty_description = 'Family Practice'
-- GROUP BY generic_name
-- ORDER BY SUM(total_claim_count) DESC
-- LIMIT 5)
-- 		INTERSECT  
-- (SELECT generic_name
-- FROM drug
-- INNER JOIN prescription
-- USING(drug_name)
-- INNER JOIN prescriber
-- USING(npi)
-- WHERE prescriber.specialty_description = 'Cardiology'
-- 	GROUP BY generic_name
-- ORDER BY SUM(total_claim_count) DESC
-- LIMIT 5);

-- "ATORVASTATIN CALCIUM"
-- "AMLODIPINE BESYLATE"

-- ; needs to be at the end outside the () 
-- INTERSECT brings everything that overlaps
-- Use the SUM(total_claim_count) because we want to get all the values 
-- then use group by to give back the names 
-- Dont include (total_claim_count) in SELECT because it would condridict the INTERSECT because everything as to match


-- 3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
--     a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city.

-- SELECT CONCAT(nppes_provider_first_name, ' ', nppes_provider_last_org_name) AS full_name, total_claim_count, npi, nppes_provider_city
-- FROM prescriber
-- LEFT JOIN prescription
-- 	using(npi)
-- WHERE nppes_provider_city iLIKE 'Nashville'
-- 	AND total_claim_count IS NOT NULL
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5;


-- "JOHN WILLIAMS"	2122	1538103692	"NASHVILLE"
-- "JOHN WILLIAMS"	1911	1538103692	"NASHVILLE"
-- "JOJY JOB"	1714	1407182157	"NASHVILLE"
-- "JOHN WILLIAMS"	1645	1538103692	"NASHVILLE"
-- "VICTOR BYRD"	1578	1952392797	"NASHVILLE"

--     b. Now, report the same for Memphis.

-- SELECT CONCAT(nppes_provider_first_name, ' ', nppes_provider_last_org_name) AS full_name, total_claim_count, npi, nppes_provider_city
-- FROM prescriber
-- LEFT JOIN prescription
-- 	using(npi)
-- WHERE nppes_provider_city iLIKE 'Memphis'
-- 	AND total_claim_count IS NOT NULL
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5;

-- "JEFFERY WARREN"	2956	1225056872	"MEMPHIS"
-- "SUDHA GANGULI"	2878	1639399769	"MEMPHIS"
-- "DANA NASH"	2859	1346291432	"MEMPHIS"
-- "DANA NASH"	2849	1346291432	"MEMPHIS"
-- "SUDHA GANGULI"	2598	1639399769	"MEMPHIS"


--     c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.

-- (SELECT CONCAT(nppes_provider_first_name, ' ', nppes_provider_last_org_name) AS full_name, total_claim_count, npi, nppes_provider_city
-- FROM prescriber
-- LEFT JOIN prescription
-- 	using(npi)
-- WHERE nppes_provider_city iLIKE 'Memphis'
-- 	AND total_claim_count IS NOT NULL
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5)
-- UNION
-- (SELECT CONCAT(nppes_provider_first_name, ' ', nppes_provider_last_org_name) AS full_name, total_claim_count, npi, nppes_provider_city
-- FROM prescriber
-- LEFT JOIN prescription
-- 	using(npi)
-- WHERE nppes_provider_city iLIKE 'Nashville'
-- 	AND total_claim_count IS NOT NULL
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5)
-- UNION
-- (SELECT CONCAT(nppes_provider_first_name, ' ', nppes_provider_last_org_name) AS full_name, total_claim_count, npi, nppes_provider_city
-- FROM prescriber
-- LEFT JOIN prescription
-- 	using(npi)
-- WHERE nppes_provider_city iLIKE 'Knoxville'
-- 	AND total_claim_count IS NOT NULL
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5)
-- UNION
-- (SELECT CONCAT(nppes_provider_first_name, ' ', nppes_provider_last_org_name) AS full_name, total_claim_count, npi, nppes_provider_city
-- FROM prescriber
-- LEFT JOIN prescription
-- 	using(npi)
-- WHERE nppes_provider_city iLIKE 'Chattanooga'
-- 	AND total_claim_count IS NOT NULL
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 5);

-- 4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.

-- SELECT overdose_deaths , fips_county.county
-- FROM overdose_deaths
-- CROSS JOIN fips_county
-- 	WHERE overdose_deaths > 12.6052631578947368 --avg(overdose_deaths)
-- 	GROUP BY fips_county.county , overdose_deaths;

-- NOT 100%

-- 5.
--     a. Write a query that finds the total population of Tennessee.

-- SELECT SUM(population)
-- FROM population
-- INNER JOIN fips_county
-- 	USING(fipscounty)
-- WHERE state = 'TN';

--     b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.

-- SELECT population, county , ((population / 6597381)* 100) AS population_Percent
-- FROM population
-- INNER JOIN fips_county
-- 	USING(fipscounty)
-- WHERE state = 'TN'
-- 	GROUP BY population.population, fips_county.county;

--not sure how to display %