set terminal pdf color size 15.4cm,3.8cm font "Helvetica, 7"
set output "figures/comp-agg.pdf"
set grid
set border 15 
set style fill solid 1.00 border -1
set datafile missing '-'
set boxwidth 0.25 absolute
set key right top reverse
set lmargin 12
set bmargin 8
set tmargin 1
set xlabel font "Helvetica, 12"
set ylabel font "Helvetica, 12"
set xtics font "Helvetica, 10"
set ytics font "Helvetica, 12"
set xlabel "Algorithm\n(b)"
set xlabel offset 0, -2, 0
set ylabel "Computation (cores)" offset -3
#set xtics nomirror ("CMS" 1, "LogReg" 2, "NB" 3, "k-means" 4, "NN" 5)
set xtics nomirror ("Hcrisp" 0, "CMS" 1, "SV" 2, "Perc*" 3, "ID3*" 4, "kmean" 5, "PCA" 6, "NN*" 7, "kmedian" 8, "bloom" 9, "NB*" 10, "LogReg*" 11, "Hist" 12, "CDF" 13, "Range" 14)
set xtics offset 0, -1, 0
set ytics 0,10,5000 nomirror
set logscale y
plot [-0.5:14.5][0.1:9000] \
"data/honeycrisp.data" using ($1):($8) lt 2 lw 3 pt 2 ps 0.7 lc rgb "blue" with boxes fill pattern 2 notitle,\
"data/comp-agg.data" using ($1):($2) lt 2 lw 3 pt 2 ps 0.7 lc rgb "blue" with boxes notitle
