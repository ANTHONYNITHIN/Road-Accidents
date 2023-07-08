/*
Questions that are being answered in the query
sum of casualties
-- casuality based on whether they are severe,slight or Fatal
-- casualties by vehicle type
-- current year vs previous year casuality monthly wise
-- current year vs previous year casuality monthly wise
-- no of casuality by road type
-- Casualities by Light Conditions
-- Top 10 locations by no of casualities

*/
create database pp4;
use pp4;
-- import data as csv format
show tables;
select * from a;
select count(*) from a;
select * from b;
select count(*) from b;
--        
-- sum of casualties
select * from a;
select sum(Number_of_Casualties) from a;
select year( `Accident Date`) from a;
describe a;

-- Update the existing data to the correct date format
UPDATE a SET `Accident Date` = STR_TO_DATE(`Accident Date`, '%d-%m-%Y');

-- Alter the table to modify the column data type
ALTER TABLE a MODIFY `Accident Date` DATE;

select sum(Number_of_Casualties) from a where year(`Accident Date`) = 2021 
and
 Road_Surface_Conditions = 'Dry'; -- filters
-- 195737
select sum(Number_of_Casualties) from a where `Accident_Severity` = 'Fatal';
select sum(Number_of_Casualties) from a where `Accident_Severity` = 'Serious';
select sum(Number_of_Casualties) from a where `Accident_Severity` = 'Slight'; -- 351436

SELECT CAST(SUM(Number_of_Casualties) AS decimal(10,2)) * 100 / CAST((SELECT SUM(Number_of_Casualties) FROM a) AS decimal(10,2)) AS slight_percentage 
FROM a 
WHERE Accident_Severity = 'Slight';

select SUM(Number_of_Casualties)  FROM a;
-- select * from a;
SELECT CAST(SUM(Number_of_Casualties) AS decimal(10,2))  * 100 / CAST((SELECT SUM(Number_of_Casualties) FROM a) AS decimal(10,2)) AS slight_percentage 
FROM a 
WHERE Accident_Severity = 'Serious';

SELECT CAST(SUM(Number_of_Casualties) AS decimal(10,2))  * 100 / CAST((SELECT SUM(Number_of_Casualties) FROM a) AS decimal(10,2)) AS slight_percentage 
FROM a 
WHERE Accident_Severity = 'Fatal';

-- casualties by vehicle type
select Vehicle_Type,sum(Number_of_Casualties) from a group by Vehicle_Type;
-- select * from a;
select distinct(Vehicle_Type) from a;

select 
case 
    when Vehicle_Type in ('Car','Taxi/Private hire car') then 'car'
	when Vehicle_Type in ('Agricultural vehicle') then 'Agricultural'
	when Vehicle_Type in ('Motorcycle over 125cc and up to 500cc','Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 500cc')
		then 'MotorCycle'
	when Vehicle_Type in ('Van / Goods 3.5 tonnes mgw or under','Goods over 3.5t. and under 7.5t','Goods 7.5 tonnes mgw and over') then 'Goods'
	when Vehicle_Type in ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') then 'bus'
     else 'other' 
end as veh_type,sum(Number_of_Casualties) as `casuality number`
from a  /*where year(`Accident Date`) = 2021 or 2022 */
group by Veh_Type;

-- current year vs previous year casuality monthly wise
select * from a;
select sum(Number_of_Casualties) from a where year(`Accident Date`) = 2021 ;
select sum(Number_of_Casualties ) from a where year (`Accident Date`) = 2022;
select monthname(`Accident Date`) from a;

SELECT MONTHNAME(`Accident Date`) AS Month_Name, SUM(Number_of_Casualties) AS CV_Casualties
FROM a
WHERE YEAR(`Accident Date`) = 2021 

GROUP BY MONTHNAME(`Accident Date`);
SELECT MONTHNAME(`Accident Date`) AS Month_Name, SUM(Number_of_Casualties) AS CV_Casualties
FROM a
WHERE YEAR(`Accident Date`) = 2022
GROUP BY MONTHNAME(`Accident Date`);

-- no of casuality by road type
select Road_Type,sum(Number_of_Casualties) as casualities from a WHERE YEAR(`Accident Date`) = 2021  group by Road_Type;

-- casuality based based on urban or rural

SELECT urban_or_rural_area, SUM(number_of_casualties) AS Total_casualties, 
CAST(SUM(number_of_casualties) AS DECIMAL(18, 2))* 100 / 
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(18, 2)) FROM a)
AS PCT
FrOM a
/* WHERE YEAR (`Accident Date`) ='2021' or '2022'*/ GROUP BY urban_or_rural_area ;

-- Casualities by Light Conditions
select * from a;

SELECT
    CASE
        WHEN Light_Conditions = 'Daylight' THEN 'Day'
        WHEN Light_Conditions IN ('Darkness - lighting unknown', 'Darkness - lights unlit', 'Darkness - no lighting', 'Darkness - lights lit') THEN 'Night'
    END AS Light_Condition,
    CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100 /
    (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM a WHERE YEAR(`Accident Date`) = '2021') AS DECIMAL(10,2)) AS CY_Casualties_PCT
FROM a
WHERE YEAR(`Accident Date`) = '2021' /* or 2022 */
GROUP BY Light_Condition;

-- Top 10 locations by no of casualities
-- select `Local_Authority_(District)` from a;
select `Local_Authority_(District)`,
SUM(number_of_casualties) as t_c from a 
group by `Local_Authority_(District)` 
order by t_c 
limit 10 ;