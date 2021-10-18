function load_drawing(){
  document.getElementById("drawing").src = "../resources/imgs/puppy.jpg";
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
