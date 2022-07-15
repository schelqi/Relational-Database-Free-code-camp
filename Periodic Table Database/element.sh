#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else

ELEMENT=$1

#FIND IF THE ATOMIC NUMBER EXIST

if [[ $ELEMENT =~ [0-9]+ ]]
then
  FIND_ELEMENT_BY_ATOMIC_NUMBER=$($PSQL "SELECT symbol, name FROM elements WHERE atomic_number=$ELEMENT")
  
  if [[ ! -z $FIND_ELEMENT_BY_ATOMIC_NUMBER ]]
  then
   ELEMENT_ATOMIC_NUMBER=$ELEMENT
  fi
# The argument is not a number
elif [[ ! -z $ELEMENT ]] 
then
  FIND_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT' OR symbol='$ELEMENT'")
  
  if [[ ! -z $FIND_ELEMENT ]]
  then
    ELEMENT_ATOMIC_NUMBER=$FIND_ELEMENT
  fi

fi


if [[ ! -z $ELEMENT_ATOMIC_NUMBER ]]
then
 #GET ELement PROPERTIES
  ELEMENT_PROPERTIES=$($PSQL "SELECT symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number)
                                INNER JOIN types USING(type_id) WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
  echo "$ELEMENT_PROPERTIES"  | while read SYMBOL BAR ELEMENT_NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE 
  do
    OUTPUT="The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    echo  $OUTPUT
  done
# IF the argument dosen't fit with any element in the database
else
  echo "I could not find that element in the database."
fi

fi
