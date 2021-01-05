# Gnuplot script file for plotting data in file "plotband.dat"
# This file is called plot_dos.gnu
set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
set title "Band structure of Al"
set ylabel "Energy (E-Ef)(eV)"
#set ylabel "DOS"
#set key 0.01,100
#set xr [0.0:0.022]
#set yr [0:325]
plot    "plotband.dat" using 1:2 with linespoints, "plotband.dat" using 1:3 with linespoints, "plotband.dat" using 1:4 with linespoints, "plotband.dat" using 1:5 with linespoints, "plotband.dat" using 1:6 with linespoints 

pause -1 "Hit any key to continue\n"    #so that the code doesn't exit automatically
