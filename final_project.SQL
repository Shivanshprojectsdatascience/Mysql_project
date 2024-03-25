-- FIRST OF ALL LET US CREATE DATABASE
CREATE DATABASE BANK_DATA;

-- USE BANK_DATA SCHEMA FFOR FURTHER PROCESS
USE BANK_DATA;

-- LET US SEE ALL THE RECORDS FOR GIVEN CUSTOMER DATA
SELECT * FROM customer_bank;
SELECT * FROM churn;

-- CUSTOMER WHOSE BALANCE IS EQUAL TO ZERO
SELECT SURNAME FROM churn
WHERE BALANCE = 0;
SELECT CUSTOMER_ID FROM customer_bank
WHERE BALANCE = 0;

-- BOTTOM 5 CUSTOMER_ID HAVING CREDIT CARD = 1 AND CREDIT CARD SCORE LESS THAN 600 THEIR COUNTRY NAME
SELECT customer_id , country FROM customer_bank
WHERE credit_card = 1 AND credit_score > 600;


-- CUSTOMER HAVING ESTIMATED SALARY LESS THAN 8000
SELECT CUSTOMERID FROM churn
WHERE ESTIMATEDSALARY < 8000;


-- CUSTOMER HAVING AVERAGE TENURE FOR BANK WITH THEIR CUSTOMER_ID 
SELECT CUSTOMERID , AVG(TENURE) AS AVERAGE_TENURE
FROM churn
GROUP BY CUSTOMERID;



-- CHECK WHICH COUNTRY HAS GIVEN MAXIMUM , MINIMUM  BALANCE BY  CUSTOMER
SELECT Geography , Gender  , MAX(Balance) AS MAXIMUM_BALANCE 
FROM churn
GROUP BY Geography , Gender;
-- SINCE SPAIN HAS THE HIGHEST BALANCE WHICH IS PAID BY CUSTOMER SO FRANCE , GERMANY HAVE TO INCREASE THEIR BUISNESS FOR MORE PRODUCTIVITY



SELECT Geography , Gender  , MIN(Balance) AS MINMUM_BALANCE 
FROM churn
GROUP BY Geography , Gender;
-- GERMANY HAS THE LOWEST BALANCE GIVEN BY CUSTOMER



-- AVERAGE CREDIT SCORE GIVEN BY TOP 5 CUSTOMER 
SELECT AVG(credit_score) , MAX(TENURE)  , country FROM customer_bank
WHERE country IN ('FRANCE','SPAIN','GERMANY')
GROUP BY country
LIMIT 5;



-- average loan tenure for each country 
SELECT COUNTRY , AVG(tenure) AS AVERAGE_TENURE
FROM customer_bank
GROUP BY COUNTRY;


--  check which proportion of gender have less tenure with age 40 + and their country name
SELECT country , gender  ,age  , AVG(tenure) FROM customer_bank
GROUP BY country , gender ,  age 
where age> 40;



-- SHOW THE DATA OF  TOTAL NUMBER OF PRODUCTS , MAXIMUM AND MINIMUM FOR CUSTOMER 
SELECT COUNT(NumOfProducts) , MAX(NumOfProducts) , MIN(NumOfProducts) FROM churn;



-- SHOW THE CUSTOMER DATA STARTING NAME WITH S WITH THEIR CUSTOMERID , BALANCE , GENDER , AGE , COUNTRY 
SELECT CustomerId ,  Surname, Balance , Age , Gender , Geography  FROM churn
WHERE Surname LIKE 'S%';



-- check the pattern with surname with credit score GREATER tHAn 600
SELECT Surname  FROM churn
WHERE Surname LIKE 'B%' AND CreditScore > 600;



-- SHOW ANY COMMON CUSTOMER DATA WITH ID , CREDIT SCORE , CREDIT CARD O=WITH BOTH TABLES
CREATE VIEW VIEW_6 AS
SELECT customer_id , credit_score , credit_card FROM customer_bank
INNER JOIN churn
ON customer_bank.credit_card = churn.HasCrCard;



-- USING SELECT STATEMENT FOR SEEING ALL DATA CREATED IN VIEW
SELECT * FROM VIEW_6;



-- ADD COLUMN REGION IN customer_bank
ALTER TABLE customer_bank
ADD COLUMN REGION VARCHAR(30);
DESC customer_bank;

-- INSERT SOME VALUES IN REGION TABLE
INSERT INTO customer_bank (REGION) 
VALUES ('EAST'),
('WEST'),
('NORTH'),
('SOUTH');


-- WHICH CUSTOMER_ID HAVE THE ESTIMATED SALARY LESS MAXIMUM OF BALANCE FOR CUSTOMER 
SELECT CustomerId  , Surname , Geography FROM churn
WHERE BALANCE < ( SELECT MAX(BALANCE) FROM churn);
-- HERE ARE THE ALL CUSTOMER WHOSE ESTIMATED SALARY IS LESS THAN THE MAXIMUM OF BALANCE OF CUSTOMER
-- MAXIMUM FRANCE CUSTOMER HAVE THE LOWEST SALARY THAN THE MAXIMUM BALANCE STORED BY CUSTOMER


