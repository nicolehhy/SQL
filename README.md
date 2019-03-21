# sql-
SQL, which stands for Structured Query Language, is a language for interacting with data stored in something called a relational database. 
Each column, or field, of a table contains a single attribute for all rows in the table.
In SQL, keywords are not case-sensitive

# SELECT MULTIPLE COLUMNS 
There are three different ways to select entities you want. One is select a single entity, one is select multiple entities, the third one is select all from the table.


SELECT name FROM people limit 10;  
SELECT name, title FROM people; 
SELECT * FROM people;


# USE DISTINCT TO SELECT UNIQUE ITEM

SELECT DISTINCT name FROM people;

# USE COUNT() TO SELECT THE NUMBER OF THE ENTITY
Count() doesn’t count the missing value of the entity you choose.

SELECT COUNT(name) FROM people;
SELECT COUNT(disctinct name) FROM people; 

# USE WHERE TO FILTER YOUR OBJECTS  
sometimes we use where.. and…/ or…

= equal;
<> not equal;
< less than;
> greater than;
<= less than or equal to;
>= greater than or equal to;

TIP1: Note that you need to specify the column for every OR condition, so the following is invalid:

SELECT title
FROM films
WHERE release_year = 1994 OR 2000;

TIP2: When combining AND and OR, be sure to enclose the individual clauses in parentheses, like so:

SELECT title
FROM films
WHERE (release_year = 1994 OR release_year = 1995)
AND (certification = 'PG' OR certification = 'R');

TIP3: Checking for ranges like this is very common, so in SQL the BETWEEN keyword provides a useful shorthand for filtering values within a specified range. This query is equivalent to the one above:

SELECT title
FROM films
WHERE release_year
BETWEEN 1994 AND 2000;

TIP4: If the range is a list, you can use where in to query data.
SELECT title FROM people WHERE ID in (1,2,3);

# find out the missing value 

SELECT COUNT(*)
FROM people
WHERE birthdate IS/ IS NOT NULL;

# fuzzy query
TIP1: Use like (% and _) to match the item you want. 
SELECT name FROM people
WHERE city LIKE "NEW%";

SELECT name FROM people
WHERE city LIKE "NEW_RK";

TIP2: use AS to rename the column you select


# ORDER BY
In SQL, the ORDER BY keyword is used to sort results in ascending or descending order according to the values of one or more columns.
If you want to sort the results in descending order, you can use the DESC keyword.
IF you are gonna sort multiple columns, put them in the order by list ( A,B,C) it will sort A first then B and finally C.

# USE HAVING TO FILTER YOUR DATA
This means that if you want to filter based on the result of an aggregate function, you need another way! That's where the HAVING clause comes in. For example,

SELECT release_year
FROM films
GROUP BY release_year
HAVING COUNT(title) > 10;

# JION TABLE

# inner join 

Select * from high as t1
Inner join low as t2
On t1.yu=t2.id

EXAMPLE:  第一张表有两个时间，第三表有两个时间，如果不同时将这两张表里的时间join就会有四个时间，里面会重复且交叉
-- 6. Select fields
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to populations (as p)
  INNER JOIN populations AS p
    -- 3. Match on country code
    ON c.code = p.country_code
  -- 4. Join to economies (as e)
  INNER JOIN economies AS e
    -- 5. Match on country code and year
ON c.code = e.code AND e.year=p.year;

TIP1 : if two tables have the same key words, we can use USING

# use CASE WHEN to classify your column
Tips: case when 是有优先顺序的，通常从最高级走，一旦输出，其他的条件对其无影响，并且其他条件会将第一顺序的结果排除

# INTO a new table
When select items, we can put our results into a new table during the querying process

Select A FROM 
INTO pop
FROM table1

# know the differences between right,left,full join, inner join
Inner join: when querying joins between two tables, only the matched result sets in two tables are preserved.

Left join: when a join query is made between two tables, returns all rows of the left table, even if there are no matching records in the right table.

Right join: when a join query is made between two tables, returns all rows of the right table, even if there are no matching records in the left table.

Full join: when joining queries between two tables, returns any matching rows in the left and right tables.


# cross join
产生结果是两个表的乘积，Which also mean CROSS JOIN returns the Cartesian product of the sets of rows from the joined tables.

# UNION 表和表之间的连接
union会去除结果集中重复的部分，相当于进行一个distinct（去重），并且union 会自带排序功能；
union all 会不管是否重复，都会将结果合并在一起输出，没有排序功能，只是结果集的堆叠输出。

# INTERSECT 表和表之间的重合
要结果完全一样的才会输出，并不会有key word

# EXCEPT 除去和第二张表相同的数据
@@@ semi-join
 


SELECT countries.name AS country, 
(SELECT COUNT(*) 
  FROM cities
    WHERE countries.code = cities.country_code)
AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;

# 复杂语句（subquery）
SELECT p.code,local_name,p.lang_num
  From countries,
  	-- Subquery (alias as subquery)
  	(SELECT code,count(*) AS lang_num
  	 From languages
  	 GROUP BY code) AS p
  -- Where codes match
  WHERE countries.code = p.code
-- Order by descending number of languages
Order by p.lang_num DESC;

#  复杂语句（subquery）
-- Select fields
SELECT name, continent, inflation_rate
  -- From countries
  FROM countries
	-- Join to economies
	INNER JOIN economies
	-- Match on code
	ON countries.code = economies.code
  -- Where year is 2015
  WHERE year = 2015
    -- And inflation rate in subquery (alias as subquery)
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT name, continent, inflation_rate
             FROM countries
             INNER JOIN economies
             ON countries.code = economies.code
             WHERE year = 2015) AS subquery
        GROUP BY continent);


 
