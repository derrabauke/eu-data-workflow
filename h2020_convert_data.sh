#!/bin/bash

# clean the projects file
csvclean -d ";" "h2020_projects.csv"
CSVOUT="h2020_projects_out.csv"
DATE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(Date)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
QUOTE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(title)|(objective)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
./format-date.py $CSVOUT $DATE_COLS $QUOTE_COLS

