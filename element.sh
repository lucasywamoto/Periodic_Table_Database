#!/bin/bash



PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

VALIDATE_INPUT() {
  # Check if there's no argument
  if [[ -z $INPUT ]]; then
    echo "Please provide an element as an argument."
  # Check if the argument is a number
  elif [[ $INPUT =~ ^[0-9]+$ ]]; then
      ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT")
      OUTPUT_DATA
  # Check if the argument is a 2-letter or shorter string
  elif [[ $INPUT =~ ^[A-Za-z]{1,2}$ ]]; then
      ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT'")
      OUTPUT_DATA
  # If it's not a number or 2-letter or shorter string, it's a more than two letters string
  else
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$INPUT'")
    OUTPUT_DATA
  fi
}

OUTPUT_DATA() {
  if [[ -z $ELEMENT_ATOMIC_NUMBER ]]; then
    echo "I could not find that element in the database."
  else
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$ELEMENT_TYPE_ID")
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_BOLING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
    echo "The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOLING_POINT celsius."
  fi
}

VALIDATE_INPUT
