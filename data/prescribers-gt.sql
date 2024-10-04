-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- SELECT  DISTINCT (npi),
-- 	SUM(total_claim_count) AS num_claims
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- 	WHERE total_claim_count IS NOT NULL
-- 	GROUP BY  prescriber.npi
-- 	ORDER BY num_claims DESC
-- LIMIT 10;

-- 1881634483	99707   

--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.


-- SELECT  nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, SUM(total_claim_count) 
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- 	WHERE total_claim_count IS NOT NULL
-- 	GROUP BY  prescriber.nppes_provider_first_name , prescriber.nppes_provider_last_org_name, prescriber.specialty_description
-- 	ORDER BY SUM(total_claim_count) DESC
-- LIMIT 10;

--"BRUCE"	"PENDLEY"	"Family Practice"	99707

-- UNDER HERE is incorrect
-- SELECT nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- 	ORDER BY total_claim_count DESC
-- 	LIMIT 1;

	--"DAVID" "COFFEY" "Family Practice" 4538


-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

-- SELECT specialty_description, SUM(total_claim_count):: MONEY
-- FROM prescription
-- INNER JOIN prescriber
-- USING(npi)
-- 	GROUP BY prescriber.specialty_description
-- 	ORDER BY SUM(total_claim_count) DESC
-- 	LIMIT 10;

--"Family Practice"	"$9,752,347.00"


--     b. Which specialty had the most total number of claims for opioids?

-- SELECT specialty_description, SUM(total_claim_count):: MONEY
-- FROM prescription
-- INNER JOIN prescriber
-- USING(npi)
-- 	INNER JOIN drug
-- USING(drug_name)
-- 	WHERE opioid_drug_flag LIKE '%Y%'
-- 	GROUP BY prescriber.specialty_description
-- 	ORDER BY SUM(total_claim_count) DESC
-- 	LIMIT 10;

-- "Nurse Practitioner"	"$900,845.00"

--UNDER HERE IS WONG
-- SELECT specialty_description, total_claim_count, opioid_drug_flag
-- FROM prescription
-- INNER JOIN prescriber
-- USING(npi)
-- INNER JOIN drug
-- USING(drug_name)
-- 	WHERE opioid_drug_flag LIKE '%Y%'
-- 	ORDER BY total_claim_count DESC;


--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?



-- SELECT DISTINCT(specialty_description)
-- FROM prescriber
-- LEFT JOIN prescription
-- USING(npi)
-- 	GROUP BY specialty_description
-- 	HAVING COUNT(total_claim_count) = 0;


--JEN's ANSWER
-- SELECT prescriber.specialty_description, COUNT(prescription.drug_name) AS num_prescriptions
-- FROM prescriber
-- LEFT JOIN prescription
-- USING(npi)
-- GROUP BY prescriber.specialty_description
-- HAVING COUNT(prescription.drug_name) = 0
-- ;

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

--FROM CLASS FOR REVIEW
-- SELECT
-- 	specialty_description,
-- 	SUM(
-- 		CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count
-- 		ELSE 0
-- 	END
-- 	) as opioid_claims,
-- 	SUM(total_claim_count) AS total_claims,
-- 	SUM(
-- 		CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count
-- 		ELSE 0
-- 	END
-- 	) * 100.0 /  SUM(total_claim_count) AS opioid_percentage
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- INNER JOIN drug
-- USING(drug_name)
-- GROUP BY specialty_description
-- ORDER BY opioid_percentage DESC;

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

-- SELECT generic_name, SUM(total_drug_cost) :: MONEY
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- 	GROUP BY generic_name
-- ORDER BY SUM(total_drug_cost) DESC
-- LIMIT 10;

--"INSULIN GLARGINE,HUM.REC.ANLOG"	"$104,264,066.35"

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**


-- SELECT generic_name, ROUND(SUM(total_drug_cost)/SUM(total_day_supply), 2) :: MONEY AS cost_per_day
-- FROM prescription 
-- INNER JOIN drug
-- USING (drug_name)
-- 	GROUP BY generic_name
-- 	ORDER BY cost_per_day DESC
-- 	LIMIT 1;

-- "C1 ESTERASE INHIBITOR"	"$3,495.22"

-- FIRST ATTEMPT
-- SELECT generic_name, ROUND(total_drug_cost/365, 2) :: MONEY AS cost_per_day
-- FROM prescription 
-- INNER JOIN drug
-- USING (drug_name)
-- 	ORDER BY total_drug_cost DESC
-- 	LIMIT 1;

--"PIRFENIDONE"	"$7,751.00"

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 

-- SELECT drug_name, 
-- 	--antibiotic_drug_flag,
-- 	--opioid_drug_flag,
-- 	CASE 
-- 		WHEN opioid_drug_flag LIKE '%Y%' THEN 'opioid' 
-- 		WHEN antibiotic_drug_flag LIKE '%Y%' THEN 'antibiotic' 
-- 		ELSE 'neither'
-- 	END AS drug_type
-- FROM drug
-- INNER JOIN prescription
-- USING (drug_name);


--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- SELECT 
-- 	CASE 
-- 		WHEN opioid_drug_flag LIKE '%Y%' THEN 'opioid' 
-- 		WHEN antibiotic_drug_flag LIKE '%Y%' THEN 'antibiotic' 
-- 		ELSE 'neither'
-- 	END AS drug_type,
-- 	SUM(total_drug_cost):: MONEY --AS X
-- FROM drug
-- INNER JOIN prescription
-- USING (drug_name)
-- GROUP BY drug_type
-- ORDER BY SUM(total_drug_cost) DESC;

