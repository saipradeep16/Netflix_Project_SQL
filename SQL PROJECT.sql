DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
	show_id INT,
	title VARCHAR(150),
	director VARCHAR(208),
	castS VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(25),
	listed_in VARCHAR(100),
	description VARCHAR(250),
	type VARCHAR(10)

);
--basic queries

SELECT * FROM netflix;

SELECT COUNT(*)
FROM netflix;

SELECT DISTINCT director
FROM netflix;

SELECT listed_in
FROM netflix
WHERE duration = '1 Season';

SELECT listed_in
FROM netflix
WHERE duration = '1 Season' AND release_year=2019;

SELECT DISTINCT release_year
FROM netflix
ORDER BY release_year ASC;

SELECT type,COUNT(*)
FROM netflix
GROUP BY type;

--1.find most common ratings among movie and TV show

SELECT * FROM netflix;


SELECT type, rating
from
(
SELECT type, rating, COUNT(*), rank() over(partition by type order by count(*) desc) as ranking
FROM netflix
GROUP BY 1,2
ORDER BY 1,3 desc
) as a1
where ranking=1;

--2.list the titles released in 2019
SELECT * FROM netflix

SELECT title, release_year 
FROM netflix
WHERE release_year=2019

--3.list the movies released in 2019
SELECT *
FROM netflix
WHERE release_year =2019 and type = 'Movie';

--4.find the top 5 countries with the most content on Netflix
SELECT country, count(*)
FROM netflix
group by 1


SELECT 
   UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country, 
   COUNT(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--5.identify the longest movie

SELECT * FROM netflix


SELECT type, duration
FROM netflix
WHERE type='Movie'
ORDER BY CAST(regexp_replace(duration, ' min', '', 'g') as INTEGER) DESC
LIMIT 1

--6.find all the movies/TV shows by director 'Rajiv Chilaka'
select * from netflix
where director ilike '%Rajiv Chilaka%' --ilike is not case sensitive


--7.find content added in the last 6 years
SELECT * FROM netflix

SELECT *
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month, DD, YYYY')>=CURRENT_DATE - INTERVAL'6 Years'

--8.list all tv shows with more than 4 seasons
SELECT type, duration, title,
       CAST(REGEXP_REPLACE(duration, ' Season[s]?', '', 'g') AS INTEGER) AS season_count
FROM netflix
WHERE type = 'TV Show' 
AND CAST(REGEXP_REPLACE(duration, ' Season[s]?', '', 'g') AS INTEGER) > 4
ORDER BY season_count DESC;


--9.count the number of content items in each genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')), COUNT(*)
FROM netflix
GROUP BY UNNEST(STRING_TO_ARRAY(listed_in, ','))

--10.Find each year and the average number of content release by India on netflix, return top 2 year with highest avg content release

SELECT 
 EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
 COUNT(*),
 ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric * 100,2) as Average_Content_Per_Year
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 2

--11. List all the movies that are documentaries.
SELECT *
FROM netflix
where listed_in ILIKE '%documentaries%'

--12. Find all content without a rating
SELECT * FROM netflix
WHERE rating IS NULL

--13. Find how many movies actor 'Aamir Khan' appeared in last 10 years
SELECT *
FROM netflix
WHERE casts ILIKE '%Aamir Khan%' 
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10 

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT 
  TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS Actor,
  COUNT(*)
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15. Categorize the content based on the presence of the keywords 'kill' and
 'voilence' in the description field. Label content containing these keywords as 'Bad'
 and all other content as 'Good'. Count how many items fail into each category.

WITH new_table
AS
(
SELECT *,
   CASE
   WHEN
	   description ILIKE '%kill%' OR 
	   description ILIKE '%violence'
	   THEN 'Bad'
	   ELSE 'Good'
   END category    
FROM netflix
)

SELECT category, COUNT(*)
FROM new_table
GROUP BY 1






