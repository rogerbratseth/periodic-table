#!/bin/bash

# database connection string
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if argument provided
if  [[ ! $1 ]]
then
	# exit with message
	echo Please provide an element as an argument.
	exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
	# argument is a number
	SEARCH_CONDITION="elements.atomic_number=$1"
else
	# argument is not a number
	SEARCH_CONDITION="symbol='$1' OR name='$1'"
fi

	ELEMENT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE  $SEARCH_CONDITION")

if [[ -z $ELEMENT ]]
then
	echo I could not find that element in the database.
	exit
else
	IFS="|"
	echo "$ELEMENT" | while read NUMBER SYMBOL NAME MASS MELT BOIL TYPE
	do
		echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
	done
fi

