### Project Intro: SQL Query Practice

In this task, we're enhancing our SQL skills. We'll set up a PostgreSQL instance using Docker and use a SQL IDE like pgAdmin  to execute and manage queries. The goal is to practice data retrieval and manipulation, document solutions in README.md and queries.sql, and ensure everything is formatted and committed to GitHub. This approach helps us become more proficient in SQL, ensuring we can confidently handle various querying tasks.


##### Table Setup (DDL)
```sql

CREATE SCHEMA cd;

CREATE TABLE cd.members (
    memid SERIAL PRIMARY KEY,
    surname VARCHAR(200),
    firstname VARCHAR(200),
    address VARCHAR(300),
    zipcode INTEGER,
    telephone VARCHAR(20),
    recommendedby INTEGER,
    joindate TIMESTAMP
);

CREATE TABLE cd.facilities (
    facid SERIAL PRIMARY KEY,
    name VARCHAR(100),
    membercost NUMERIC,
    guestcost NUMERIC,
    initialoutlay NUMERIC,
    monthlymaintenance NUMERIC
);

CREATE TABLE cd.bookings (
    bookid SERIAL PRIMARY KEY,
    facid INTEGER REFERENCES cd.facilities(facid),
    memid INTEGER REFERENCES cd.members(memid),
    starttime TIMESTAMP,
    slots INTEGER
);

```



###### Query Practice Questions

## Question 1: Insert data into table
```sql


INSERT INTO cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
VALUES 
  (9, 'Spa', 20, 30, 100000, 800);

```





## Question 2: Insert multiple rows of data into a table
``` sql


INSERT INTO cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
VALUES 
  (9, 'Spa', 20, 30, 100000, 800), 
  (
    10, 'Squash Court 2', 3.5, 17.5, 5000, 
    80
  );

```




## Question 3: Insert calculated data into a table
```sql

    
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT max(facid) + 1, 'Spa', 20, 30, 100000, 800
FROM cd.facilities;

```






## Question 4: Update some existing data
``` sql

 
UPDATE 
  cd.facilities 
SET 
  initialoutlay = 10000 
WHERE 
  name = 'Tennis Court 2';

```





## Question 5: Update multiple rows and columns at the same time
```sql


	UPDATE cd.facilities
		SET membercost = 6, guestcost = 30
			WHERE name IN ('Tennis Court 1', 'Tennis Court 2');

```




    
## Question 6: Update a row based on the contents of another row
``` sql

 
UPDATE 
  cd.facilities facs 
SET 
  membercost = (
    SELECT 
      membercost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      facid = 0
  ), 
  guestcost = (
    SELECT 
      guestcost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      facid = 0
  ) 
WHERE 
  facs.facid = 1;

```





## Question 7: Delete all bookings
```sql

    
	DELETE FROM cd.bookings;

```





## Question 8: Delete a specific member
``` sql

 
DELETE FROM 
  cd.members 
WHERE 
  memid = 37;

```





## Question 9: Delete based on a subquery  
```sql


DELETE FROM cd.members WHERE memid NOT IN (SELECT memid FROM cd.bookings);          


```



    
## Question 10: Count the number of facilities
``` sql

 
SELECT 
  COUNT(*) 
FROM 
  cd.facilities;

```





## Question 11: Count the number of expensive facilities
```sql


SELECT COUNT(*) FROM cd.facilities WHERE guestcost >= 10;          

```



    

## Question 12: Retrieve everything from a table
``` sql

 
SELECT 
  * 
FROM 
  cd.facilities;

```





## Question 13: Retrieve specific columns from a table
```sql


SELECT name, membercost FROM cd.facilities;

```



    

## Question 14: Control which rows are retrieved
``` sql

 
SELECT 
  * 
FROM 
  cd.facilities 
WHERE 
  membercost > 0;

```





