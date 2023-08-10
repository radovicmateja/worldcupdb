#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIGO OPGO
do
  #getting team id and inserting names from winners
  if [[ $WINNER != "winner" ]]
  then
    # get team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert team
      echo -e "\nInserting teams: $WINNER"
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  fi

  #getting team id and inserting names from opponents
  if [[ $OPPONENT != "opponent" ]]
  then
    # get team_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert team
      echo -e "\nInserting teams: $OPPONENT"
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  fi

  echo -e "\nInserting win_id, opp_id, wigo, opgo, year, round"
  echo "$($PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES ($WINNER_ID, $OPPONENT_ID, $WIGO, $OPGO, $YEAR, '$ROUND');")"

done
