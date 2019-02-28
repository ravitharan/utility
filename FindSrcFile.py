#! /usr/bin/env python3

import sys
import filecmp
import os
import os.path
import subprocess

if len(sys.argv) != 2:
  print("Usage: {} <build_folder>".format(sys.argv[0]))
  sys.exit(1)

build_folder = sys.argv[1]

for line in sys.stdin:
  line = line.strip()
  if line.find(build_folder) < 0: # non build_folder files
    print(line)
    pass
  else:
    base_file = os.path.basename(line)
    cmd = ['find', '-name', base_file]
    files = subprocess.check_output(cmd).splitlines()
    matched_files = []
    for file in files:
      file = file.decode("utf-8")
      if (file.find(build_folder) < 0): # non build_folder files
        if filecmp.cmp(line, file, shallow=False):
          matched_files.append(file)
    if (len(matched_files) == 0):
      print()
      print(line)
      print()
    elif (len(matched_files) == 1):
      print(matched_files[0])
    else:
      print()
      for file in matched_files:
        print(file)
      print()
