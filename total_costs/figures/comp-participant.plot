set terminal pdf color size 15.4cm,3.8cm font "Helvetica, 7"
set output "figures/comp-participant.pdf"
set border 15 
set grid
set style fill solid 1.00 border -1
set datafile missing '-'
set boxwidth 0.25 absolute
set key right top reverse
#set style data boxes
#set size 0.7,0.5
set lmargin 11
set bmargin 8
set tmargin 1
set xtics font "Helvetica, 12"
set ytics font "Helvetica, 12"
set xlabel font "Helvetica, 12"
set ylabel font "Helvetica, 12"
set key font "Helvetica, 12"
set xlabel "Algorithm\n(b)"
set xlabel offset 0, -1.5, 0
set ylabel "Computation (min)" offset -3
#set xtics nomirror ("CMS" 1, "LogReg" 2, "NB" 3, "k-means" 4, "NN" 5)
set xtics nomirror ("Hcrisp" 0, "CMS" 1, "SV" 2, "Perc*" 3, "ID3*" 4, "kmean" 5, "PCA" 6, "NN*" 7, "kmedian" 8, "bloom" 9, "NB*" 10, "LogReg*" 11, "Hist" 12, "CDF" 13, "Range" 14)
set xtics offset 0, -0.5, 0
set ytics 1,5,25 nomirror
#set ytics 40,10,60 nomirror
set logscale y
plot [-0.5:14.5][0.1:25] \
"data/honeycrisp.data" using ($1):($12+$13+$14)/60 lt 2 lw 3 pt 2 ps 0.7 lc rgb "red" with boxes fill pattern 2 notitle,\
"data/honeycrisp.data" using ($1):($12+$13)/60 lt 1 lw 3 pt 1 ps 0.7 lc rgb "purple" with boxes fill pattern 2  notitle,\
"data/honeycrisp.data" using ($1):($14)/60 lt 1 lw 3 pt 1 ps 0.7 lc rgb "green" with boxes fill pattern 2  notitle,\
"data/comp-participant.data" using ($1):($2+$3+$4)/60 lt 1 lc rgb "red" with boxes title "Encryption",\
"data/comp-participant.data" using ($1):($2+$4)/60 lt 1 lc rgb "purple" with boxes title "Proof gen.",\
"data/comp-participant.data" using ($1):($4)/60 lt 1 lc rgb "green" with boxes title "Other"


