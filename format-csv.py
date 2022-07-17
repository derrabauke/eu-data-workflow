#!/usr/bin/env python3

import sys
import os
import pandas as pd
import csv as CSV_LIB
import re
import argparse

parser = argparse.ArgumentParser(description="A helper for parsing wildly formatted csv data.")
parser.add_argument("filepath", help="the path to the csv file")
parser.add_argument("-dc", "--date-columns", dest="date_columns", help="a comma separated list (string) of date column indices")
parser.add_argument("-qc", "--quote-columns", dest="quote_columns", help="a comma separated list (string) of columns where quoting characters may occure")

args = parser.parse_args()

SINGLE_QUOTES = re.compile("(?<!,)(')(?!,)")
DOUBLE_QUOTES = re.compile('(?<!,)(")(?!,)')
BACKSLASHES = re.compile("\\\\")

def customParser(date):
  return pd.to_datetime(date, infer_datetime_format=True, dayfirst=True)

def convertQuotes(value):
  return re.sub(DOUBLE_QUOTES, "", re.sub(SINGLE_QUOTES, "", re.sub(BACKSLASHES, "/", value)))

with open(args.filepath, "r", newline="") as f, open(os.path.splitext(args.filepath)[0] + "_formatted.csv", "w", newline="") as out:
  date_columns = []
  quote_trim_dict = {}

  # convert string of date column indices to list of integers
  if args.date_columns and len(args.date_columns.strip()) > 0:
    date_columns = [int(i) for i in args.date_columns.split(",")]
  
  # collect a dict of columes which need special attention for quote character trimming
  if args.quote_columns and len(args.quote_columns) > 0:
    quote_trim_dict = {int(i):convertQuotes for i in args.quote_columns.split(",")}

  # parse incoming columns
  csv = pd.read_csv(f, converters=quote_trim_dict, quotechar='"', parse_dates=date_columns, date_parser=customParser)
  # write output
  csv.to_csv(out, sep=",", quotechar='"', quoting=CSV_LIB.QUOTE_ALL, escapechar="\\", index=False)
