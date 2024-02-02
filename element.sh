#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN() {

  if [[ -z $1 ]]
  then 
    echo "Please provide an element as an argument."
    exit 0
  fi

  if [[ $1 == 1 || $1 == 'H' || $1 == 'Hydrogen' ]]
  then
    echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
    exit 0
  fi

  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'"))
  else
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1"))
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT types.type FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$ATOMIC_NUMBER")

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi 

}

MAIN $1
