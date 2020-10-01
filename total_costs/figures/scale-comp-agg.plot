set terminal pdf color size 5.7cm,4.8cm font "Helvetica, 7"
set output "figures/scale-comp-agg.pdf"
set border 15 
set style fill solid 1.00 border -1
set datafile missing '-'
set boxwidth 0.25 absolute
set key right bottom reverse
set lmargin 14
set bmargin 8
set tmargin 1
set grid
set key font "Helvetica, 10"
set xlabel font "Helvetica, 12"
set ylabel font "Helvetica, 12"
set xtics font "Helvetica, 10"
set ytics font "Helvetica, 12"
set xlabel "Number of Participants\n(b)"
set xlabel offset 0, -2, 0
set ylabel "Computation (cores)" offset -4
set xtics nomirror ("1.3*10^7" 1, "1.3*10^8" 2, "1.3*10^9" 3, "1.3*10^{10}" 4)
set xtics offset 0, -1, 0
set ytics 0,10,10000 nomirror
set logscale y
plot [0.5:4.5][0.1:10000] \
"data/scale-comp-agg.data" using ($1):($2) lt 2 lw 3 pt 2 ps 0.7 lc rgb "blue" with linespoints title "1 round",\
"data/scale-comp-agg.data" using ($1):($3) lt 2 lw 3 pt 2 ps 0.7 lc rgb "red" with linespoints title "3 rounds",\
"data/scale-comp-agg.data" using ($1):($4) lt 2 lw 3 pt 2 ps 0.7 lc rgb "green" with linespoints title "20 rounds"

