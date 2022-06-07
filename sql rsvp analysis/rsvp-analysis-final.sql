USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- ROW IN Director_Mapping 3867
SELECT Count(*)
FROM   director_mapping;

-- ROW IN genre 14662
SELECT Count(*)
FROM   genre;

-- ROW IN movie 7997
SELECT Count(*)
FROM   movie;

-- ROW IN names 25735
SELECT Count(*)
FROM   names;

-- ROW IN ratings 7997
SELECT Count(*)
FROM   ratings;

-- ROW IN ratings 15615
SELECT Count(*)
FROM   role_mapping;

-- Q2. Which columns in the movie table have null values?
/* country, worlwide_gross_income,languages, production_company have null values.
  */
-- Type your code below: 
SELECT Count(*) AS id
FROM   movie
WHERE  id IS NULL; 

SELECT Count(*) AS title
FROM   movie
WHERE  title IS NULL; 

SELECT Count(*) AS date_published
FROM   movie
WHERE  date_published IS NULL; 

SELECT COUNT(*) AS duration
FROM   movie
WHERE  duration IS NULL;

SELECT Count(*) AS country
FROM   movie
WHERE  country IS NULL;

-- 20 null in country
SELECT Count(*) AS worlwide_gross_income
FROM   movie
WHERE  worlwide_gross_income IS NULL; -- 3724 null in worlwide_gross_income

SELECT Count(*) AS languages
FROM   movie
WHERE  languages IS NULL; -- 194 null in worlwide_gross_income
SELECT Count(*) AS production_company
FROM   movie
WHERE  production_company IS NULL; -- 528 null in worlwide_gross_income
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year; 
/*
# year, number_of_movies
'2017', '3052'
'2018', '2944'
'2019', '2001'*/





-- or 

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT a.month_num,
       Sum(a.number_of_movies) AS number_of_movies
FROM  (SELECT Month(date_published) AS month_num,
              Count(id)             AS number_of_movies
       FROM   movie
       GROUP  BY date_published)a
GROUP  BY a.month_num
ORDER  BY a.month_num; 

/*# month_num, number_of_movies
'1', '804'
'2', '640'
'3', '824'
'4', '680'
'5', '625'
'6', '580'
'7', '493'
'8', '678'
'9', '809'
'10', '801'
'11', '625'
'12', '438'
*/




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- 1059 movies were produced
-- Type your code below:

SELECT Sum(movies_produced) AS India_Usa_Movie_Produced
FROM   (SELECT date_published,
               country,
               Count(id) AS Movies_Produced
        FROM   movie
        WHERE  ( country LIKE '%USA%'
                  OR country LIKE '%India%' )
           AND Year(date_published) = '2019'
        GROUP  BY country)a; 








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
/*# Genre
'Drama'
'Fantasy'
'Thriller'
'Comedy'
'Horror'
'Family'
'Romance'
'Adventure'
'Action'
'Sci-Fi'
'Crime'
'Mystery'
'Others'
*/
-- Type your code below:

SELECT  DISTINCT Genre from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Drama
/*# Genre, Movies_Produced
'Drama', '4285'
'Comedy', '2412'
'Thriller', '1484'
'Action', '1289'
'Horror', '1208'
'Romance', '906'
'Crime', '813'
'Adventure', '591'
'Mystery', '555'
'Sci-Fi', '375'
'Fantasy', '342'
'Family', '302'
'Others', '100'
*/
-- Type your code below:

SELECT g.genre,
       Count(m.id) AS Movies_Produced
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY Count(id) DESC; 




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?  -- doubt
-- 3289
-- Type your code below:
WITH one_genre_alias
     AS (SELECT movie_id,
                Count(genre) AS genre
         FROM   genre
         GROUP  BY movie_id
         HAVING genre = 1)
SELECT Count(movie_id) AS only_one_genre
FROM   one_genre_alias; 


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
/*# genre, Average
'Action', '113'
'Romance', '110'
'Crime', '107'
'Drama', '107'
'Fantasy', '105'
'Comedy', '103'
'Adventure', '102'
'Mystery', '102'
'Thriller', '102'
'Family', '101'
'Others', '100'
'Sci-Fi', '98'
'Horror', '93'
*/
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Round(Avg(duration)) AS avg_duration
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY Avg(duration) DESC; 



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- 3
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH moviegenre
     AS (SELECT g.genre,
                Count(m.id)                    AS movie_count,
                Rank()
                  OVER (
                    ORDER BY Count(m.id) DESC) AS genre_rank
         FROM   genre g
                INNER JOIN movie m
                        ON m.id = g.movie_id
         GROUP  BY genre)
SELECT genre,
       movie_count,
       genre_rank
