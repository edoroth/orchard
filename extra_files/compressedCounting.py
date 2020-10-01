import numpy as np
import scipy.stats
from scipy.stats import entropy

from math import log, e

import timeit

def entropy1(labels, base=None):
  value,counts = np.unique(labels, return_counts=True)
  return entropy(counts, base=base)

def entropy2(labels, base=None):
  """ Computes entropy of label distribution. """

  n_labels = len(labels)

  if n_labels <= 1:
    return 0

  value,counts = np.unique(labels, return_counts=True)
  probs = counts / float(n_labels)
  n_classes = np.count_nonzero(probs)

  if n_classes <= 1:
    return 0

  ent = 0.

  # Compute entropy
  base = e if base is None else base
  for i in probs:
    ent -= i * log(i, base)

  return ent

'''def entropy3(labels, base=None):
  vc = pd.Series(labels).value_counts(normalize=True, sort=False)
  base = e if base is None else base
  return -(vc * np.log(vc)/np.log(base)).sum()'''

def entropy4(labels, base=None):
  value,counts = np.unique(labels, return_counts=True)
  norm_counts = counts / float(counts.sum())
  base = e if base is None else base
  return -(norm_counts * np.log(norm_counts)/np.log(base)).sum()


def scipyEntropy(A):
	value, counts = np.unique(A, return_counts=True)
	return entropy(counts)

def shannonEntropy(A):
	F_1 = 0
	H = 0
	for i in range(len(A)):
		F_1 += A[i]
	for i in range(len(A)):
		frac = float(A[i])/F_1
		#print frac
		if (frac != 0):
			H -= frac * np.log2(frac)
	return H
		

def compressedCounting(A, alpha, k, m="renyi"):
	r = np.random.beta(alpha, b=1, size=(len(A), k))
	F_1 = 0
	X = np.zeros(k)
	for i in range(len(A)):
		F_1 += A[i]
		for j in range(k):
			X[j] += r[i][j]*A[i]	

	delta = 1 - alpha
	temp  = 0 
	for i in range(k):
		temp += X[j]**(-1*alpha/delta)
	F_alpha = 1/(delta**delta) * (k/temp)**delta

	H_est = 0
	if m == "renyi":
		H_est = 1/(1-alpha) * np.log2(F_alpha/F_1**alpha)
	elif m == "tsallis":
		H_est = 1/(alpha-1) * (1-F_alpha/F_1**alpha)
		
	return -1 * H_est

def logmean_estimator(A, k):
	y = np.zeros(k)
	r = scipy.stats.levy_stable.rvs(1, -1, size=(len(A), k))

	Y = 0
	for i in range(len(A)):
		Y += A[i]
		for j in range(k):
			y[j] += r[i][j]*A[i]	

	temp  = 0
	for j in range(k):
		temp += np.exp(y[j]/Y)
	H_est  = -1 * np.log (temp/k)

	return H_est

def norm_est(A):
	m = len(A) 
	p = np.random.randint(m)
	r = 0
	for i in range(m):
		if A[i] == A[p]:
			r += 1
	#print 'r (must be >= 1): %d' % r

	if r != 1:
		X = m * (r * np.log(r) - (r-1) * np.log(r-1))
	else:
		X = m * (r * np.log(r))

	H_est = np.log(m) - X / m

	return H_est


d = 5 #num of possible values 10^d
v = 5 # number of participants 10^v

#lk = [100, 500, 1000, 10000, 100000]
#numTrials = len(lk)
#for i in range(numTrials):
for d in range(6, 9):
	for v in range(5,9):
		#k = lk[i]
		alpha = 0.9
		p = np.random.rand(5)
		p /= sum(p)
		A = []
		for j in range(len(p)):
			t = np.random.rand(1)
			#A += [p[j]] * int(10**d * p[j])
			A += [t] * int(10**d * p[j])
		A = np.random.randint(10**d, size=10**v)
		#print A
		print 'Size: %d' % 10**v
		print 'Range: %d' % 10**d
		#print 'Alpha: %f' % alpha
		#print 'entropy1: %f' % entropy1(A)
		print 'entropy2: %f' % entropy2(A)
		print 'Norm estimation: %f' % norm_est(A)
		#print 'entropy3: %f' % entropy3(A)
		#print 'entropy4: %f' % entropy4(A)
		#print 'Shannon entropy: %f' % shannonEntropy(A)
		#print 'Scipy entropy: %f' % scipyEntropy(A)
		for k in [3, 10, 100]:
			print 'k: %d' % k
			print '\tLog-Mean estimation:  %f' % logmean_estimator(A, k)
			for alpha in [0.9, 0.95]:
				print '\talpha: %f ' % alpha
				print '\t\tEstimated renyi entropy: %f' % compressedCounting(A, alpha, k, "renyi") 
				print '\t\tEstimated tsallis entropy: %f' % compressedCounting(A, alpha, k, "tsallis") 

		
		print '---------------------------'


