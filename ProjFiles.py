#!/usr/bin/python3
import sys
import re
import pathlib
import argparse

def parse_argument():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--prepend", action="store_true", help="prepend .d file path")
    parser.add_argument("depend_files", nargs="*", help="*.d depend files")
    return parser.parse_args()

def parse_dep_file_list(fin_stream):
    files = []
    for line in fin_stream:
        line = line.rstrip()
        line = re.sub(r'\s+\\$', '', line)
        line = re.sub(r'^.*\.o(bj)*:\s*', '', line)
        line = re.sub(r':$', '', line)
        files.extend(line.split())
    return files

def prepend_d_file_path(d_file, src_files):
    dir_path = pathlib.Path(d_file).parent
    files = []
    for name in src_files:
        if pathlib.Path(name).is_absolute():
            files.append(name)
        else:
            files.append(str(dir_path.joinpath(name).resolve()))
    return files
    

if __name__ == '__main__':
    args = parse_argument()
    depend_files = args.depend_files
    prepend = args.prepend

    if not depend_files:
        files = parse_dep_file_list(sys.stdin)
    else:
        files = []
        for file in depend_files:
            with open(file) as f_in:
                if prepend:
                    base_files = parse_dep_file_list(f_in)
                    src_files = prepend_d_file_path(file, base_files)
                else:
                    src_files = parse_dep_file_list(f_in)
                files.extend(src_files)
    files.sort()
    files = set(files)
    print('\n'.join(files))
