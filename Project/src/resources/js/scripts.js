function load_drawing(){ //look at socket sample games for implementing this continuously
  document.getElementById("drawing").src = "../resources/imgs/puppy.jpg"; // make this sql call with get
  let timer_spot = document.getElementById("timer_spot");
  let score_spot = document.getElementById("score_spot");
  let timer = document.createElement("div");
  timer.ClassName = "Timer";
  let score = document.createElement("div");
  timer.setAttribute(/*timer here*/);
  score.setAttribute(/*score here*/);
  timer_spot.appendChild(timer);
  score_spot.appendChild(score);
}

function check_guess(guesses,ans){
  var new_guess = document.getElementById("guess").value;
  if (new_guess == ans){
    guessed_right()
  }
  guesses.push(" " + new_guess);
  document.getElementById("guesses_list").innerHTML = guesses;
  document.getElementById("myForm").reset();
}

function guessed_right(){
  //switch pages of each user
  document.getElementById("correct_link").click();

  //award points to correct guesser
}

//gets
/* update guesser page */
app.get('/guess/update_guesser_page', function(req, res) {
	var game_info =  "SELECT * FROM Games WHERE Game_Code='" + req.game_code + "';"; //sql for getting game info
	db.task('get-everything', task => {
        return task.batch([
            task.any(game_info),
        ]);
    })
    .then(info => {
    	res.render('guess',{
        users: info[0][1],
				current_image: info[0][2],
        winner: info[0][4]
			})
    })
    .catch(err => {
        console.log('error getting game info', err);
    });
});

/*determine whether to change drawers page */
app.get('/draw/update_drawer_page', function(req, res) {
  var game_code = req.body.game_code; //game code of user's game
	var game_info =  "SELECT * FROM Games WHERE Game_Code='" + game_code + "';"; //sql for getting game info
	db.task('get-everything', task => {
        return task.batch([
            task.any(game_info),
        ]);
    })
    .then(info => {
    	res.render('draw',{
        users: info[0][1],
				winner: info[0][4]
			})
    })
    .catch(err => {
        console.log('error getting game info', err);
    });
});



//posts
/* when user1 creates game */
app.post('/sign_on/create_game', function(req, res) {
  var game_code = req.body.game_code;
  var user_name = req.body.user_name;
  var blank_image = 'path_of_blank_image';
  var zero_time = Date.now();
	var insert_games = "INSERT INTO Games (GameCode,UsersInGame,CurrentImage,ImageTimeStamp) VALUES('" + game_code + "','" + user_name + "','" + blank_image + "'," + zero_time + ");"; //sql for adding game to games table
	var insert_users = "INSERT INTO Users(GameCode,UserName,UserScore) VALUES('" + game_code + "','" + user_name + "',0);"; //sql for adding user to users table

	db.task('get-everything', task => {
        return task.batch([
            task.any(insert_games),
            task.any(insert_users)
        ]);
    })
    .then(info => {
    	res.render('draw',{
			})
    })
    .catch(err => {
        console.log('error updating database', err);
    });
});

/* when users join game */
app.post('/sign_on/join_game', function(req, res) {
  var game_code = req.body.game_code;
  var user_name = req.body.user_name;
  var user_names = req.body.user_names + user_name;
	var update_games = "UPDATE Games SET UsersInGame = '" + user_names + "' WHERE GameCode = '" + game_code + "';"; //sql for updating users in games table
	var insert_users = "INSERT INTO Users(GameCode,UserName,UserScore) VALUES('" + game_code + "','" + user_name + "',0);"; //sql for adding user to users table

	db.task('get-everything', task => {
        return task.batch([
            task.any(update_games),
            task.any(insert_users)
        ]);
    })
    .then(info => {
    	res.render('guess',{
			})
    })
    .catch(err => {
        console.log('error updating database', err);
    });
});

/* when image updates */
app.post('/draw/update_image', function(req, res) {
  var game_code = req.body.game_code;
  var img_loc = req.body.img_loc;
  var current_time = Date.now();
	var update_games = "UPDATE Games SET CurrentImage = '" + img_loc + "', ImageTimeStamp = " + current_time + " WHERE GameCode = '" + game_code + "';"; //sql for updating image in games table

	db.task('get-everything', task => {
        return task.batch([
            task.any(update_games)
        ]);
    })
    .then(info => {
    	res.render('draw',{
			})
    })
    .catch(err => {
        console.log('error updating database', err);
    });
});

/* when game ends */
app.post('/guess/end_game', function(req, res) {
  var new_score = req.body.score;
  var user_name = req.body.user_name;
  var blank_image = 'path_of_blank_image';
  var zero_time = Date.now();
  var update_users = "UPDATE Users SET UserScore = " + new_score + " WHERE UserName = '" + user_name + "';";
	var update_games = "UPDATE Games SET CurrentImage = '" + blank_image + "', ImageTimeStamp = " + zero_time + " WHERE GameCode = '" + game_code + "';"; //sql for updating image in games table

  db.task('get-everything', task => {
        return task.batch([
            task.any(update_users),
            task.any(update_games)
        ]);
    })
    .then(info => {
    	res.render('correct',{
			})
    })
    .catch(err => {
        console.log('error updating database', err);
    });
});

/* when games end */
app.post('/game_over/end_games', function(req, res) {
  var game_code = req.body.game_code;
  var update_users = "DELETE FROM Users WHERE GameCode = '" + game_code + "';"; //sql for deleting user from table
  var update_games = "DELETE FROM Games WHERE GameCode = '" + game_code + "';"; //sql for deleting game from table
  db.task('get-everything', task => {
        return task.batch([
            task.any(update_users),
            task.any(update_games)
        ]);
    })
    .catch(err => {
        console.log('error updating database', err);
    });
});
