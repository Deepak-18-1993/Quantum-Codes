# Gnuplot script file for plotting data in file "dos.dat"   the Fermi energy is     8.0823 ev
# This file is called plot_dos.gnu
set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
set title "Density of states (DOS) of Al "
set xlabel "E-Ef (eV)"
set ylabel "DOS(au)"
#set key 0.01,100
set xr [-7:7] # ser range of x and y
set yr [0:2]
plot    "dos.dat" using 1:2 title 'DOS' with linespoints
pause -1 "Hit any key to continue\n"    #so that the code doesn't exit automatically
