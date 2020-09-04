import matplotlib
import matplotlib.pyplot as plt
import numpy as np

# Formatting

font = { 
        'size'   : 15}

matplotlib.rc('font', **font)

# Data for plotting
t = np.arange(0, 10**9, 1000)
ldp = np.sqrt(t)
gdp = np.log(t/0.01)


fig, ax = plt.subplots()
ax.plot(t, ldp)
ax.plot(t, gdp)

ax.set(xlabel='Number of users (N)', ylabel='Error in Count',
       title='Comparison of LDP and GDP')
#ax.grid()
plt.yscale("log")
plt.xscale("log")
plt.xticks([pow(10,i) for i in range(3,10)])
plt.yticks([pow(10,i) for i in range(1,5)])

#fig.subplots_adjust(left=None, bottom=None, right=None, wspace=None, hspace=0.1)
fig.subplots_adjust(bottom=0.2)
fig.savefig("dpComparison.png")
plt.show()
