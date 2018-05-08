/*  
PostgreSQL query for SYBO Data Analyst - Case - Question 1
Author: Ioannis Fotiadis
Date: 03/04/2018						*/



SELECT date(spending.time_stamp),
/* Here I summarize the amount of money spent each day, by each type of spender, combining the data from the subquery and from the spending table */
       SUM(CASE
               WHEN C.category = 'minnows'
                    AND C.player_id = spending.player_id
               THEN spending.spend
               ELSE 0
           END) AS minnows,
       SUM(CASE
               WHEN C.category = 'trout'
                    AND C.player_id = spending.player_id
               THEN spending.spend
               ELSE 0
           END) AS trout,
       SUM(CASE
               WHEN C.category = 'salmon'
                    AND C.player_id = spending.player_id
               THEN spending.spend
               ELSE 0
           END) AS salmon,
       SUM(CASE
               WHEN C.category = 'tuna'
                    AND C.player_id = spending.player_id
               THEN spending.spend
               ELSE 0
           END) AS tuna,
       SUM(CASE
               WHEN C.category = 'whales'
                    AND C.player_id = spending.player_id
               THEN spending.spend
               ELSE 0
           END) AS whales
FROM spending
     INNER JOIN

(/* Here I make a subquery that categorizes players based on their total spending, and then I use the result to match the player_id
 from the subquery to the player_id from spending table */
    SELECT player_id,
           CASE
               WHEN SUM(spend) < 50
               THEN 'minnows'
               WHEN SUM(spend) >= 50
                    AND SUM(spend) < 100
               THEN 'trout'
               WHEN SUM(spend) >= 100
                    AND SUM(spend) < 500
               THEN 'salmon'
               WHEN SUM(spend) >= 500
                    AND SUM(spend) < 1000
               THEN 'tuna'
               ELSE 'whales'
           END AS category
    FROM spending
    GROUP BY player_id
) AS C ON spending.player_id = C.player_id   /* Subquery's table alias is C */
GROUP BY date(spending.time_stamp)
ORDER BY date(spending.time_stamp);
