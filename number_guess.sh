#!/bin/bash
# ================================================
# Number Guessing Game Project by freeCodeCamp Certification
# Author: Anibal Saavedra
# Date: 12-29-2025
# ================================================

# Variable to connect to the database (PSQL)
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Ask for username
echo "Enter your username:"
read USERNAME

# Check if user exists in the database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# If user does NOT exist
if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."

  # Insert new user
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

else
  # User exists → get stats
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")

  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Secret random number (1–1000)
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Prompt the user to start guessing
echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=0

while true
do
  read GUESS

  # Validate int input
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  # Increase counter
  NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))

  # Compare guess
  if (( GUESS == SECRET_NUMBER ))
  then
    # Save game into DB
    SAVE_GAME=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)")

    # Victory message
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break

  elif (( GUESS > SECRET_NUMBER ))
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done