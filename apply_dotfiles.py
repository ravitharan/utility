#! /usr/bin/env python3

import os
import sys
import subprocess

utility_gitconfig = os.path.join(os.path.expanduser("~"), "utility", "gitconfig")

link_dotfiles = [ "vimrc", "inputrc", "screenrc" ]

include_dotfile = [ "gitconfig", "bashrc" ]

include_message = [
f"""

[include]
    path = {utility_gitconfig.encode('unicode_escape').decode()}

""",
f"""

if [ -f ~/utility/bashrc ]; then
    source ~/utility/bashrc
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

def utility_dot_included(dotfile):
    dst = os.path.join(os.path.expanduser('~'), '.' + dotfile)
    included = False
    try:
        with open(dst, "r") as file_in:
            for line in file_in:
                if 'utility' in line and dotfile in line:
                    included = True
                    break
    except FileNotFoundError:
        pass

    return included



if __name__ == "__main__":
    if sys.platform == 'linux':
        if os.geteuid() == 0:
           print("ERROR: This script cannot be run as root")
           exit(1)


    for dotfile in link_dotfiles:
        dst = os.path.join(os.path.expanduser('~'), '.' + dotfile)
        if not os.path.isfile(dst):
            issue_command(['ln', '-s', f'~/utility/{dotfile}', dst])
        else:
            print(f"file {dst} already exist")


    for i in range(len(include_dotfile)):
        dst = os.path.join(os.path.expanduser('~'), '.' + include_dotfile[i])
        if not utility_dot_included(include_dotfile[i]):
            with open(dst, "a") as file_in:
                file_in.write(include_message[i])
        else:
            print(f"file {dst} already included")


    issue_command(['mkdir', '-p', f'~/.vim/colors'])
    (ret, msg) = issue_command(['cp', '-vu', 'greens.vim', f'~/.vim/colors/'])
    print(msg)



