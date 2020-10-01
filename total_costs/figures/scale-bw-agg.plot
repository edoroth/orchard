set terminal pdf color size 5.7cm,4.8cm font "Helvetica, 7"
set output "figures/scale-bw-agg.pdf"
set border 15 
set grid
set style fill solid 1.00 border -1
set datafile missing '-'
set boxwidth 0.25 absolute
set key bottom right
set key font "Helvetica, 10"
set lmargin 15
set bmargin 8
set tmargin 1
set xlabel font "Helvetica, 12"
set ylabel font "Helvetica, 12"
set xtics font "Helvetica, 10"
set ytics font "Helvetica, 12"
set xlabel "Number of Participants\n(a)"
set xlabel offset 0, -2, 0
set ylabel "Traffic (TB sent)" offset -3
set xtics nomirror ("1.3*10^7" 1, "1.3*10^8" 2, "1.3*10^9" 3, "1.3*10^{10}" 4)
set xtics offset 0, -1, 0
set ytics 0.1,10,1000000 nomirror
set logscale y
plot [0.5:4.5][0.1:1000000] \
"data/scale-bw-agg.data" using ($1):($2/(1024*1024*1024*1024)) lt 2 lw 3 pt 2 ps 0.7 lc rgb "blue" with linespoints title "1 round",\
"data/scale-bw-agg.data" using ($1):($4/(1024*1024*1024*1024)) lt 2 lw 3 pt 2 ps 0.7 lc rgb "red" with linespoints title "3 rounds",\
"data/scale-bw-agg.data" using ($1):($6/(1024*1024*1024*1024)) lt 2 lw 3 pt 2 ps 0.7 lc rgb "green" with linespoints title "20 rounds"