FROM   moviegenre; 


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/*# min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
'1.0', '10.0', '100', '725138', '1', '10'
*/
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. -- change
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
title	avg_rating	movie_rank
Kirket	10	1
Love in Kilnerry	10	1
Gini Helida Kathe	9.8	3
Runam	9.7	4
Fan	9.6	5
Android Kunjappan Version 5.25	9.6	5
Yeh Suhaagraat Impossible	9.5	7
Safe	9.5	7
The Brighton Miracle	9.5	7
Shibu	9.4	10
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too



SELECT   title,
         avg_rating,
         Rank() over(ORDER BY avg_rating DESC ) movie_rank
FROM     ratings r
JOIN     movie m
ON       r.movie_id = m.id
ORDER BY movie_rank
LIMIT    10;








/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* # median_rating, movie_count
'1', '94'
'2', '119'
'3', '283'
'4', '479'
'5', '985'
'6', '1975'
'7', '2257'
'8', '1030'
'9', '429'
'10', '346'
*/
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(date_published) AS movie_count
FROM   ratings r
       INNER JOIN movie m
               ON m.id = r.movie_id
GROUP  BY median_rating
ORDER  BY median_rating; 


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT     m.production_company,
           Count(m.id)                            AS movie_count,
           Rank() over(ORDER BY count(m.id) DESC)    prod_company_rank
FROM       ratings r
INNER JOIN movie m
ON         r.movie_id = m.id
WHERE      r.avg_rating > 8
AND         m.production_company IS NOT NULL
GROUP BY   m.production_company
LIMIT      5;








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/*# genre, movie_count
'Drama', '24'
'Comedy', '9'
'Action', '8'
'Thriller', '8'
'Sci-Fi', '7'
'Crime', '6'
'Horror', '6'
'Mystery', '4'
'Romance', '4'
'Fantasy', '3'
'Adventure', '3'
'Family', '1'
*/
/* Output format: DOUBT

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT genre,
       Count(g.movie_id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  year = 2017
   AND Month(date_published) = 3
   AND Lower(country) LIKE '%USA%'
   AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* # title, avg_rating, genre
'The Blue Elephant 2', '8.8', 'Drama'
'The Blue Elephant 2', '8.8', 'Horror'
'The Blue Elephant 2', '8.8', 'Mystery'
'The Brighton Miracle', '9.5', 'Drama'
'The Irishman', '8.7', 'Crime'
'The Irishman', '8.7', 'Drama'
'The Colour of Darkness', '9.1', 'Drama'
'Theeran Adhigaaram Ondru', '8.3', 'Action'
'Theeran Adhigaaram Ondru', '8.3', 'Crime'
'Theeran Adhigaaram Ondru', '8.3', 'Thriller'
'The Mystery of Godliness: The Sequel', '8.5', 'Drama'
'The Gambinos', '8.4', 'Crime'
'The Gambinos', '8.4', 'Drama'
'The King and I', '8.2', 'Drama'
'The King and I', '8.2', 'Romance'
*/
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       g.genre
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
       INNER JOIN genre g
               ON g.movie_id = m.id
WHERE  r.avg_rating > 8
   AND title LIKE 'the%'; 


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- 361 
-- Type your code below:  DOUBT
/*SELECT r.median_rating,m.date_published FROM movie m
INNER JOIN ratings r ON r.movie_id=m.id
WHERE m.date_published = 01-03-2018 AND 01-03-2019
AND r.median_rating>8;*/
SELECT Count(m.id) AS movie_count_with_median_rating
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  median_rating = 8
   AND date_published BETWEEN '2018-04-01' AND '2019-04-01'; 

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? -- change
-- YES
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT Sum(total_votes) AS SUM_OF_GERMANY_VOTES
FROM   movie m
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  country LIKE '%Germany%';

-- 2026223 is the sum of total votes for German movies.
SELECT Sum(total_votes) AS SUM_OF_ITALY_VOTES
FROM   movie m
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  country LIKE '%Italy%'; 
-- 703024 votes WHICH IS LESS THAN GERMANY








-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
-- 54 height,52 date_of_birth,53 known_for_movies 
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- checking null in names
SELECT id,
       name,
       height,
       date_of_birth,
       known_for_movies
FROM   names
WHERE  id IS NULL
    OR name IS NULL
    OR height IS NULL
    OR date_of_birth IS NULL
    OR known_for_movies IS NULL; 

/* names having null values 
so checking count of nulls in each attribute
*/
SELECT id
FROM   names
WHERE  id IS NULL;

SELECT name
FROM   names
WHERE  name IS NULL;

SELECT Count(*) AS height
FROM   names
WHERE  height IS NULL; 
-- 17335 nulls in height

SELECT Count(*) AS date_of_birth
FROM   names
WHERE  date_of_birth IS NULL; 
-- 13431 nulls in date_of_birth

