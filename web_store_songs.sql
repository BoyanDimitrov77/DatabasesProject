CREATE DATABASE web_store_songs;

use web_store_songs;


CREATE TABLE songs(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(255) NOT NULL UNIQUE,
genre varchar (100) NOT NULL,
style varchar (100) ,
arrangement varchar (100) ,
duration TIME NOT NULL

);



CREATE TABLE composers(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(255) NOT NULL UNIQUE,
country varchar(255) NOT NULL
);


CREATE TABLE singers(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(255) NOT NULL UNIQUE,
country varchar(255) NOT NULL
);

CREATE TABLE composers_songs(
composer_id int,
song_id int,
PRIMARY KEY(composer_id,song_id),
CONSTRAINT FOREIGN KEY (composer_id) references composers(id),
CONSTRAINT FOREIGN KEY (song_id) references songs(id)
);

CREATE TABLE singers_songs(
singer_id INT,
song_id INT,
PRIMARY KEY(singer_id,song_id),
CONSTRAINT FOREIGN KEY(singer_id) references singers(id),
CONSTRAINT FOREIGN KEY(song_id) references songs(id)
);

INSERT INTO singers(name,country)
VALUES("Aaron Neville","USA");

INSERT INTO singers(name,country)
VALUES("Adele","UK");

INSERT INTO singers(name,country)
VALUES("Bruno Mars","USA");

INSERT INTO singers(name,country)
VALUES ("Andie Case","Eugene, Oregon");


INSERT INTO songs(name,genre,style,arrangement,duration)
VALUES ("Stand by me","	Soul,"," rhythm and blues"," Stanley Applebaum",'00:02:57');

INSERT INTO songs(name,genre,style,arrangement,duration)
VALUES ("Hello","Soul",NULL,NULL,'00:04:55');

INSERT INTO songs(name,genre,style,arrangement,duration)
VALUES ("Just the way you are","POP","R&B","Bruno Mars",'00:03:41');

INSERT INTO songs(name,genre,style,arrangement,duration)
VALUES("Diggy Down","Dance-pop",NULL,NULL,'00:03:14');

INSERT INTO songs(name,genre,style,arrangement,duration)
VALUES("YAlla","House",NULL,NULL,'00:03:16');

INSERT INTO composers(name,country)
VALUES ("PHILIP LAWRENCE"," Dublin");

INSERT INTO composers(name,country)
VALUES ("Greg Kurstin","Los Angeles California ,United States");

INSERT INTO composers(name,country)
VALUES ("Ben E. King","Henderson, North Carolina, United States");

INSERT INTO composers (name,country)
VALUES("Sebastian Barac","Romania");


SELECT *FROM composers;
SELECT *FROM singers;
SELECT *FROM songs;

INSERT INTO composers_songs(composer_id,song_id)
VALUES (4,1);

INSERT INTO composers_songs(composer_id,song_id)
VALUES (3,2);

INSERT INTO composers_songs(composer_id,song_id)
VALUES (2,3);

INSERT INTO composers_songs(composer_id,song_id)
VALUES (1,4);

INSERT INTO composers_songs(composer_id,song_id)
VALUES (1,5);

INSERT INTO singers_songs(singer_id,song_id)
VALUES(2,2);

INSERT INTO singers_songs(singer_id,song_id)
VALUES(3,3);

INSERT INTO singers_songs(singer_id,song_id)
VALUES(1,1);

INSERT INTO singers_songs(singer_id,song_id)
VALUES(4,1);

INSERT INTO singers_songs(singer_id,song_id)
VALUES(4,2);

INSERT INTO singers_songs(singer_id,song_id)
VALUES(4,3);


/*задача 2*/
SELECT singers.id,singers.name as 'Singer name' FROM singers
WHERE singers.country LIKE '%USA%';

/*задача 3*/
SELECT singers.country,COUNT(singers.country) FROM singers
GROUP BY singers.country ASC;

/*задача 4*/
SELECT *FROM songs 
JOIN singers 
ON singers.id IN(
SELECT singer_id FROM singers_songs
WHERE singers_songs.song_id=songs.id
);


SELECT *FROM songs
LEFT OUTER JOIN singers 
ON singers.id IN(
SELECT singer_id FROM singers_songs
WHERE singers_songs.song_id=songs.id
);


/*задача 5*/
SELECT composers.name AS 'Composer`s name',COUNT(songs.id) AS 'Compose songs' FROM composers
JOIN  songs
ON songs.id IN(
SELECT song_id FROM composers_songs
WHERE composers_songs.composer_id=composers.id
)
GROUP BY composers.name;

drop procedure InsertSong;
delimiter |
create procedure InsertSong(IN singerName varchar(255),IN SingerCountry varchar(255),IN nameSong varchar(255),IN genreSong varchar(100),IN styleSong varchar(100),IN arrangementSong varchar(100),IN durationSong TIME )
begin

DECLARE SongID INT;
DECLARE SingerID INT;

	if(EXISTS(SELECT name FROM singers
    WHERE singers.name=singerName))
		THEN
			if(NOT EXISTS(SELECT name FROM songs
            WHERE songs.name=nameSong))
				THEN

                INSERT INTO songs(name,genre,style,arrangement,duration)
                VALUES(nameSong,genreSong,styleSong,arrangementSong,durationSong);
                
                SET SongID=(SELECT id FROM songs
                WHERE songs.name =nameSong
                );
                
                SET SingerID=(SELECT id FROM singers
                WHERE singers.name=singerName
                );
                
                INSERT INTO singers_songs(singer_id,song_id)
                VALUES (SingerID,SongID);
                  SELECT 'Succsess1';

			ELSE
            #ELECT "This song has already had in the list ";
				SET SongID=(SELECT id FROM songs
                WHERE songs.name =nameSong
                );
                
                SET SingerID=(SELECT id FROM singers
                WHERE singers.name=singerName
                );
                
                INSERT INTO singers_songs(singer_id,song_id)
                VALUES (SingerID,SongID);
                  SELECT 'Succsess2';
			
            END IF;
        
        ELSE
			INSERT INTO singers(name,country)
			VALUES(singerName,SingerCountry);
            
			if(NOT EXISTS(SELECT name FROM songs
            WHERE songs.name=nameSong))
				THEN
                
                INSERT INTO songs(name,genre,style,arrangement,duration)
                VALUES(nameSong,genreSong,styleSong,arrangementSong,durationSong);
                
				 
                SET SongID=(SELECT id FROM songs
                WHERE songs.name =nameSong
                );
                
                SET SingerID=(SELECT id FROM singers
                WHERE singers.name=singerName
                );
            
             INSERT INTO singers_songs(singer_id,song_id)
                VALUES (SingerID,SongID);
                
                  SELECT 'Succsess3';
                
                ELSE 
				SET SongID=(SELECT id FROM songs
                WHERE songs.name =nameSong
                );
                
                SET SingerID=(SELECT id FROM singers
                WHERE singers.name=singerName
                );
        
				 INSERT INTO singers_songs(singer_id,song_id)
                VALUES (SingerID,SongID);
                
                SELECT 'Succsess 4';
                END IF;
        
        END IF;

		
 
end;
|
delimiter ;

call InsertSong('Bruno Mars','USA','Will it rain','Soft rock','R&B,soul','Phredley Brown','00:04:17');

rollback;



/*AND songs.genre=genreSong
                AND songs.style=styleSong
                AND songs.arrangement=arrangementSong
                AND songs.duration=durationSong*/


