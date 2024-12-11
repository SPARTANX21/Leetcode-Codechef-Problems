-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 																		Hospital Database
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Easy Level 
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Show the patient id and the total number of admissions for patient_id 579.
SELECT patient_id, COUNT(*) as admission 
FROM admissions
WHERE patient_id = 579;

-- Show first name, last name, and gender of patients whose gender is 'M
SELECT  first_name, last_name, gender
FROM patients
WHERE gender = 'M';

-- Show first name and last name of patients who does not have allergies. (null)
SELECT  first_name, last_name
FROM patients
WHERE allergies IS NULL;

-- Show first name of patients that start with the letter 'C'
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;

-- Show first name and last name concatinated into one column to show their full name.
SELECT CONCAT(first_name, ' ', last_name) as Full_name
FROM patients;

-- Show first name, last name, and the full province name of each patient.
-- Example: 'Ontario' instead of 'ON
SELECT first_name, last_name, p.province_name
FROM patients
INNER JOIN province_names p USING(province_id);

-- Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT(*) AS Total
FROM patients
WHERE YEAR(birth_date) IS '2010';

-- Show the first_name, last_name, and height of the patient with the greatest height.
SELECT first_name, last_name, height
FROM patients 
order by height DESC
LIMIT 1;

-- Show all columns for patients who have one of the following patient_ids:
-- 1,45,534,879,1000
select * 
FROM patients 
WHERE patient_id IN (1,45,534,879,1000);

-- Show the total number of admissions
SELECT COUNT(patient_id) as Admissions
FROM admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT * 
FROM admissions
WHERE admission_date = discharge_date;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct city 
FROM patients
where province_id = 'NS';

-- Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
SELECT first_name, last_name, birth_date
FROM patients 
WHERE height > 160 AND weight > 70 ;

-- Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'
SELECT first_name, last_name, allergies
FROM patients 
WHERE allergies NOT NULL AND city = 'Hamilton';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Medium Level 
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Show unique birth years from patients and order them by ascending.
select distinct year(birth_date) as BirthYear from patients 
order by BirthYear asc;

-- Show unique first names from the patients table which only occurs once in the list.
-- For example, if two or more people are named 'John' in the first_name column then don't 
-- include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
WITH unique_names_cte AS (
    SELECT 
        first_name, 
        COUNT(*) OVER (PARTITION BY first_name) AS count_of_names
    FROM 
        patients
)
SELECT DISTINCT first_name
FROM unique_names_cte
WHERE count_of_names = 1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%' 
  AND first_name LIKE '%s'
  AND LENGTH(first_name) >= 6;
  
-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.
select p.patient_id, p.first_name, p.last_name from patients p 
inner join admissions a using(patient_id)
where a.diagnosis = 'Dementia';

-- Display every patient's first_name.Order the list by the length of each name and then by alphabetically.
with ordercte as ( 
select first_name, length(first_name) as lengthfirst from patients )
select first_name from ordercte
order by lengthfirst, first_name;

-- Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select distinct (select count(first_name) as male_patients from patients 
where gender = 'M') , (select count(first_name) as female_patients from patients 
where gender = 'F') from patients;

-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
SELECT first_name, last_name, allergies
from patients 
where allergies in ('Penicillin', 'Morphine')
order by allergies asc, first_name, last_name;

-- Show all allergies ordered by popularity. Remove NULL values from query.
select distinct allergies, count(*) 
from patients 
where allergies is not null
group by allergies
order by count(*) desc;

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name, last_name, birth_date
from patients
where year(birth_date) between 1970 and 1979 
order by birth_date asc;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id, sum(height) as sumheight
from patients
group by province_id
having sum(height) >= 7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select (max(weight) - min(weight)) as diffinweight 
from patients
where last_name like 'Maroni';

-- Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.
select d.first_name, d.last_name, count(a.admission_date) as admissionstot
from doctors d 
inner join admissions a on a.attending_doctor_id=d.doctor_id
group by d.first_name, d.last_name;

