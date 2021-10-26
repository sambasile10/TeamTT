DROP TABLE IF EXISTS *game_code* CASCADE;
CREATE TABLE IF NOT EXISTS *game_code*(
  id SERIAL PRIMARY KEY,
  user_name VARCHAR(45),
  score INT
)
INSERT INTO (id,user_name,score)

DROP TABLE IF EXISTS img_*game_code* CASCADE;
CREATE TABLE IF NOT EXISTS img_*game_code*(
    img BLOB,
    time_stamp TIME,
    user_id INT
);

INSERT INTO *game_code*(id,user_name,score) //do we neet id?
VALUES(*id*,*user_name*,*score*);

INSERT INTO img_*game_code*(img,time_stamp,user_id)
VALUES(*img_from_react*,*time_stamp_from_timer*,*id_of_drawer*)
