#!/bin/python

import sys
import random

n1 = int(sys.argv[1])  # Superset size
n2 = int(sys.argv[2])  # Subset size

full = list(range(n1))
sub = random.sample(full, n2)
sub.sort()

for i in range(n2):
  print sub[i]
