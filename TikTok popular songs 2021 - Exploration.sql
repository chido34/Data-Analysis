-- Dataset : https://www.kaggle.com/datasets/sveta151/tiktok-popular-songs-2021
-- Taking a look at the dataset

select * from tsong






-- album column looks irrelevant since tracks are chosen from tiktok based on the track name
-- let's drop it

alter table tsong
drop column album






-- Now we'll change the 'key' column to 'songkey' since it couldn't be filled du a syntaxic error

sp_rename 'dbo.tsong.key' , 'song_key','column'






-- The feat mentioned in the track_name might be useful, so we're going to add a column 2nd_artist

alter table tsong
add second_artist varchar(255)






-- fill the column with the second artist name extracted from the track_name

insert into tsong (track_name,artist_name,artist_pop,track_pop,danceability,energy,loudness,mode,song_key,speechiness,acousticness,instrumentalness,liveness,valence,tempo,time_signature,duration_ms,second_artist) 
select track_name,artist_name,artist_pop,track_pop,danceability,energy,loudness,mode,song_key,speechiness,acousticness,instrumentalness,liveness,valence,tempo,time_signature,duration_ms,case when track_name like '%with.%' then trim(substring(track_name,charindex('with.',track_name)+6,len(track_name)-(charindex('with.',track_name)+6)))
	when track_name like '%with%' then trim(substring(track_name,charindex('with',track_name)+5,len(track_name)-(charindex('with',track_name)+5)))
	when track_name like '%feat.%' then trim(substring(track_name,charindex('feat.',track_name)+6,len(track_name)-(charindex('feat.',track_name)+6)))
	else 'None'
end as trimmed 
from tsong






-- After executing this command, we're going to delete the duplicates since we've inserted the same values with the second_artist column filled when it was null after the creation

delete from tsong where second_artist is null






-- let's check now, we should have 190 rows only

select count(track_name) from tsong






-- Checking if some artist_name have blank space at the beginning to trim it

select artist_name from tsong
where artist_name like ' %'






-- After finding 3 , it's now the time of Trimming

update tsong
set artist_name = trim(artist_name)
where artist_name like ' %'






-- Checking if the new values submitted to second_artist are correct
select track_name,artist_name,second_artist from tsong
where second_artist <> 'None'
order by second_artist

-- After checking the result of the last query, 3 or 4 values of second_artist values might not be correct
-- example: 'Save Your Tears (with Ariana Grande) (Remix)' --> 'Ariana Grande) (Remix'
-- This won't be a problem


-- I believe this dataset is now ready to be get some analysis
