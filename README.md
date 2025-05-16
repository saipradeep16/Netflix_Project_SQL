# 📺 NData-Driven Insights from Netflix Content Using SQL

![Netflix Project Banner](https://github.com/saipradeep16/Netflix_Project_SQL/blob/main/netflix%20logo.jpg)

## 🧠 Project Overview
This project dives into the Netflix dataset using **SQL** to uncover hidden insights about the content available on the platform — including **genre popularity, top-rated content, actor appearances, trends over time**, and more. It’s designed to mimic real-world business questions a data analyst might face at a streaming platform like Netflix.

---

## 📁 Files in this Repository
| File Name            | Description                                      |
|---------------------|--------------------------------------------------|
| `netflix_titles.csv`| Raw dataset of Netflix Movies & TV Shows        |
| `SQL_PROJECT.sql`   | SQL scripts used to explore and analyze the data|

---

## 🔧 Tools Used
- PostgreSQL / MySQL (SQL syntax)
- SQL Window Functions (`RANK()`, `COUNT()`, `UNNEST`, etc.)
- String and Date functions
- Joins, Grouping, Filtering

---

## 🔍 All SQL Queries Included

```sql
-- 0. Table Setup
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

-- 1. Basic Queries
SELECT * FROM netflix;
SELECT COUNT(*) FROM netflix;
SELECT DISTINCT director FROM netflix;
SELECT listed_in FROM netflix WHERE duration = '1 Season';
SELECT listed_in FROM netflix WHERE duration = '1 Season' AND release_year = 2019;
SELECT DISTINCT release_year FROM netflix ORDER BY release_year ASC;
SELECT type, COUNT(*) FROM netflix GROUP BY type;

-- 2. Most common ratings among Movies and TV Shows
SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*), RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
    FROM netflix
    GROUP BY 1,2
) as a1
WHERE ranking = 1;

-- 3. Titles released in 2019
SELECT title, release_year FROM netflix WHERE release_year = 2019;

-- 4. Movies released in 2019
SELECT * FROM netflix WHERE release_year = 2019 AND type = 'Movie';

-- 5. Top 5 countries with the most content on Netflix
SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country, COUNT(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 6. Identify the longest movie
SELECT type, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(REGEXP_REPLACE(duration, ' min', '', 'g') AS INTEGER) DESC
LIMIT 1;

-- 7. Movies/TV shows by director 'Rajiv Chilaka'
SELECT * FROM netflix WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. Content added in the last 6 years
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month, DD, YYYY') >= CURRENT_DATE - INTERVAL '6 Years';

-- 9. TV shows with more than 4 seasons
SELECT type, duration, title,
       CAST(REGEXP_REPLACE(duration, ' Season[s]?', '', 'g') AS INTEGER) AS season_count
FROM netflix
WHERE type = 'TV Show' 
AND CAST(REGEXP_REPLACE(duration, ' Season[s]?', '', 'g') AS INTEGER) > 4
ORDER BY season_count DESC;

-- 10. Count the number of content items in each genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')), COUNT(*)
FROM netflix
GROUP BY UNNEST(STRING_TO_ARRAY(listed_in, ','));

-- 11. Average content release per year by India (Top 2 years)
SELECT 
 EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
 COUNT(*),
 ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric * 100,2) as Average_Content_Per_Year
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 2;

-- 12. List all the movies that are documentaries
SELECT * FROM netflix WHERE listed_in ILIKE '%documentaries%';

-- 13. Find all content without a rating
SELECT * FROM netflix WHERE rating IS NULL;

-- 14. Movies with actor 'Aamir Khan' in the last 10 years
SELECT * FROM netflix 
WHERE casts ILIKE '%Aamir Khan%' 
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 15. Top 10 actors by movie appearances produced in India
SELECT 
  TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS Actor,
  COUNT(*)
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 16. Categorize content as 'Good' or 'Bad' based on keywords
WITH new_table AS (
    SELECT *,
       CASE
           WHEN description ILIKE '%kill%' OR description ILIKE '%violence%'
           THEN 'Bad'
           ELSE 'Good'
       END category    
    FROM netflix
)
SELECT category, COUNT(*)
FROM new_table
GROUP BY 1;
```

---

## 📜 Dataset Source
This dataset was sourced from Kaggle and includes 8,800+ Netflix titles with metadata like genre, cast, rating, duration, and country.

🔗 [Netflix Titles Dataset on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

---

## 👤 Author
- **Saipradeep Bomma**
- Graduate Student in Data Science | SQL & Python Enthusiast
- 📧 [LinkedIn](https://www.linkedin.com/in/saipradeep16)

---

> 💬 _Feel free to fork this repo and explore more complex analytics use cases or integrate this into BI tools like Tableau or Power BI._

## 📌 Overview  
This project analyzes the Netflix dataset using SQL. The dataset includes information about movies and TV shows available on Netflix. The SQL queries help extract insights such as genre distribution, release year trends, content ratings, and more.  

## 📂 Files in this Repository  
- **`netflix_titles.csv`** - The dataset containing Netflix movie and TV show details.  
- **`SQL PROJECT.sql`** - SQL queries used for data analysis.  

## 🚀 Features  
- Filtering content by genre, country, and year.  
- Analyzing trends in content addition over time.  
- Extracting top genres and most common ratings.  
- Identifying relationships between release year and content type.  

## 📜 Dataset Source  
The dataset used in this project comes from Kaggle. You can access and download it from the link below:  
🔗 **[Dataset Link](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)**  





