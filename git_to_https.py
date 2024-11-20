#! /usr/bin/env python3
import sys

if (len(sys.argv) != 2):
    print(f'Argument error\n Usage {sys.argv[0]} <git_url>')
    exit(1)

url = sys.argv[1]

if 'azure' in url:
    # url = git@ssh.dev.azure.com:v3/kaaththaadi/PEN01/source_code_fpga
    # https://dev.azure.com/kaaththaadi/PEN01/_git/source_code_fpga
    tmp = url.replace('git@ssh.', 'https://')
    tmp = tmp.replace(':v3', '')
    inx = tmp.rfind('/')
    new_url = tmp[:inx] + '/_git' + tmp[inx:]
elif 'github' in url:
    # git@github.com:ravitharan/hdl.git
    # https://github.com/ravitharan/hdl.git
    tmp = url.replace(':', '/')
    new_url = tmp.replace('git@', 'https://')

print(new_url)