SELECT Count(*) AS known_for_movies
FROM   names
WHERE  known_for_movies IS NULL; 
-- 15226 nulls in known_for_movies










/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:




WITH top_genres
AS
  (
             SELECT     genre,
                        count(m.id)                              AS movie_count,
                        rank () over (ORDER BY count(m.id) DESC) AS genre_rank
             FROM       genre                                    AS g
             LEFT JOIN movie                                    AS m
             ON         g.movie_id = m.id
             INNER JOIN ratings AS r
             ON         m.id = r.movie_id
             WHERE      avg_rating > 8
             GROUP BY   genre )
  SELECT     n.name           AS director_name,
             count(m.id)      AS movie_count
  FROM       names            AS n
  INNER JOIN director_mapping AS dm
  ON         n.id = dm.name_id
  INNER JOIN movie AS m
  ON         dm.movie_id = m.id
  INNER JOIN ratings AS r
  ON         m.id = r.movie_id
  INNER JOIN genre AS g
  ON         g.movie_id = m.id
  WHERE      g.genre IN
                         (
                         SELECT DISTINCT genre
                         FROM            top_genres
                         WHERE           genre_rank <= 3 )
  AND        avg_rating > 8
  GROUP BY   name
  ORDER BY   movie_count DESC
  LIMIT      3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* # name, movie_count
'Mammootty', '8'
'Mohanlal', '5'
*/
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name,
       Count(date_published) AS movie_count
FROM   role_mapping rm
       INNER JOIN movie m
               ON m.id = rm.movie_id
       INNER JOIN names n
               ON n.id = rm.name_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  rm.category = 'actor'
   AND r.median_rating >= 8
GROUP  BY n.name
ORDER  BY Count(date_published) DESC
LIMIT  2; 

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format: DOUBT
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



SELECT   m.production_company,
         Sum(r.total_votes)                             total_votes,
         Rank() over (ORDER BY sum(r.total_votes) DESC) votes_rank
FROM     movie m
JOIN     ratings r
ON       m.id = r.movie_id
GROUP BY m.production_company
ORDER BY votes_rank
LIMIT    3;








/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH only_indian
AS
  (
             SELECT     n.name AS actor_name,
                        r.total_votes,
                        m.id,
                        r.avg_rating,
                        total_votes * avg_rating AS weight_avg
             FROM       names n
             INNER JOIN role_mapping rm
             ON         n.id = rm.name_id
             INNER JOIN ratings r
             ON         rm.movie_id = r.movie_id
             INNER JOIN movie m
             ON         m.id = r.movie_id
             WHERE      category = 'Actor'
             AND        country = 'India'
             ORDER BY   actor_name )
  ,
  actor
AS
  (
         SELECT *,
                sum(weight_avg) over window1  AS rating,
                sum(total_votes) over window2 AS votes
         FROM   only_indian window window1    AS ( partition BY actor_name ) ,
                window2                       AS ( partition BY actor_name ) )
  SELECT   actor_name,
           votes                                              AS total_votes,
           count(id)                                          AS movie_count,
           round(rating                         / votes, 2)   AS actor_avg_rating,
           dense_rank () over ( ORDER BY rating / votes DESC) AS actor_rank
  FROM     actor
  GROUP BY actor_name
  HAVING   movie_count >= 5;








-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH only_indian
AS
  (
             SELECT     n.name AS actress_name,
                        r.total_votes,
                        m.id,
                        r.avg_rating,
                        total_votes * avg_rating AS weight_avg
             FROM       names n
             INNER JOIN role_mapping rm
             ON         n.id = rm.name_id
             INNER JOIN ratings r
             ON         rm.movie_id = r.movie_id
             INNER JOIN movie m
             ON         m.id = r.movie_id
             WHERE      category = 'Actress'
             AND        languages = 'Hindi'
             ORDER BY   actress_name )
  ,
  actress
AS
  (
         SELECT *,
                sum(weight_avg) over window1  AS rating,
                sum(total_votes) over window2 AS votes
         FROM   only_indian window window1    AS ( partition BY actress_name ) ,
                window2                       AS ( partition BY actress_name ) )
  SELECT   actress_name,
           votes                                              AS total_votes,
           count(id)                                          AS movie_count,
           round(rating                         / votes, 2)   AS actress_avg_rating,
           dense_rank () over ( ORDER BY rating / votes DESC) AS actress_rank
  FROM     actress
  GROUP BY actress_name
  HAVING   movie_count >= 3;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         WHEN avg_rating < 5 THEN 'Flop movies'
       end AS movie_type
FROM   ratings r
       INNER JOIN movie m
               ON m.id = r.movie_id
       INNER JOIN genre g
               ON g.movie_id = m.id
WHERE  g.genre = 'thriller'; 








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH full_genre
     AS (SELECT genre,
                Round(Avg(duration), 2) AS avg_duration
         FROM   genre AS g
                LEFT JOIN movie AS m
                       ON g.movie_id = m.id
         GROUP  BY genre)
