#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner"  && $OPPONENT != "opponent" ]]
  then
    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert data
      INSERT_INTO_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $INSERT_INTO_TEAM
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      echo $TEAM_ID
    fi
    if [[ -z $TEAM_ID2 ]]
    then
      #insertion
      INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $INSERT_NAME
      #new team id
      TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      echo $TEAM_ID2
    fi
    # insert into games
    INSERT_DATA_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID, $TEAM_ID2, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo $INSERT_DATA_GAMES
  fi
done