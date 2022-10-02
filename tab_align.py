#! /usr/bin/env python3

import sys

TAB_LEN = 4


def get_file_contents(in_stream):
    contents    = []
    for line in in_stream:
        words = line.strip().split()
        contents.append(words)
    return contents

def max_word_length(contents):
    max_words_len    = []

    for words in contents:
        for i, word in enumerate(words):

            # Make word length in multiple of TAB_LEN
            word_len = len(word)
            if (word_len % TAB_LEN) == 0:
                word_len += TAB_LEN
            else:
                word_len = ((word_len + TAB_LEN-1) // TAB_LEN) * TAB_LEN;

            if (i < len(max_words_len)):
                if (max_words_len[i] < word_len):
                    max_words_len[i] = word_len
            else:
                max_words_len.append(word_len)

    return max_words_len

contents        = get_file_contents(sys.stdin)
max_words_len   = max_word_length(contents)

for words in contents:
    for i, word in enumerate(words):
        space = (max_words_len[i] - len(word)) * ' '
        print(f'{word}{space}', end='')
    print()