SELECT *,
       SUM(avg_duration)
         over (
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       Avg(avg_duration)
         over (
           ORDER BY genre ROWS unbounded preceding) AS moving_avg_duration
FROM   full_genre; 









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies



WITH top_genres
AS
  (
            SELECT    genre,
                      count(m.id)                              AS movie_count,
                      rank () over (ORDER BY count(m.id) DESC) AS genre_rank
            FROM      genre                                    AS g
            LEFT JOIN movie                                    AS m
            ON        g.movie_id = m.id
            GROUP BY  genre )
  ,
  top_grossing
AS
  (
             SELECT     g.genre,
                        year,
                        m.title AS movie_name,
                        worlwide_gross_income,
                        rank() over (partition BY g.genre, year ORDER BY CONVERT(REPLACE(trim(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
             FROM       movie                                                                                                                       AS m
             INNER JOIN genre                                                                                                                       AS g
             ON         g.movie_id = m.id
             WHERE      g.genre IN
                                    (
                                    SELECT DISTINCT genre
                                    FROM            top_genres
                                    WHERE           genre_rank<=3) )
  SELECT *
  FROM   top_grossing
  WHERE  movie_rank<=5;




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH top_prod
     AS (SELECT m.production_company,
                Count(m.id)                    AS movie_count,
                Row_number()
                  over (
                    ORDER BY Count(m.id) DESC) AS prod_comp_rank
         FROM   movie AS m
                left join ratings AS r
                       ON m.id = r.movie_id
         WHERE  median_rating >= 8
            AND m.production_company IS NOT NULL
            AND Position(',' IN languages) > 0
         GROUP  BY m.production_company)
SELECT *
FROM   top_prod
WHERE  prod_comp_rank <= 2; 




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* # actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
'Sangeetha Bhat', '1010', '1', '9.60', '1'
'Fatmire Sahiti', '3932', '1', '9.40', '2'
'Adriana Matoshi', '3932', '1', '9.40', '3'
*/
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_ratings
AS
  (
             SELECT     n.name                                                           AS actress_name,
                        sum(r.total_votes)                                               AS total_votes,
                        count(m.id)                                                      AS movie_count,
                        round( sum(r.avg_rating*r.total_votes) / sum(r.total_votes) , 2) AS actress_avg_rating
             FROM       names                                                            AS n
             INNER JOIN role_mapping                                                     AS a
             ON         n.id = a.name_id
             INNER JOIN movie AS m
             ON         a.movie_id = m.id
             INNER JOIN ratings AS r
             ON         m.id = r.movie_id
             INNER JOIN genre AS g
             ON         m.id = g.movie_id
             WHERE      category = 'actress'
             AND        lower(g.genre) = 'drama'
             AND        avg_rating>8
             GROUP BY   actress_name )
  SELECT   *,
           row_number() over ( ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
  FROM     actress_ratings
  LIMIT    3;




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top_directors
     AS (SELECT n.id                           AS director_id,
                n.NAME                         AS director_name,
                Count(m.id)                    AS movie_count,
                Rank()
                  OVER (
                    ORDER BY Count(m.id) DESC) AS director_rank
         FROM   names AS n
                INNER JOIN director_mapping AS dm
                        ON n.id = dm.name_id
                INNER JOIN movie AS m
                        ON dm.movie_id = m.id
         GROUP  BY n.id),
     movie_summary
     AS (SELECT n.id                           AS director_id,
                n.NAME                         AS director_name,
                m.id                           AS movie_id,
                m.date_published,
                r.avg_rating,
                r.total_votes,
                m.duration,
                Lead(date_published)
                  OVER (
                    partition BY n.id
                    ORDER BY m.date_published) AS next_date_published, Datediff(
        Lead(
        date_published) OVER (partition BY n.id ORDER BY m.date_published),
        date_published) AS inter_movie_days
         FROM   names AS n
                INNER JOIN director_mapping AS dm
                        ON n.id = dm.name_id
                INNER JOIN movie AS m
                        ON dm.movie_id = m.id
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE
n.id IN ( SELECT director_id FROM top_directors WHERE director_rank <= 9 ))
SELECT director_id,
       director_name,
       Count(DISTINCT movie_id)                                   AS
number_of_movies,
       Round(Avg(inter_movie_days), 0)                            AS
avg_inter_movie_days,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS avg_rating,
       Sum(total_votes)                                           AS total_votes
,
       Min(avg_rating)                                            AS min_rating
,
       Max(avg_rating)                                            AS max_rating
,
       Sum(duration)                                              AS
total_duration
FROM   movie_summary
GROUP  BY director_id
ORDER  BY number_of_movies DESC,
          avg_rating DESC; 