-- credit score less than 600 loan not applicable greater than 600 loan applicable a with total range of 900 
SELECT * ,
(CASE 
WHEN credit_score BETWEEN 100 AND 500 THEN 'LOW CHANCE'
WHEN credit_score BETWEEN 500 AND 600 THEN 'MEDIUM CHANCE'
WHEN credit_score BETWEEN 600 AND 900 THEN 'HIGH CHANCE'
ELSE 'NOTHING'
END) AS REVIEW
FROM customer_bank;

-- age 35+ , credit score (600-900) , estimated salary check whether the customer is applicable for loan or not
SELECT * ,
(CASE 
WHEN AGE > 35 THEN 'LOAN IS NOT APPLICABLE'
WHEN AGE < 35 THEN 'LOAN IS APPLICABLE'
END) AS INFORMATION
FROM customer_bank ;


-- check the tenure for 40 + years age and give the confirmation to bank that he is applicable for loan
SELECT tenure ,
(CASE
WHEN AGE > 40 THEN ' NOT APPLICABLE FOR LOAN'
WHEN AGE < 40 THEN 'APPLICABLE FOR LOAN'
END) AS TENURE_WISE_LOAN_APPROVE
FROM customer_bank;

-- check which customer have age 45 + but till now they are paying loan to bank display mesaage to the client 
SELECT customer_id , active_member ,
(CASE
WHEN age > 45 THEN ' THESE CUSTOMER ARE PAYING LOAN TILL NOW'
END)
FROM customer_bank;

-- check the second highest credit score given by which customer which contains full information regarding to the customer
SELECT * FROM customer_bank
 where credit_score < ( select max(credit_score) from customer_bank);

-- CHECK IF THE MAX DIFFERNCE IS GREATER THAN 700 THAN CHECK WHETHER THE CUSTOMER HAS THE POSSIBILITY FOR PAYING THE TENURE
DELIMITER //
CREATE PROCEDURE CUSTOMER_DATA()
BEGIN
SELECT customer_id , gender , age ,
(CASE 
	WHEN DIFFERNCE > 700 THEN 'CUSTOMER HAVE HIGH POSSIBILITY TO PAY TENURE AT LESS TIME'
    WHEN DIFFERNCE < 700 THEN 'CUSTOMER HAVE LOW POSSIBILITY TO PAY TENURE AT LESS TIME'
 END) AS CUSTOMER_INFO
 FROM customer_bank;
 END;
DELIMITER ;
CALL CUSTOMER_DATA();

-- the maximum tenure to bank and show the message if max tenure is less than 10 than they are in good progress
create procedure message()
begin
select CustomerId , Surname , CreditScore ,
(case
	when Tenure = 10 then ' customer is in stable for loan payable'
    when Tenure < 10 then 'customer is in normal position for loan payable'
    when Tenure < 5 then 'customer is in good progress for loan payment'
 end) as customer_data
 from churn;
 end //
 delimiter //
 call  message();
 
 -- SHOW THE DATA OF ANY CUSTOMER_ID 
 delimiter //
 create procedure input(in C_Id int)
 begin
	select * from churn
    where CustomerId in (C_Id );
  end  //
  delimiter ;
  call input(15634602);
  
  desc churn;
  
  -- SHOW THE DATA OF  ANY CUSTOMER WITH ID , GEOGRAPHY , GENDER , AGE 
  delimiter //
  create procedure input_ouput(in C_Id int , out C_Geography varchar(20), out C_Gender varchar(30), out C_Age int)
  begin
	select Geography , Gender , Age into C_Geography , C_Gender , C_Age from churn
    where CustomerId in(C_Id);
 end //
 delimiter ;
 call input_ouput(15634602,@C_Geography,@C_Gender,@C_Age);
SELECT @C_Geography,@C_Gender,@C_Age;

-- delete all the record have null values 
 delete from customer_bank 
 where customer_id is null;
 
 -- check which customer have given the maximum balance to bank for each country and each customer within that country 
 select customer_id , age  , country , 
 max(balance) over ( partition by country order by estimated_salary desc) as max_balance
 from customer_bank ;
 
 --  check which customer of which country have given maximum distribution towards balance towards bank
 select customer_id , age , country , tenure , credit_card , active_member , 
 cume_dist()  over (partition by country order by estimated_salary desc) as percent_distribution
 from customer_bank;
 
 -- check which customer have same credit score and accordingly show whether they are from frane , spain , germany and show the combinations
 select customer_id , age , country , tenure , credit_card , active_member , 
 dense_rank() over (partition by country order by tenure) as same_tenure
 from customer_bank;
 
 
 
