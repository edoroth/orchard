''' SHOULD RUN "python kmeansData.py >> kmeansOut" '''


import numpy as np
import matplotlib
import matplotlib.pyplot as plt

ITERS = 5
NUM_CLUSTERS = 5
RANGE = 200
CLIP_RANGE = 400
global TARGET
global BENIGN_USERS
global ATTACKERS

class User:
	def __init__(self, id, x, y):
		self.id = id
		self.x = x
		self.y = y

	def send_update(self, clusters, t, LDP, defense):
		if self.id == 'g':
			# Will be an index
			cluster_idx = compute_closest(clusters, self.x, self.y)
			# only have to worry about this if a good guy
			if (LDP == True):
				return (cluster_idx, self.x + np.random.laplace(0, LAP), self.y + np.random.laplace(0, LAP))
			else:
				return (cluster_idx, self.x, self.y)

		else: # if a bad guy!
			
			if defense: #cant do anything right now except for send malicious target (potentially without local noise to help out)
			# assuming no prior knowledge about distribution
				cluster_idx = compute_closest(clusters, self.x, self.y, malicious=False)
				return (cluster_idx, self.x, self.y) 

			else: # can do more sophisticated attack
				if t != (ITERS - 1):
					# confuse with randomness
					#rand_x = np.random.randint(RANGE)
					#rand_y = np.random.randint(RANGE)
					#cluster_idx = compute_closest(clusters, rand_x, rand_y, malicious=False)
					
					cluster_idx = compute_closest(clusters,self.x,self.y, malicious=False)
					return (cluster_idx, self.x, self.y)
					#return (cluster_idx, 0, 0) # Send 0's to make attack easier 
					
				else:
					cluster_idx = compute_closest(clusters, self.x, self.y, malicious=False)
					# Calculate a point which will relocate this cluster to the target
					maliciousInput = compute_mal_point(clusters[cluster_idx], self.x, self.y, LDP)
					global TARGET
					TARGET  = cluster_idx
					#print 'Mwahaha --> %d' % TARGET
					
					#print '%d attackers, attacking with (%d, %d)' % (ATTACKERS, maliciousInput[0], maliciousInput[1])
					#print 'Target is (%d, %d)' % (self.x, self.y)

					return (cluster_idx, maliciousInput[0], maliciousInput[1])


def compute_mal_point(cluster, target_x, target_y, LDP):
	estimate = BENIGN_USERS/NUM_CLUSTERS # number of users who choose this cluster
	estimated_sum_x = cluster[0] * (estimate+ATTACKERS) - ATTACKERS * target_x
	estimated_sum_y = cluster[1] * (estimate+ATTACKERS) - ATTACKERS * target_y
	new_x = ((estimate+ATTACKERS) * target_x - estimated_sum_x)/(ATTACKERS)
	new_y = ((estimate+ATTACKERS) * target_y - estimated_sum_y)/(ATTACKERS)
	# Clip the result
	if CLIP:
		if LDP: #2x the range to allow for for noise
			return (min(max(0,new_x),2*CLIP_RANGE-1), min(max(0,new_y),2*CLIP_RANGE-1))	
		else:
			return (min(max(0,new_x),CLIP_RANGE-1), min(max(0,new_y),CLIP_RANGE-1))	
	# Non-clipped version	
	else:
		return (new_x, new_y)

# BENIGN FUNCTION
def compute_closest(clusters, x, y, malicious=False):

	min_dist = (clusters[0][0] - x)**2 + (clusters[0][1] - y)**2
	min_idx = 0
	i = 0
	for c in clusters:
		cur_dist = (c[0] - x)**2 + (c[1] - y)**2
		if (cur_dist < min_dist and malicious == False):
			min_dist = cur_dist
			min_idx = i
		# Compute farthest for malicious
		elif (cur_dist > min_dist and malicious == True):
			min_dist = cur_dist
			min_idx = i
		i += 1
	
	return min_idx

