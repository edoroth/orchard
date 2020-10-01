import numpy as np

N = 10**9
epsilon = 0.1
loc, scale = 0., 1/epsilon
iters = 10

ldp = []
gdp = []
for j  in range(iters):
    val = sum(np.random.laplace(loc, scale, N)) # all of the random noise
    ldp.append(abs(val))
    gdp.append(abs(np.random.laplace(loc, scale, 1)))

    #if (j % 10 == 0):
    print 'iter %d' % j

print 'N=%d, iters=%d' % (N, iters)
print 'ldp mean: %f' % np.mean(ldp)
print "ldp 5-confidence: [%f %f] " % (np.percentile(ldp, 5), np.percentile(ldp, 95))
print 'ldp 25-confidence: [%f %f]' % (np.percentile(ldp, 25), np.percentile(ldp, 75))
print 'gdp mean: %f' % np.mean(gdp)
print 'gdp 5-confidence: [%f %f]' % (np.percentile(gdp, 5), np.percentile(gdp, 95))
print 'gdp 25-confidence: [%f %f]' % (np.percentile(gdp, 25), np.percentile(gdp, 75))


