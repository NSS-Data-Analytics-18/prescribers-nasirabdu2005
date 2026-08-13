SELECT DISTINCT(nppes_provider_first_name) AS first_name, total_claim_count AS total_claims
FROM prescriber 
	INNER JOIN prescription ON prescriber.npi = prescription.
ORDER BY total_claims DESC; 
-- Q1(Part. 1) 

SELECT DISTINCT(nppes_provider_first_name) AS first_name, nppes_provider_last_org_name AS last_, specialty_description, total_claim_count AS total_claims
FROM prescriber 
	INNER JOIN prescription ON prescriber.npi = prescription.npi
ORDER BY total_claims DESC;
--Q1(Part. 2)

SELECT specialty_description, prescription.total_claim_count AS total_claims
FROM prescriber 
	INNER JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY specialty_description, total_claims
ORDER BY total_claims DESC;
--Q2(Part. 1)

SELECT opioid_drug_flag AS opioid_use, total_claim_count AS total_claim, specialty_description 
FROM prescriber
	INNER JOIN prescription ON prescriber.npi = prescription.npi
	INNER JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY specialty_description, opioid_use, total_claim
ORDER BY total_claim DESC;
--Q2(Part. 2)

SELECT generic_name AS drug_name, total_drug_cost AS drug_cost 
FROM prescriber
	INNER JOIN prescription ON prescriber.npi = prescription.npi
	INNER JOIN drug ON prescription.drug_name = drug.drug_name
ORDER BY drug_cost DESC;
--Q3(Part. 1)

SELECT drug.generic_name, ROUND(SUM(prescription.total_drug_cost) / SUM(prescription.total_day_supply), 2) AS cost_per_day
FROM prescription 
	INNER JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY drug.generic_name
ORDER BY cost_per_day DESC;
--Q3(Part. 2)

SELECT drug_name, opioid_drug_flag,  
CASE 
	WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	ELSE 'neither'
END AS drug_type 
FROM drug
WHERE opioid_drug_flag = 'Y';
--Q4(Part. 1)

SELECT 
    CASE 
        WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
    END AS drug_type,
    SUM(prescription.total_drug_cost) AS total_cost
FROM drug
INNER JOIN prescription
    ON drug.drug_name = prescription.drug_name
WHERE drug.opioid_drug_flag = 'Y' OR drug.antibiotic_drug_flag = 'Y'
GROUP BY drug_type
ORDER BY total_cost DESC;
--Q4(Part. 2)

SELECT COUNT(DISTINCT cbsa) AS cbsa_count_tn
FROM cbsa
INNER JOIN fips_county 
    ON cbsa.fipscounty = fips_county.fipscounty
WHERE fips_county.state = 'TN';
--Q5(Part. 1)

SELECT 
    cbsa.cbsaname,
    SUM(population.population) AS total_population
FROM cbsa
INNER JOIN population  
    ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsaname
ORDER BY total_population DESC
LIMIT 1;
--Q5(Part. 2)

SELECT 
    cbsa.cbsaname,
    SUM(population.population) AS total_population
FROM cbsa 
INNER JOIN population  
    ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsaname
ORDER BY total_population ASC
LIMIT 1;
--Q5(Part. 2b)

SELECT 
    fips_county.county,
    population.population
FROM fips_county
INNER JOIN population 
    ON fips_county.fipscounty = population.fipscounty
LEFT JOIN cbsa 
    ON fips_county.fipscounty = cbsa.fipscounty
WHERE cbsa.cbsa IS NULL
ORDER BY population.population DESC
LIMIT 1;
--Q5(Part. 3)

SELECT 
    drug_name,
    total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;
--Q6(Part. 1)

SELECT 
    prescription.drug_name,
    prescription.total_claim_count,
    drug.opioid_drug_flag
FROM prescription
INNER JOIN drug 
    ON prescription.drug_name = drug.drug_name
WHERE prescription.total_claim_count >= 3000;
--Q6(Part. 2)

SELECT 
    prescription.drug_name,
    prescription.total_claim_count,
    drug.opioid_drug_flag,
    prescriber.nppes_provider_first_name,
    prescriber.nppes_provider_last_org_name
FROM prescription
INNER JOIN drug 
    ON prescription.drug_name = drug.drug_name
INNER JOIN prescriber 
    ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count >= 3000;
--Q6(Part. 3)

SELECT 
    prescriber.npi,
    drug.drug_name
FROM prescriber
CROSS JOIN drug
WHERE prescriber.specialty_description = 'Pain Management'
  AND prescriber.nppes_provider_city = 'NASHVILLE'
  AND drug.opioid_drug_flag = 'Y';
--Q7(Part. 1)

SELECT 
    prescriber.npi,
    drug.drug_name,
    prescription.total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription 
    ON prescriber.npi = prescription.npi 
   AND drug.drug_name = prescription.drug_name
WHERE prescriber.specialty_description = 'Pain Management'
  AND prescriber.nppes_provider_city = 'NASHVILLE'
  AND drug.opioid_drug_flag = 'Y';
--Q7(Part. 2)

SELECT 
    prescriber.npi,
    drug.drug_name,
    COALESCE(prescription.total_claim_count, 0) AS total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription 
    ON prescriber.npi = prescription.npi 
   AND drug.drug_name = prescription.drug_name
WHERE prescriber.specialty_description = 'Pain Management'
  AND prescriber.nppes_provider_city = 'NASHVILLE'
  AND drug.opioid_drug_flag = 'Y';
--Q7(Part. 3)
