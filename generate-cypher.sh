#!/bin/bash

function printCypherQueries() {
  ANIMAL=$1
  GROUP=$2

  echo "MERGE(:Animals {name:'${ANIMAL}'});"
  echo "MERGE(:Group {name:'${GROUP}'});"
  echo "MATCH(a:Animals {name:'${ANIMAL}'}) "
  echo "MATCH(g:Group {name:'${GROUP}'}) "
  echo "MERGE (g) -[:OF]-> (a);"
}

echo "MATCH (x:Animals) DETACH DELETE x;"
echo "MATCH (x:Group) DETACH DELETE x;"
echo

cat input.txt |
while read -r LINE
do
	printCypherQueries $LINE && echo
done
