#!/usr/bin/env python3

import sys
import os
import pandas as pd

if len(sys.argv) < 3 :
  raise("Missing columns argument.")

if len(sys.argv) < 2 :
  raise("Missing file path.")

def customParser(date):
  res = pd.to_datetime(date, infer_datetime_format=True, dayfirst=True)
  return res


with open(sys.argv[1], "r", newline="") as f, open(os.path.splitext(sys.argv[1])[0] + "_date_formatted.csv", "w", newline="") as out:
  # convert string of column indices to list of integers
  columns = [int(i) for i in sys.argv[2].split(",")]
  # parse dates in given columns
  csv = pd.read_csv(f, quotechar='"', parse_dates=columns, date_parser=customParser)
  # write output
  csv.to_csv(out, quotechar="'", index=False)