import numpy as np
import pandas as pd
import scipy.stats
eps = np.finfo(float).eps
from numpy import log2 as log


def logmean_estimator_hash(A, k):
  y = np.zeros(k)
  r = scipy.stats.levy_stable.rvs(1, -1, size=(len(A), k))

  Y = 0
  for i in range(len(A)):
      a = hash(A[i]) % 100 + 1 #avoid being zero
      print 'A is %d' % a
      Y += a
      for j in range(k):
          y[j] += r[i][j]*a  

  temp  = 0
  for j in range(k):
      temp += np.exp(y[j]/Y)
  H_est  = -1 * np.log (temp/k)

  #print 'modified entropy: %f' % H_est
  return H_est

def find_entropy_modified(df):
    Class = df.keys()[-1]   #To make the code generic, changing target variable class name
    entropy = 0
    values = df[Class].unique()
    return logmean_estimator_hash(values, 10)


def find_entropy(df):
    Class = df.keys()[-1]   #To make the code generic, changing target variable class name
    entropy = 0
    values = df[Class].unique()
    for value in values:
        fraction = df[Class].value_counts()[value]/len(df[Class])
        if fraction != 0:
          entropy += -fraction*np.log2(fraction)
    print 'true entropy: %f' % entropy
    return entropy


def find_entropy_attribute_modified(df,attribute):
  Class = df.keys()[-1]   #To make the code generic, changing target variable class name
  target_variables = df[Class].unique()  #This gives all 'Yes' and 'No'
  variables = df[attribute].unique()    #This gives different features in that attribute (like 'Hot','Cold' in Temperature)
  entropy2 = 0
  for target_variable in target_variables:
      #A = df[attribute][df[Class] == target_variable]
      targets = (df[Class] == target_variable) # list of indices?
      print targets
      A = []
      for i in range(len(targets)):
          if (targets[i]==True):
              print i
              A.append(df[attribute][i])
      print A
      print len(A)
      entropy1 = logmean_estimator_hash(A, 10)
      fraction = len(A)/len(df)
      print 'len df is %d' % len(df)
      if fraction != 0:
          entropy2 += -fraction*entropy1

  print 'Modified entropy2: %f' % abs(entropy2)
  return abs(entropy2)
  
def find_entropy_attribute(df,attribute):
  Class = df.keys()[-1]   #To make the code generic, changing target variable class name
  target_variables = df[Class].unique()  #This gives all 'Yes' and 'No'
  variables = df[attribute].unique()    #This gives different features in that attribute (like 'Hot','Cold' in Temperature)
  entropy2 = 0
  for variable in variables:
      entropy = 0
      for target_variable in target_variables:
          num = len(df[attribute][df[attribute]==variable][df[Class] ==target_variable])
          den = len(df[attribute][df[attribute]==variable])
          fraction = num/(den+eps)
          if fraction != 0:
              entropy += -fraction*log(fraction+eps)
      fraction2 = den/len(df)
      #print 'entropy: %f' % entropy
      if fraction != 0:
          entropy2 += -fraction2*entropy

  print 'True entropy2: %f' % abs(entropy2)
  return abs(entropy2)


def find_winner(df):
    Entropy_att = []
    IG = []
    for key in df.keys()[:-1]:
#         Entropy_att.append(find_entropy_attribute(df,key))
        IG.append(find_entropy_modified(df)-find_entropy_attribute_modified(df,key))
        #find_entropy(df) # just to compare!
        find_entropy_attribute(df,key) # just to compare!
    return df.keys()[:-1][np.argmax(IG)]
  
  
def get_subtable(df, node,value):
  return df[df[node] == value].reset_index(drop=True)


def buildTree(df,tree=None): 
    Class = df.keys()[-1]   #To make the code generic, changing target variable class name
    
    #Here we build our decision tree

    #Get attribute with maximum information gain
    node = find_winner(df)
    
    #Get distinct value of that attribute e.g Salary is node and Low,Med and High are values
    attValue = np.unique(df[node])
    
    #Create an empty dictionary to create tree    
    if tree is None:                    
        tree={}
        tree[node] = {}
    
   #We make loop to construct a tree by calling this function recursively. 
    #In this we check if the subset is pure and stops if it is pure. 

    for value in attValue:
        
        subtable = get_subtable(df,node,value)
        clValue,counts = np.unique(subtable['Eat'],return_counts=True)                        
        
        if len(counts)==1:#Checking purity of subset
            tree[node][value] = clValue[0]                                                    
        else:        
            tree[node][value] = buildTree(subtable) #Calling the function recursively 
                   
    return tree
  
def predict(inst,tree):
    #This function is used to predict for any input variable 
    
    #Recursively we go through the tree that we built earlier

    for nodes in tree.keys():        
        
        value = inst[nodes]
        tree = tree[nodes][value]
        prediction = 0
            
        if type(tree) is dict:
            prediction = predict(inst, tree)
        else:
            prediction = tree
            break;                            
        
    return prediction

def main():

  training_dataset = {'Taste':['Salty','Spicy','Spicy','Spicy','Spicy','Sweet','Salty','Sweet','Spicy','Salty'],
       'Temperature':['Hot','Hot','Hot','Cold','Hot','Cold','Cold','Hot','Cold','Hot'],
       'Texture':['Soft','Soft','Hard','Hard','Hard','Soft','Soft','Soft','Soft','Hard'],
       'Eat':['No','No','Yes','No','Yes','Yes','No','Yes','Yes','Yes']}

  df = pd.DataFrame(training_dataset,columns=['Taste','Temperature','Texture','Eat'])

  tree = buildTree(df)


  test_data = {'Taste': 'Salty', 'Temperature':'Hot', 'Texture':'Soft'} # No
  test_dataset = {'Taste':['Salty','Spicy','Spicy','Spicy','Spicy','Sweet','Salty','Sweet','Spicy','Salty'],
       'Temperature':['Hot','Hot','Hot','Cold','Hot','Cold','Cold','Hot','Cold','Hot'],
       'Texture':['Soft','Soft','Hard','Hard','Hard','Soft','Soft','Soft','Soft','Hard'],
       'Eat':['No','No','Yes','No','Yes','Yes','No','Yes','Yes','Yes']}


  l = max(len(test_dataset[k]) for k in test_dataset.keys())

  for i in range(l):
      data_point = {}
      for k in test_dataset.keys():
          data_point[k] = test_dataset[k][i]
      inst = pd.Series(data_point)
      prediction = predict(inst, tree)
      print prediction


  '''for d in test_dataset:
    inst = pd.Series(d)
    prediction = predict(inst, tree)
    print prediction'''

main()


