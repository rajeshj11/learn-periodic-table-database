#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $1 ]]; then
  ACTOMIC_NUMBER_CONDITION=$( [[ $1 =~ ^[0-9]+$ ]] && echo "or e.atomic_number=$1" || echo "" )
  ELEMENT=$($PSQL "select e.atomic_number,name,symbol,t.type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements e inner join properties p on p.atomic_number = e.atomic_number and (e.name='$1' or e.symbol='$1'$ACTOMIC_NUMBER_CONDITION) inner join types t using(type_id)")
  if [[ -z $ELEMENT ]]; then
    echo "I could not find that element in the database."
    else
    echo "$ELEMENT" | while read -r A_NUM bar NAME bar SYMBOL bar TYPE bar ATOMIC_MASS bar MELT_POINT bar BOIL_POINT
    do
      echo "The element with atomic number $A_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi

