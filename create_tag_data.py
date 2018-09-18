#!/usr/bin/python3

import sys

class fun_list:
  file_name_size = 0
  def __init__(self, file_name):
    self.file = file_name
    self.entries = []
    self.size = 0
    fun_list.file_name_size += len(file_name)

  def add_entry(self, line, fun_name):
    self.entries.append([line, fun_name])
    self.size += len(line) + len(fun_name) + 2 # "line fun_name\n"

list_fun_list = []
afile = fun_list("")
for line in sys.stdin:
  var = line.split()
  if (var[0] != afile.file):
    if (afile.file != ""):
      list_fun_list.append(afile)
    afile = fun_list(var[0])
  afile.add_entry(var[1], var[2])
list_fun_list.append(afile)

#Integer width in output is 8
offset = 0
num_files = len(list_fun_list)
print("{0:8d}".format(num_files))
offset += 8 + 1

#file field is as follows
#file1 offset num_lines
#file2 offset num_lines
#......

offset += fun_list.file_name_size + num_files * (8 + 8 + 2)

for afile in list_fun_list:
  print(afile.file, "{0:8d}{1:8d}".format(offset, len(afile.entries)))
  offset += afile.size

for afile in list_fun_list:
  for entry in afile.entries:
    print(entry[0], entry[1])

