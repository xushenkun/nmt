# -*- coding: utf-8 -*-
#! /usr/bin/env python

from __future__ import print_function
import sys
from collections import Counter

c = Counter()

if len(sys.argv) > 1:
    min_freq = int(sys.argv[1])
else:
    min_freq = 3 #default

for line in sys.stdin:
    for word in line.split():
        c[word] += 1

for key,f in sorted(c.items(), key=lambda x: x[1], reverse=True):
    if f >= min_freq:
        print(key)
