/* Create an Entity Relationship Diagram (ERD) for a business information system.
 It should track subjects such as natural persons and legal entities.
 For natural persons it should collect their full names (first, last and middle),
 their personal id numbers and their sex. For legal entities their name, 
 registration number of the company (crn) and its tax identification number (tin).
 To make it easier to gradually add data,
 for natural persons only the first and last name is required and for legal entities only its name.
 Net worth of subjects is optional.
 Each subject may have multiple contacts, such as emails, phone numbers etc.
 Contacts with same value and type should be unique. 
 Lastly, the system should track employment - which subject works for which legal entity,
 when their relationship started and when it ended, with optional description. 
There must not be multiple rows for the same employer, employee and date when the employment started.
*/

create database er_diagram;
use er_diagram;

create table employees(
employee_id int primary key auto_increment,
first_name varchar(20) not null,
last_name varchar(20) not null,
middle_name varchar(20),
personal_id int,
sex varchar(20),
net_worth int
);

create table employers(
employer_id int primary key auto_increment,
employer_name varchar(20) not null,
crn int,
tin int,
net_worth int
);

create table contacts(
contact_id int primary key auto_increment,
email varchar(50) unique,
phone int unique,
employee_id int,
employer_id int
);

alter table contacts add 
foreign key(employee_id) references employees(employee_id);

alter table contacts add 
foreign key(employer_id) references employers(employer_id);

create table employment(
employment_id int primary key auto_increment,
date_on date,
date_of date,
description_job text,
employer_id int,
employee_id int
);

alter table employment add 
foreign key(employee_id) references employees(employee_id);

alter table employment add 
foreign key(employer_id) references employers(employer_id);


insert into  employees(first_name,last_name,middle_name,personal_id,sex,net_worth)
values('Pera','Peric','Perke',17,'M','/')
,('Mina','Minic','/',16,'F',65000),
('Dule','Dulic','Dusko',13,'M','43000'),
('Ena','Enic','/',23,'F','83000'),
('Denis','Denic','Deni',34,'M','/');

select * from employees;

insert into employers(employer_name,crn,tin,net_worth)
values('Microsoft',21312,6456,null)
,('NB',876989,89865,65775),
('DR_CODE',null,null,null),
('BG_CODERS',7657,789,6503467)
;

insert into employers(employer_name,crn,tin,net_worth)
values('Micro',2131241,456456,null);

select * from employers;

insert into contacts(email,phone,employee_id)
values('d@email.com',78768,5),
('deni@email.com',78068,5),
('duka@email.com',78668,3);

insert into contacts(email,phone,employer_id)
values('micro@gmail.com','6566565','12'),
('micro@yahoo.com','65565','12'),
('dr@gmail.com','65665','11'),
('coders@gmail.com','1166565','10');

select * from contacts;

select contacts.email,contacts.phone,
employees.first_name
from contacts
inner join employees
on contacts.employee_id = employees.employee_id;

select contacts.email,contacts.phone,
employers.employer_name
from contacts
inner join employers
on contacts.employer_id = employers.employer_id;

SET FOREIGN_KEY_CHECKS=0;

insert into employment(date_on,date_of,description_job,employer_id,employee_id)
values('2015-06-07',null,'java developer',12,1),
('2023-01-01','2023-04-05','training java developer',12,2),
('2012-06-07','2014-04-05','sql developer',10,1),
('2022-06-07',null,'training for laravel',10,3),
('2012-06-07','2022-04-05','php developer',9,4);



select employment.date_on, employment.date_of, employment.description_job ,
employees.first_name,employees.employee_id,employers.employer_id,
employees.sex,
employers.employer_name,
case 
 when employment.date_of is null then 'still work'
else 'end of work'
end as active_inactive
from employment
inner join employees
on employment.employee_id = employees.employee_id
inner join  employers
on employment.employer_id = employers.employer_id;



