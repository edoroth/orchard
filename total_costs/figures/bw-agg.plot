set term pdfcairo font "Helvetica, 7"
#set terminal pdf color size 15.4cm,3.8cm font "Helvetica, 7"
set terminal pdf color size 15.4cm,3.8cm 
set output "figures/bw-agg.pdf"
set border 15 
set grid
set style fill solid 1.00 border -1
set datafile missing '-'
set boxwidth 0.25 absolute
set key right top reverse
set lmargin 16
set bmargin 8
set tmargin 1
set key font "Helvetica, 12"
set xlabel font "Helvetica, 12"
set ylabel font "Helvetica, 12"
set xtics font "Helvetica, 12"
set ytics font "Helvetica, 12"
set xlabel "Algorithm\n(a)"
set xlabel offset 0, -2, 0
set ylabel "Traffic (TB)" offset -4
#set xtics nomirror ("CMS" 1, "LogReg" 2, "NB" 3, "k-means" 4, "NN" 5)
set xtics nomirror ("Hcrisp" 0, "CMS" 1, "SV" 2, "Perc*" 3, "ID3*" 4, "kmean" 5, "PCA" 6, "NN*" 7, "kmedian" 8, "bloom" 9, "NB*" 10, "LogReg*" 11, "Hist" 12, "CDF" 13, "Range" 14)
set xtics offset 0, -1, 0
set ytics 10,10,100000 nomirror
set logscale y
plot [-0.5:14.5][0.08:800000] \
"data/honeycrisp.data" using ($1):($6)/(1024 * 1024 * 1024 * 1024) lt 2 lw 3 pt 2 ps 0.7 lc rgb "green" with boxes fill pattern 2 notitle,\
"data/honeycrisp.data" using ($1+0.25):($7)/(1024 * 1024 * 1024 * 1024) lt 1 lw 3 pt 1 ps 0.7 lc rgb "blue" with boxes fill pattern 2  notitle,\
"data/bw-agg.data" using ($1):($2/(1024 * 1024 * 1024 * 1024)) lt 2 lw 3 pt 2 ps 0.7 lc rgb "green" with boxes title "Sent",\
"data/bw-agg.data" using ($1)+0.25:($3/(1024 * 1024 * 1024 * 1024)) lt 2 lw 3 pt 2 ps 0.7 lc rgb "blue" with boxes title "Received",\

# FOR LINES 
#"data/bw-agg.data" using ($1):($2/(1024 * 1024 * 1024 * 1024)) lt 2 lw 3 pt 2 ps 0.7 lc rgb "green" with linespoints title "Sent",\
