import kmeans
import geogr
import json
import ast

f = open("geogrOut", "r")

while 1:
    header = f.readline()
    if not header: break
    header = header.split()
    NUM_CLUSTERS=3
    EPSILON=float(header[2])
    RANDOM_INIT=(header[1] == 'True')
    EXP=int(header[0])

    print header
    f.readline()
    ft = ast.literal_eval(f.readline())
    f.readline()
    ff_clip = ast.literal_eval(f.readline())
    f.readline()
    tf_clip = ast.literal_eval(f.readline())
    f.readline()
    ff = ast.literal_eval(f.readline())
    f.readline()
    tf = ast.literal_eval(f.readline())

    print 'graphing'
    geogr.produce_graph(ff, ff_clip, ft, tf, tf_clip, NUM_CLUSTERS, EPSILON, EXP, RANDOM_INIT)
f.close()
