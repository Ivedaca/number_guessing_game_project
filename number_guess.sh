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