-- For each doctor, display their id, full name, and the first and last admission date they attended.
select d.doctor_id, concat(d.first_name, " ", d.last_name) as fullname, min(a.admission_date) as first_date, 
max(a.admission_date) as last_date
from doctors d inner join admissions a on a.attending_doctor_id=d.doctor_id
group by d.doctor_id;

-- Display the total amount of patients for each province. Order by descending.
select count(distinct p.patient_id) as Patients_count, pr.province_name
from patients p inner join province_names pr using(province_id)
group by pr.province_name 
order by Patients_count desc;

-- display the first name, last name and number of duplicate patients based on their first name and last name.
-- Ex: A patient with an identical name can be considered a duplicate.
select first_name, last_name, count(*) as duplicate
from patients
group by first_name, last_name
having count(*) > 1;


-- Display patient's full name,
-- height in the units feet rounded to 1 decimal,
-- weight in the unit pounds rounded to 0 decimals,
-- birth_date,
-- gender non abbreviated.

-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.
select  concat(first_name, " ", last_name) as Full_name, round((height / 30.48),1) as height_feet,
round((weight*2.205),0) as Weight_kgs, birth_date,
case
	when gender = 'M' then 'Male'
    WHen gender = 'F' Then 'Female'
    end as Gender
from patients;

-- For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
select concat(p.first_name, " ",p.last_name) as Full_name, a.diagnosis,
concat(d.first_name, " ", d.last_name) as Full_name_Doctor  
from patients p 
inner join admissions a using(patient_id)
inner join doctors d on a.attending_doctor_id = d.doctor_id;

-- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
-- (Their patient_id does not exist in any admissions.patient_id rows.)-
select p.patient_id, p.first_name, p.last_name
from patients p 
where p.patient_id not in (select distinct a.patient_id from admissions a);

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
select distinct patient_id, attending_doctor_id, diagnosis
from admissions
where ((patient_id %2 !=0) and (attending_doctor_id IN (1,5,19))) 
			or 	((attending_doctor_id like '%2%') and (length(patient_id)=3));

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
-- EX: SMITH,jane 
select concat(upper(last_name), ",",lower(first_name)) as Full_name
from patients
order by first_name desc;

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date) as day_number, count(*) as number_of_admission
from admissions
group by day_number
order by number_of_admission desc;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Hard Level 
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Show patient_id, weight, height, isObese from the patients table Display isObese as a boolean 0 or 1 Obese is defined as weight(kg)/(height(m)2) >= 30.
-- weight is in units kg. height is in units cm.
SELECT patient_id, weight, height, 
CASE 
	WHEN (weight/power(height/100.0, 2)) >= 30 THEN 1
    ELSE 0
END AS isobese
FROM patients;

-- Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

select p.patient_id, p.first_name, p.last_name, d.specialty
from patients p 
inner join admissions a using(patient_id)
inner join doctors d on a.attending_doctor_id = d.doctor_id
where a.diagnosis = 'Epilepsy' and d.first_name='Lisa';

-- We need a breakdown for the total amount of admissions each doctor has started each year. 
-- Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.

select distinct d.doctor_id, concat(d.first_name, " ", d.last_name) as FullName, d.specialty, 
year(a.admission_date),count(a.admission_date)
from admissions a 
right  join doctors d on a.attending_doctor_id = d.doctor_id
group by FullName, year(a.admission_date)
order by d.doctor_id, year(a.admission_date);

-- For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
SELECT
 admission_date,
 count(admission_date) as admission_day,
 count(admission_date) - LAG(count(admission_date)) OVER(ORDER BY admission_date) AS admission_count_change 
FROM admissions
 group by admission_date;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 																		Northwind Database
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Easy Level 
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table
select p.product_name, s.company_name, c.category_name 
from products p 
inner join categories c using(category_id)
inner join suppliers s using(supplier_id);


-- Show the category_name and the average product unit price for each category rounded to 2 decimal places.
select c.category_name, round(avg(p.unit_price),2) 
from products p 
inner join categories c using(category_id)
group by c.category_name;





