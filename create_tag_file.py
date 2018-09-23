#! /usr/bin/env python3

import subprocess
import argparse
import tempfile

class fun_list:
  file_name_size = 0
  def __init__(self, file_name):
    self.file = file_name
    self.entries = []
    self.size = 0
    fun_list.file_name_size += len(file_name)

  def __eq__(self, other):
    return (self.file == other)

  def add_entry(self, line, fun_name):
    self.entries.append([line, fun_name])
    self.size += len(line) + len(fun_name) + 2 # "line fun_name\n"

args = None

def parse_args():
  parser = argparse.ArgumentParser(description=__doc__,
      formatter_class=argparse.RawTextHelpFormatter)

  parser.add_argument('project_file')
  parser.add_argument('-a', '-all', action="store_true",
                    help="capture all tags type, not just functions tags")

  global args
  args = parser.parse_args()

  project_file = args.project_file

  if (project_file.find("files_") < 0) or (project_file.find(".txt") < 0):
    print("Project file \"{}\" is not in \"files_xxx.txt\" format.".format(project_file))
    exit(1)

  return args.project_file


def update_list(list_fun_list, file_name, line_num, func):
  try:
    i = list_fun_list.index(file_name)
  except:
    a = fun_list(file_name)
    list_fun_list.append(a)
    i = len(list_fun_list) - 1

  list_fun_list[i].add_entry(line_num, func)

def cmp_by_line(item):
  return int(item[0])

def cmp_by_file(item):
  return item.file


def tag_to_func(tag_file, list_fun_list, all_tags_flag):
  """ Create func data from tag file"""
  with open(tag_file) as f:
    if all_tags_flag:
      for line in f:
        elements = line.strip().split('\t')
        if (len(elements) >= 4):
          elements[2] = elements[2][:-2]
          update_list(list_fun_list, elements[1], elements[2], elements[0])
    else: # Only functions 
      for line in f:
        elements = line.strip().split('\t')
        if (len(elements) >= 4) and elements[3] is 'f':
          elements[2] = elements[2][:-2]
          update_list(list_fun_list, elements[1], elements[2], elements[0])
 
def print_func_data(list_fun_list, file_output):
  with open(file_output, "w") as f:
    #Integer width in output is 8
    offset = 0
    num_files = len(list_fun_list)
    f.write("{0:8d}\n".format(num_files))
    offset += 8 + 1

    #file field is as follows
    #file1 offset num_lines
    #file2 offset num_lines
    #......

    offset += fun_list.file_name_size + num_files * (8 + 8 + 2)

    for afile in list_fun_list:
      f.write("{0} {1:8d}{2:8d}\n".format(afile.file, offset, len(afile.entries)))
      offset += afile.size

    for afile in list_fun_list:
      for entry in afile.entries:
        f.write("{} {}\n".format(entry[0], entry[1]))


def main():

  project_file = parse_args()

  tag_file = project_file.replace("files_", "tags_").replace(".txt", "")
  #Run ctags
  print("Creating tags...")
  subprocess.check_call(['ctags', '-n', '-L', project_file, '-f', tag_file])
  list_fun_list = []

  print("Organizing tags...")
  tag_to_func(tag_file, list_fun_list, args.a)

  for item in list_fun_list:
    item.entries.sort(key=cmp_by_line)

  list_fun_list.sort(key=cmp_by_file)

  func_file = tag_file.replace("tags_", "func_")

  print_func_data(list_fun_list, func_file)


if __name__ == "__main__":
    main()
