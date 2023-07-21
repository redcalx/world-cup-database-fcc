#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    TEAM1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $TEAM1 ]]
    then
        #insert team name
        INSERT_TEAM1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ INSERT_TEAM1_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER
        fi
    fi
  fi
  if [[ $OPPONENT != "opponent" ]]
  then
    #get team_id
    TEAM2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $TEAM2 ]]
    then
        #insert team name 
        INSERT_TEAM2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ INSERT_TEAM2_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $OPPONENT
        fi
    fi
  fi


  if [[ $YEAR != "year" ]]
  then
    # get winner_id from teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get opponent_id from teams
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert into games table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR, $ROUND, $WINNER VS $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done