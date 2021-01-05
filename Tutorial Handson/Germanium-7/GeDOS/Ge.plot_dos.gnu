# Gnuplot script file for plotting data in file "dos.dat" the Fermi energy is     8.7414 ev
# This file is called plot_dos.gnu
set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
set title "Density of states (DOS) of Ge crystal"
set xlabel "Energy (E-Ef)(eV)"
set ylabel "DOS"
#set key 0.01,100
#set xr [0.0:0.022]
#set yr [0:325]
plot    "dos.dat" using 1:2 title 'DOS' with linespoints
pause -1 "Hit any key to continue\n"    #so that the code doesn't exit automatically
