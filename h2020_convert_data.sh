#!/bin/bash

# clean the projects file
csvclean -d ";" "h2020_projects.csv"
CSVOUT="h2020_projects_out.csv"
DATE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(Date)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
QUOTE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(title)|(objective)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
./format-csv.py -dc $DATE_COLS -qc $QUOTE_COLS $CSVOUT

# clean the organizations file
csvclean -d ";" "h2020_organizations.csv"
CSVOUT="h2020_organizations_out.csv"
DATE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(Date)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
QUOTE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(geolocation)|(organizationURL)|(contactForm)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
./format-csv.py -dc $DATE_COLS -qc $QUOTE_COLS $CSVOUT

# clean the topics file
csvclean -d ";" "h2020_topics.csv"
CSVOUT="h2020_topics_out.csv"
QUOTE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(title)|(topic)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
./format-csv.py -qc $QUOTE_COLS $CSVOUT

# clean the legalBasis file
csvclean -d ";" "h2020_legalBasis.csv"
CSVOUT="h2020_legalBasis_out.csv"
QUOTE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(title)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
./format-csv.py -qc $QUOTE_COLS $CSVOUT

# clean the euro science vocabular file
csvclean -d ";" "h2020_euroSciVoc.csv"
CSVOUT="h2020_euroSciVoc_out.csv"
QUOTE_COLS=$(csvcut -n $CSVOUT | awk '$2 ~ /(euroSciVocTitle)|(euroSciVocPath)/ {print($1-1)}' | sed -z 's/\n/,/g;s/,$/\n/' )
./format-csv.py -qc $QUOTE_COLS $CSVOUT

