# A simple script for finding a lgP-bit prime, p, such that p-1 is divisible by 2**(lgM + 1)

import sympy
import random 

lgP = 128

p = 4

lgM = 50

while (not sympy.isprime(p)):
  p = random.randrange(2**(lgP-lgM-2), 2**(lgP-lgM-1)-1) * 2**(lgM+1) +1

print p
