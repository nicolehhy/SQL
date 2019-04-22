### Some SQL Queries used during internships are included in this repository. 
### Each folder represents a project( These analysis needs were from Product or Operations department)

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