def run_protocol(users_list, maliciousTarget, LDP=False, defense=False):
	initial_clusters = []
	for i in range(NUM_CLUSTERS):
		if RANDOM_INIT==False:
			initial_clusters.append([RANGE/NUM_CLUSTERS*i, RANGE/NUM_CLUSTERS*i])
		else:
			initial_clusters.append([np.random.randint(RANGE), np.random.randint(RANGE)])

	#print initial_clusters

	broadcast_clusters = initial_clusters
		
	for t in range(ITERS):
		# rounds of updates
		updated_clusters = [[0,0] for i in range(NUM_CLUSTERS)]
		cluster_counts = [0 for i in range(NUM_CLUSTERS)]
		for u in users_list:
			update = u.send_update(broadcast_clusters, t, LDP, defense)
			
			updated_clusters[update[0]][0] += update[1] # x coord
			updated_clusters[update[0]][1] += update[2] # y coord
			cluster_counts[update[0]] += 1

		for i in range(NUM_CLUSTERS):
			for j in range(2):
				if cluster_counts[i] != 0:
					if (LDP == False): # apply GDP!
						updated_clusters[i][j] += np.random.laplace(0, LAP)
					updated_clusters[i][j] /= cluster_counts[i]
				broadcast_clusters[i][j] = updated_clusters[i][j]
                #l2 norm
		#attackError = abs(updated_clusters[TARGET][0] - maliciousTarget[0])**2/float(RANGE**2) + \
		#    abs(updated_clusters[TARGET][1] - maliciousTarget[1])**2/float(RANGE**2)
                #l1 norm
		attackError = abs(updated_clusters[TARGET][0] - maliciousTarget[0])/float(RANGE) + \
		    abs(updated_clusters[TARGET][1] - maliciousTarget[1])/float(RANGE)

	return attackError/2



def main(exp, rand, eps):
	global TARGET
	TARGET = 0 # initialization
	global BENIGN_USERS
	BENIGN_USERS=10**exp
	global ATTACKERS
	ATTACKERS=0
	global CLIP
	CLIP = False
        global RANDOM_INIT
        RANDOM_INIT=rand
	global EPSILON
	EPSILON=eps
	global LAP
	LAP = 1/EPSILON if EPSILON != 0 else 0
        global EXP
        EXP=exp

	 # FIXING THE DATA OF ALL USERS
        users_list = []
	for i in range(BENIGN_USERS):
		users_list.append(User('g', np.random.randint(RANGE), np.random.randint(RANGE)))

	maliciousTarget = (np.random.randint(RANGE), np.random.randint(RANGE))

	ff = {} # GDP No Defense
	ff_clip = {} # GDP No Defense and clipping
	ft = {} # GDP with defense
	tf = {} # LDP No defense
	tf_clip = {} # LDP No defense and clipping
	global avg
	avg = 5

	attackerOptions = [10**i for i in range(EXP+1)]
	#attackerOptions = [1, 10, 100, 1000, 10**4]
	#attackerOptions = [1, 10, 100, 1000, 10**4, 10**5]

	for i in range(len(attackerOptions)):
			# Adding new attackers first
			newAttackers = attackerOptions[i] - ATTACKERS
			ATTACKERS = attackerOptions[i]
			for j in range(newAttackers):	
				users_list.append(User('b', maliciousTarget[0], maliciousTarget[1]))

			# Do multiple trials with different initializations / laplace randomness
			for k in range(avg):

				CLIP = False
				err = run_protocol(users_list, maliciousTarget, LDP = False, defense=False)
				if ATTACKERS in ff:
						ff[ATTACKERS].append(err)
				else:
						ff[ATTACKERS] = [err]

				CLIP = True
				err = run_protocol(users_list, maliciousTarget, LDP = False, defense=False)
				if ATTACKERS in ff_clip:
						ff_clip[ATTACKERS].append(err)
				else:
						ff_clip[ATTACKERS] = [err]
				
				CLIP = False
				err = run_protocol(users_list,  maliciousTarget, LDP = False, defense=True)
				if ATTACKERS in ft:
						ft[ATTACKERS].append(err)
				else:
						ft[ATTACKERS] = [err]
				
				CLIP = False
				err = run_protocol(users_list,  maliciousTarget, LDP = True, defense=False)
				if ATTACKERS in tf:
						tf[ATTACKERS].append(err)
				else:
						tf[ATTACKERS] = [err]

				CLIP = True
				err = run_protocol(users_list,  maliciousTarget, LDP = True, defense=False)
				if ATTACKERS in tf_clip:
						tf_clip[ATTACKERS].append(err)
				else:
						tf_clip[ATTACKERS] = [err]


	#print ff, ff_clip, ft, tf,tf_clip
        print exp, rand, eps
	print 'ff:'
	print ff
        print 'ff_clip:'
        print ff_clip
        print 'ft:'
        print ft
        print 'tf:'
        print tf
        print 'tf_clip:'
        print tf_clip


main(3, False, 0)	
main(6, False, 0)	
main(6, False, 0.1)
main(6, True, 0)	
main(6, True, 0.1)
