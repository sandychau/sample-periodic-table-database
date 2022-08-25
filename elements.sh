#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ELEMENT=$1
# if no arg is given
if [[ -z $ELEMENT ]]
then
  echo 'Please provide an element as an argument.'
  exit
fi

# if the arg is a number
if [[ $ELEMENT =~ ^[0-9]+$ ]]
then
  RESULTS=$($PSQL "SELECT e.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements as e, properties as p, types as t WHERE e.atomic_number=p.atomic_number AND p.type_id=t.type_id AND e.atomic_number=$ELEMENT")
else
  RESULTS=$($PSQL "SELECT e.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements as e, properties as p, types as t WHERE e.atomic_number=p.atomic_number AND p.type_id=t.type_id AND (NAME='$ELEMENT' OR SYMBOL='$ELEMENT')")
fi

if [[ -z $RESULTS ]]
then
  echo "I could not find that element in the database."
else
  echo $RESULTS | while IFS=' | ' read NUMBER SYMBOL NAME TYPE MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
