import numpy as np
N = 1000000
ldp = []
gdp = []
s = np.random.laplace(0,1,N)
val = sum(s) # all of the random noise
ldp.append(val)
gdp.append(val)
print gdp
print ldp
