CREATE TABLE IF NOT EXISTS spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);



select * from spotify;
SELECT * FROM spotify WHERE duration_min = 0;
DELETE FROM spotify WHERE duration_min = 0;





-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track
FROM spotify 
WHERE stream > 1000000000;



-- 2. List all albums along with their respective artists.
SELECT 
	DISTINCT album, artist 
FROM spotify
ORDER BY 1;



-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT
	sum(comments) as total_comments
FROM spotify
WHERE licensed = 'true';



-- 4. Find all tracks that belong to the album type single.
SELECT 
	track 
FROM spotify 
WHERE album_type = 'single';



-- 5. Count the total number of tracks by each artist.
SELECT 
	artist, count(track) AS no_of_tracks
FROM spotify
GROUP BY 1;



-- 6. Calculate the average danceability of tracks in each album.
SELECT 
	album,avg(danceability) AS avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;



-- 7. Find the top 5 tracks with the highest energy values.
SELECT 
	track, MAX(energy) AS max_energy
FROM spotify 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT 
	track,
	SUM(views) AS total_views,
	SUM(likes) AS total_likes
FROM spotify 
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC;



-- 9. For each album, calculate the total views of all associated tracks.
select 
album, track, SUM(views)
FROM spotify
GROUP BY 1,2
ORDER By 2;



-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT *
FROM(
SELECT
	track,
	COALESCE (SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE (SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY 1
ORDER BY 3 DESC) as t1
WHERE streamed_on_youtube<streamed_on_spotify
	AND 
	streamed_on_spotify <> 0 
	AND 
	streamed_on_youtube <> 0;



-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist
AS
(SELECT 
	artist,
	track,
	SUM(views) AS total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as ranking 	
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC)
SELECT * 
FROM ranking_artist
WHERE ranking <=3;



-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT
	artist,
	track,
	liveness 
FROM spotify 
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY liveness DESC;



-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH energy_diff
AS(SELECT
	album,
	MAX(energy) AS max_energy,
	MIN(energy) AS min_energy
FROM spotify 
GROUP BY 1)
SELECT *,
	max_energy - min_energy as energy_diffrence
FROM energy_diff
ORDER BY album;

