#!/usr/bin/env python3

import sys
import os
import pandas as pd
import csv as CSV_LIB
import re

if len(sys.argv) < 3 :
  raise("Missing columns argument.")

if len(sys.argv) < 2 :
  raise("Missing file path.")

SINGLE_QUOTES=re.compile("(?<!,)(')(?!,)")
DOUBLE_QUOTES=re.compile('(?<!,)(")(?!,)')

def customParser(date):
  return pd.to_datetime(date, infer_datetime_format=True, dayfirst=True)

def convertQuotes(value):
  return re.sub(DOUBLE_QUOTES, "", re.sub(SINGLE_QUOTES, "", value))

with open(sys.argv[1], "r", newline="") as f, open(os.path.splitext(sys.argv[1])[0] + "_date_formatted.csv", "w", newline="") as out:
  # convert string of column indices to list of integers
  date_columns = [int(i) for i in sys.argv[2].split(",")]
  
  # collect a dict of columes which need special attention for quote character trimming
  if sys.argv[3]:
    quote_trim_dict = {int(i):convertQuotes for i in sys.argv[3].split(",")}
  else:
    quote_trim_dict = {}

  # parse incoming columns
  csv = pd.read_csv(f, converters=quote_trim_dict, quotechar='"', parse_dates=date_columns, date_parser=customParser)
  # write output
  csv.to_csv(out, sep=",", quotechar='"', quoting=CSV_LIB.QUOTE_ALL, escapechar="\\", index=False)
