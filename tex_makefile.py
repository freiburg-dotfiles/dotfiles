#!/usr/bin/env/python
# -*- coding: iso-8859-15 -*-
import sys


def write_texmakefile(filename):
    with open("./Makefile", 'w') as f:
        maketxt = ("all:\n\tpdflatex {0}\n\tpdflatex {0}\n" +
                   "clean:\n\trm *.aux *.log *.out")
        f.write(maketxt.format(filename))


def main():
    filename = sys.argv[1]
    write_texmakefile(filename)

if __name__ == "__main__":
    main()
