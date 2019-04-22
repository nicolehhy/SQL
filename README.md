
### Background
Some SQL Queries used during my data analyst internship are included in this repository. This internship is from Inke, a public company in China. Each folder represents a project( These analysis needs were from Product or Operations department)

### Company Introduction
Inke is the fastest-growing mobile app that provides millions of users with excellent live broadcasting service. 
Founded in March 2015, Inke has brought worldwide live-streaming service to its mobile app, 
with 130 millions of downloads and 15 millions of active users over Android and iOS platforms.

 * `Feed Strategy`(new product from product department)
   * project introduction <br>
     This folder shows the process of capturing data related to feed strategies which had been released for 2 weeks.
   * What I needed to analyze are the followings:
    1. Number of people who post feeds, Number of comments, and Number of likes per day
    2. Average number of posts per day for different publisher levels
    3. Average number of posts per day for different city levels
    4. The conversion of posting feeds next week from the publishers who posted feeds this week
    5. Publishers'Preferences for Publishing Contents in Different Cities
    
    The purpose was to analyze Whether the new online feed strategy can help users retain, 
    and whether it can quickly establish a further network between users. 

* `Posts in App`(UCG encouraging strategy from user growth team)
   * project introduction
     When users post feeds, they used the strategy of leaving comments by robots to encourage users to continue to use this feed feature, taking advantage of users' nature in loving being noticed.
   * What I needed to analyze are the followings:
    1. Compared the retention rate on this feed feature before and after using UCG strategy(A/B test) 
    2. Compared the Number of people who post feeds, Number of comments, and Number of likes per day before and after using UCG
    
* `Potential Anchor`(Anchor encouraging strategy from Strategy team)
   * project introduction
     The strategy was to increase the number of exposure times of new anchors with high quality live broadcasting on the recommended home page, so as to mine new anchors with high quality and explore more users/followers.
   * What I need to analyze are the followings:
    1. Exposure times, live broadcasting times, live broadcasting duration, followers growth rate per week
    2. Followers conversion rate of new anchors, number of followers giving gifts, amount of gifts
    
* `Push Strategy`(Recall loss of users from Marketing team)
   * project introduction
     The project was to recall lost users by sending different text messages(with link) to users who had not logged on to apps for more than a month. There were many strategies in this project. We mainly wanted to analyze which strategy had the best recall effect.
   * What I needed to analyze are the followings:
    1. Delivery rate, arrival rate and click-through rate under different channels, different mobile phone brands and different strategies
    2. Delivery rate, arrival rate and click-through rate for different strategies only
    3. How many people who clicked link in the messages re-login to app, under different strategies 
    
* `Recommendation in the same city`(User Growth strategy from product department)
   * project introduction
     This Project was to analyze the number of live broadcasts, the length of live broadcasts, and the interaction of fans from the anchors who were in the same city recommendation list, so as to understand the strengths and weaknesses of the strategy
   * What I needed to analyze are the followings:
    1. The number of times users in different cities stay on the same city recommendation pages, the number of videos users watch, the length of time users watch, the number of gifts users give, and the amount of gifts users give.
    2. The time duration of live broadcasting, the average times of live broadcasting, the number of new followers, the number of gifts received, the amount of gifts from the anchors on the the same city recommendation pages.

* `The King campaign`(Campaign from Operations department)
   * Campaign introduction
     Operations Department invited five famous anchors to participate in a game guessing and lottery draw with fans on one weekend evening. The purpose of this campaign was to encourage users to log in the application again to watch live broadcasting, attract new and old users to participate in the lottery events, thus to increase the time for users to watch live broadcasting, and then analyzed retention rate of users in the next week.
   * What I needed to analyze are the followings:
    1. Number of users participating in the event, total viewing time of users, average viewing time of users, total number of gifts given by users, average number of gifts given by users
    2. The total number of gifts, comments received by anchors and new followers anchors had


SQL statements
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