--"opioid"	"$105,080,626.37"

-- BY taking out the names of drugs, creating a sum of total_drug_cost, and grouping the query via drug type. WHY DOESNT ORDER BY WORK? because it was trying to order by all the values. 

-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

-- SELECT state, COUNT(cbsa)
-- FROM cbsa
-- INNER JOIN fips_county
-- USING (fipscounty)
-- 	WHERE state iLIKE 'TN'
-- 	GROUP BY fips_county.state;

--"TN"	42

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

-- SELECT cbsaname, SUM(population), state
-- FROM cbsa
-- INNER JOIN fips_county
-- USING (fipscounty)
-- INNER JOIN population
-- USING (fipscounty)
-- 	GROUP BY cbsaname, state
-- 	ORDER BY SUM(population) DESC;

-- "Nashville-Davidson--Murfreesboro--Franklin, TN"	1830410	"TN"
-- "Memphis, TN-MS-AR"	1038617	"TN"

--WHY IS IT ONLY SHOWING 'TN' cbsa(s)

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- SELECT population, county
-- FROM fips_county
-- INNER JOIN population
-- USING (fipscounty)
-- WHERE fipscounty NOT IN (SELECT fipscounty FROM cbsa)
-- 	ORDER BY population DESC;
--95523	"SEVIER"

-- USING an Anti JOIN to exclude fipscounty FROM cbsa.

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- SELECT drug_name, total_claim_count
-- FROM prescription
-- 	WHERE total_claim_count >= 3000;

--"MIRTAZAPINE"	3085
--"LISINOPRIL"	3655
-- "FUROSEMIDE"	3083
-- "LEVOTHYROXINE SODIUM"	3023
-- "GABAPENTIN"	3531
-- "OXYCODONE HCL"	4538
-- "HYDROCODONE-ACETAMINOPHEN"	3376
-- "LEVOTHYROXINE SODIUM"	3101
-- "LEVOTHYROXINE SODIUM"	3138

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

-- SELECT drug_name, total_claim_count,
-- 	CASE 
-- 		WHEN opioid_drug_flag LIKE '%Y%' THEN 'opioid'
-- 		ELSE 'not opioid'
-- 	END AS drug_type
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- 	WHERE total_claim_count >= 3000;

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- SELECT drug_name, total_claim_count, CONCAT(nppes_provider_last_org_name, ' ', nppes_provider_first_name) AS full_name,
-- 	CASE 
-- 		WHEN opioid_drug_flag LIKE '%Y%' THEN 'opioid'
-- 		ELSE 'not opioid'
-- 	END AS drug_type
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- INNER JOIN prescriber
-- USING(npi)
-- 	WHERE total_claim_count >= 3000;

--can combine 2 columns in the same table using CONCAT , then renaming it though the AS function.

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

-- SELECT  prescriber.npi, drug.drug_name
-- FROM prescriber
-- CROSS JOIN drug
-- 	WHERE specialty_description = 'Pain Management'
-- 	AND nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y';

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

-- SELECT  prescriber.npi, drug.drug_name, total_claim_count
-- FROM prescriber
-- CROSS JOIN drug
-- 	LEFT JOIN prescription    -- WHY DOES LEFT JOIN WORK AND NOTHING ELSE?
-- ON prescriber.npi = prescription.npi AND 
-- 	prescription.drug_name = drug.drug_name
-- 	WHERE specialty_description = 'Pain Management'
-- 	AND nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y';
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.

-- SELECT  prescriber.npi, drug.drug_name, COALESCE(total_claim_count,0)
-- FROM prescriber
-- CROSS JOIN drug
-- 	LEFT JOIN prescription    -- WHY DOES LEFT JOIN WORK AND NOTHING ELSE?
-- ON prescriber.npi = prescription.npi AND 
-- 	prescription.drug_name = drug.drug_name
-- 	WHERE specialty_description = 'Pain Management'
-- 	AND nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y';


--COALESCE(total_claim_count,0) will change all null values to 0 or whatever number is specified.




-- Is there an association between rates of opioid prescriptions and overdose deaths by county?

	
-- SELECT 
-- 	county
-- --	SUM(overdose_deaths) AS Overdose_count
-- FROM overdose_deaths as o
-- LEFT JOIN fips_county as f
-- 	ON o.fipscounty = CAST(f.fipscounty AS INT)
-- GROUP BY county


	
WITH opiods AS
(
SELECT drug_name
FROM drug
	WHERE opioid_drug_flag = 'Y'
)

SELECT 
	DISTINCT(f.county),
	count(p.npi)
FROM opiods as o
LEFT JOIN prescription as pn
	On pn.drug_name = o.drug_name
LEFT JOIN prescriber as p
	ON p.npi = pn.npi
LEFT JOIN zip_fips as z
	ON z.zip = p.nppes_provider_zip5
LEFT JOIN fips_county as f
	ON f.fipscounty = z.fipscounty
	WHERE f.county is not NULL
	AND state = 'TN'
GROUP by f.county

--	Except

SELECT 
	county,
	SUM(overdose_deaths) AS Overdose_count
FROM overdose_deaths as o
LEFT JOIN fips_county as f
	ON o.fipscounty = CAST(f.fipscounty AS INT)
	WHERE state = 'TN'
GROUP BY county

-- "TRAVIS" 2
-- "BROOKS" 1


SELECT *
FROM fips_county
WHERE county = 'TRAVIS'