#! /bin/bash

: '	Previous:

mkdir periodic_table

cd periodic_table

git init 

git branch -m main

touch README.md 

git add README.md 

git commit -m "Initial commit"

touch info1.txt

git add info1.txt 

git commit -m "test: second commit"

echo "Text to the README file" > README.md

git add README.md 

git commit -m "test: third commit"

echo "There is no info to add, just to make commits" > info1.txt 

git add info1.txt 

git commit -m "test: fourth commit"

echo ". More info so I can reach the fifth commit. Bye" > info1.txt 

git add info1.txt 

git commit -m "test: fifth commit"

touch element.sh

git add element.sh 

git commit -m "test: sixth commit"

chmod +x element.sh

./element.sh

'

#chmod +x element.sh

#psql --username=freecodecamp --dbname=periodic_table -c "SQL QUERY HERE"
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SELECT_ELEMENT="SELECT * FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON types.type_id=properties.type_id WHERE"

ELEMENT_SELECTED=$1

if [ -z "$ELEMENT_SELECTED" ]; 
then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ "$ELEMENT_SELECTED" =~ ^[0-9]+$ ]]; 
then
	ELEMENT=$($PSQL "$SELECT_ELEMENT elements.atomic_number=$ELEMENT_SELECTED;")  
else
	ELEMENT=$($PSQL "$SELECT_ELEMENT symbol='$ELEMENT_SELECTED';")
  if [ -z "$ELEMENT" ]; 
  then
    ELEMENT=$($PSQL "$SELECT_ELEMENT name LIKE '%$ELEMENT_SELECTED%';")
  fi
fi
  
  
if [ -z "$ELEMENT" ]; 
then
  echo -e "I could not find that element in the database."
else
  IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID TYPE_ID TYPE_NAME <<< "$ELEMENT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi
  
#git add . && git commit -m "feat: final commit"