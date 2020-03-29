#!/usr/bin/env/python
# -*- coding: iso-8859-15 -*-
import sys


def write_texmakefile(filename):
    with open("./Makefile", 'w') as f:
        maketxt = ("all:\n\tpdflatex {0}\n\tpdflatex {0}\n" +
                   "clean:\n\trm *.aux *.log *.out *.idx\n"+
                   "veryclean:\n\trm *.aux *.log *.out *.idx {1}.pdf\n")
        f.write(maketxt.format(filename, filename[:-4]))


def main():
    filename = sys.argv[1]
    write_texmakefile(filename)

if __name__ == "__main__":
    main()
