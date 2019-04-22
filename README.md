
### Some SQL Queries used during internship are included in this repository. This internship is from Inke, a public company in China. Each folder represents a project( These analysis needs were from Product or Operations department)

### company introduction
Inke is the fastest-growing mobile app that provides millions of users with excellent live broadcasting service. 
Founded in March 2015, Inke has brought worldwide live-streaming service to its mobile app, 
with 130 millions of downloads and 15 millions of active users over Android and iOS platforms.

 * `Feed Project`
   * project introduction
     This folder shows the process of capturing data related to feed strategies which had been released for 2 weeks.
   * What I need to analyzed are the followings:
    1. Number of people who post feeds, Number of comments, and Number of likes per day
    2. Average number of posts per day for different publisher levels
    3. Average number of posts per day for different city levels
    4. The conversion of posting feeds next week from the publishers who posted feeds this week
    5. Publishers'Preferences for Publishing Contents in Different Cities
    
    The purpose is to analyze Whether the new online dynamic strategy can help users retain, 
    and whether it can quickly establish a further network between users. 

SQL 
===
### The most commonly used SQL statements.

#### Basically used SQL statements
* QUERYING DATA FROM A TABLE
  * This part involves `Select` `Where` `Group by` `Having` `Order by` `Limit` usages.
  * This usages help us filter the data
  * Their order should be like :
    >SELECT
    >>WHERE
    >>>GROUP BY 
    >>>> HAVING
    >>>>> ORDER BY

* QUERYING FROM MULTIPLE TABLES
  * This part involves `Join/Inner Join` `Left Join` `Right Join` `Full Outer Join` `Cross Join` usages
  * This usages help us link multiple tables

* USING SQL OPERATORS
  * This part involves `Union` `Except` `Intersect` `Minus` usages.
  * This usages help us filter or bind the information we want efficiently
  * Keep in mind that when use this command, the entities of these tables should be the same

* MANAGING TABLES
  * This part involves `Create Table` `Alter *table Drop` `Alter *table Add` `Alter *table Rename` usages
  * This usages help us manage the tables in the database. We can delete/add the entities or rename them

*  MODIFYING DATA
    * Insert multiple rows into a table
``` SQL
 INSERT INTO t(column_list) 
 VALUES (value_list),
(value_list), ....;
```
   * Insert rows from t2 into t1
``` SQL
 INSERT INTO t1(column_list) 
 SELECT column_list
FROM t2;
```
   * Delete subset of rows in a table
``` SQL
  DELETE FROM t
WHERE condition;
```
#### The best interview questions
Frequently asked SQL Interview Questions with detailed answers and examples.Here are many sample SQL Interview questions in a few PDF files and their answers are given just below to them. If you need them, just download the PDF files in this SQL repository.
