#! /usr/bin/env python3

import os
import subprocess

home_path = os.path.expanduser("~")

link_dotfiles = [ "vimrc", "inputrc", "screenrc" ]

include_dotfile = [ "gitconfig", "bashrc" ]

include_message = [
f"""

[include]
    path = {home_path}/utility/gitconfig

""",
f"""

if [ -f {home_path}/utility/bashrc ]; then
    source {home_path}/utility/bashrc
fi

"""
]



def issue_command(command):
    cp = subprocess.run(command,
                        universal_newlines=True,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE)

    if cp.returncode != 0:
        return (False, cp.stderr)
    else: 
        return (True, cp.stdout)

def utility_dot_included(home, dotfile):
    utility_dotfile = f"{home}/utility/{dotfile}"
    dst = f'{home}/.{dotfile}'
    included = False
    try:
        with open(dst, "r") as file_in:
            for line in file_in:
                if utility_dotfile in line:
                    included = True
                    break
    except FileNotFoundError:
        pass

    return included



if __name__ == "__main__":
    if os.geteuid() == 0:
       print("ERROR: This script cannot be run as root")
       exit(1)


    for dotfile in link_dotfiles:
        dst = f'{home_path}/.{dotfile}'
        if not os.path.isfile(dst):
            issue_command(['ln', '-s', f'{home_path}/utility/{dotfile}', dst])
        else:
            print(f"file {dst} already exist")


    for i in range(len(include_dotfile)):
        dst = f'{home_path}/.{include_dotfile[i]}'
        if not utility_dot_included(home_path, include_dotfile[i]):
            with open(dst, "a") as file_in:
                file_in.write(include_message[i])
        else:
            print(f"file {dst} already included")


    issue_command(['mkdir', '-p', f'{home_path}/.vim/colors'])
    (ret, msg) = issue_command(['cp', '-vu', 'greens.vim', f'{home_path}/.vim/colors/'])
    print(msg)



