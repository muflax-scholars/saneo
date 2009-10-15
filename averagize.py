#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

import sys

def main():
    freq = {}
    for f in sys.argv[1:]:
        total = 0
        lf = []
        for line in open(f):
            e = line.strip().split(" ")
            lf.append(e)
            total += int(e[1])
        for e in lf:
            freq[e[0]] = freq.get(e[0], 0) + int(e[1]) / total
    l = [(freq[x] / (len(sys.argv)-1), x) for x in freq]
    l.sort()
    for e in l:
        print("%0.3f - %s" % (e[0], e[1])) 
        

if __name__ == "__main__":
    main()