## Question 15: Control which rows are retrieved pt 2
```sql
   
 
SELECT facid, name, membercost, monthlymaintenance 
 	 FROM
		 cd.facilities 
	  WHERE
 	         membercost > 0 and 
   	        (membercost < monthlymaintenance/50.0);     

```





## Question 16: Basic string searches
``` sql


SELECT 
  * 
	FROM 
  		cd.facilities 
	WHERE 
 	        name LIKE '%Tennis%';

```




## Question 17: Matching against multipl possible values
```sql

    
SELECT
  *
	FROM
		 cd.facilities
	WHERE
		facid in (1,5);

```



## Question 18: Classify results into buckets
```sql


SELECT name, 
  case when (monthlymaintenance > 100) then 
	'expensive' 
  else 
	'cheap' 
  end as cost 
FROM
  cd.facilities;

```



    

## Question 19: Working with dates
```sql


SELECT
    memid,
    surname,
    firstname,
    joindate
FROM
    cd.members
WHERE
    joindate > '2012.09.01';    

```




## Question 20: Count the number of recommendations each member makes
```sql
   
SELECT
  surname 
FROM
  cd.members 
UNION 
SELECT 
  name 
FROM
  cd.facilities;

 
```



## Question 21: List the total slots booked per facility
```sql

SELECT 
  facid, 
  sum(slots) as "Total Slots" 
FROM
  cd.bookings 
GROUP BY 
  facid 
ORDER BY 
  facid;

```


    
## Question 22: List the total slots booked per facility in a given month
```sql

SELECT
  facid, 
  sum(slots) as "Total Slots" 
FROM
  cd.bookings 
WHERE
  starttime >= '2012-09-01' 
  and starttime < '2012-10-01' 
GROUP BY 
  facid 
ORDER BY
  sum(slots);

```

    

## Question 23: List the total slots booked per facility per month
```sql

SELECT facid, extract(month FROM starttime) AS month, sum(slots) AS "Total Slots"
	FROM cd.bookings
	WHERE extract(year FROM starttime) = 2012
	GROUP BY facid, month
			ORDER BY facid, month;
    
```



## Question 24: Find the count of members who have made at least one booking
```sql

    
SELECT COUNT(distinct memid) FROM cd.bookings          

```



## Question 25: List each member's first booking after September 1st 2012
```sql

SELECT
  mems.surname, 
  mems.firstname, 
  mems.memid, 
  min(bks.starttime) AS starttime 
FROM 
  cd.bookings bks 
INNER JOIN cd.members mems ON mems.memid = bks.memid 
WHERE
  starttime >= '2012-09-01' 
GROUP BY 
  mems.surname, 
  mems.firstname, 
  mems.memid 
ORDER BY
  mems.memid;


```



## Question 26: Produce a list of member names, with each row containing the total member count
```sql

SELECT
COUNT(*) over(), 
  firstname, 
  surname 
FROM
  cd.members 
ORDER BY
  joindate


```



## Question 27: Produce a numbered list of members
```sql

SELECT
  row_number() over(ORDER BY joindate), 
  firstname, 
  surname 
FROM 
  cd.members 
ORDER BY 
  joindate


```



## Question 28: Output the facility id that has the highest number of slots booked, again
```sql

SELECT facid, total FROM (
SELECT facid, sum(slots) total, rank() over (ORDER BY sum(slots) desc) rank 
FROM 
   cd.bookings 
GROUP BY
   facid
 ) as ranked 
WHERE
  rank = 1

```



## Question 29: Format the names of members
```sql

SELECT
  surname || ', ' || firstname AS name 
FROM
  cd.members


```




## Question 30: Find telephone numbers with parentheses
```sql

SELECT
  memid, 
  telephone 
FROM
  cd.members 
WHERE 
  telephone ~ '[()]';


```



## Question 31: Count the number of members whose surname starts with each letter of the alphabet
```sql

SELECT substr (mems.surname, 1, 1) AS letter, 
COUNT(*) AS COUNT 
FROM
  cd.members mems 
GROUP BY
  letter 
ORDER BY
  letter

```


