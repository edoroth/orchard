import matplotlib
import matplotlib.pyplot as plt
import numpy as np

# Formatting

font = { 
        'size'   : 15}

d1 = 1000
d = 470000 # number of words in webster

matplotlib.rc('font', **font)

# Data for plotting
t = np.arange(10**4, 10**9, 1000)
ldp_sig = [min(np.sqrt(ti*d),ti) for ti in t]
gdp_sig = t

ldp_less = [max(1,0.25 * ti / np.sqrt(d)) for ti in t]
gdp_less = 0.25 * t

fig, ax = plt.subplots()
ax.plot(t, ldp_less, label="LDP - 25%")
ax.plot(t, gdp_less, label="GDP  - 25% ")
ax.plot(t, ldp_sig, label="LDP - 100%")
ax.plot(t, gdp_sig, label="GDP - 100%")
ax.legend()

ax.set(xlabel='Number of users (N)', ylabel='Number of users required to corrupt',
       title='LDP vs. GDP Poisoning Attack')
#ax.grid()
plt.yscale("log")
plt.xscale("log")
plt.xticks([pow(10,i) for i in range(4,10)])
plt.yticks([pow(10,i) for i in range(0,10)])

#fig.subplots_adjust(left=None, bottom=None, right=None, wspace=None, hspace=0.1)
fig.subplots_adjust(bottom=0.2)
fig.savefig("ldpAttack.png")
plt.show()
