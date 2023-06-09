-- 1. Select all legal_entity data along with net worths

select * from employers where net_worth is not null;

-- 2. Select all employees (names) that are legal entities

SELECT 
    employer_name
FROM
    employers;

-- 3. Select all employee contacts and employment descriptions
--    for those who are attending the training in Belit in 2022.
--    You can find out who is on the training by searching in employment description
--    If someone doesn't have contact, write his id with " - TODO" suffix
select
employees.first_name
where employees.employee_id in
(select contacts.email
from contacts
where contacts.employee_id = employees.employee_id) ,
(select contacts.phone
from contacts
where contacts.employee_id = employees.employee_id)

from employees;







select
employees.first_name,
(select contacts.email,contacts.phone,
case
when contacts.email is not null or contacts.phone is not null then 'Contact exists' 
else 
  concat(employees.employee_id,' -TODO')
end
from contacts
inner join employees
on contacts.employee_id = employees.employee_id)
,employment.description_job
from employment 
inner join employees
on employment.employee_id = employees.employee_id
where description_job like '%training%';

select employees.first_name, contacts.email,contacts.phone,
case
when contacts.email is not null or contacts.phone is not null then 'Contact exists' 
else 
  concat(employees.employee_id,' -TODO')
end
from contacts
right join employees
on contacts.employee_id = employees.employee_id;



-- 4. Select all employers (names) that do not have any active employees

select employers.employer_name 
from employment
inner join employers
on employment.employer_id = employers.employer_id
where date_of is not null;



-- 5. Select all employers (names) and number of their active employees
--    Order rows by that number (of active employees) in descending order

select employers.employer_name,count(employee_id) as active_employees
from employment
inner join employers
on employment.employer_id = employers.employer_id
where date_of is  null
order by active_employees desc;


-- 6. Select subject id, type of the subject and all its contacts:
--    - aggregated into single varchar value with ", " between contacts
--    - aggregated into array of values
--    Result should have a single row per subject
--    Order rows by subject id in ascending order
 


-- 7. Select employment data: employer, employee, description, date from and date to
--    For legal entities show name, for natural persons the full name
--    Full name should be displayed in format: first_name <middle_name> last name
--    If the middle name is null, it should be displayed as </>
--    Format dates like: 01. 01. 2014.
--    Sort rows by the employment id, in ascending order
--    Save this query as employment_report view


create view employment_report as
select 
 concat(first_name, ' <',middle_name,'> ' ,last_name) as full_name, employers.employer_name,
 date_format(date_on, '%m.%d.%Y') as start_job,
 date_format(date_of, '%m.%d.%Y') as finish_job,
 employment.description_job
 from employment
 inner join employees
on employment.employee_id = employees.employee_id
inner join  employers
on employment.employer_id = employers.employer_id
order by employment_id asc ;

select * from employment_report;


-- 8. Select rows from employment_report that have both date to and description and are valid from 2016

select date_on,description_job  from employment where date_on > '2016-09-07' and date_of is  null;