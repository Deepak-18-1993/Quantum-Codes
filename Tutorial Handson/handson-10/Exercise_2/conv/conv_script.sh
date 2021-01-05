#!/bin/bash

ecut_list='15 20 25 30 35 40 45 50 55 60'
k_list='3 4 5 6 7 8'

for ecut in $ecut_list
do
   for k in $k_list
   do
      fname="$ecut.$k"
      scf_name="Al.scf.$fname"
      #echo $fname
      mkdir $fname
      cd $fname
      cp ../Al.UPF .
      cat > $scf_name.in << EOF
 &control
    calculation='scf'
    restart_mode='from_scratch',
    pseudo_dir='./',
    outdir='./'
    prefix='alu',
 /
 &system    
    ibrav = 6, ! This signifies tetragonal unit cell
celldm(1) =5.37, ! The lattice parameter, a
celldm(3) = 8.D0, ! c/a, c is along the vertical axis
nat = 7,
ntyp = 1,
ecutwfc = 12.D0,
occupations = "smearing",
smearing = "gaussian",
degauss = 0.05D0, ecutwfc =$ecut
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    mixing_mode='plain'
    diagonalization = 'david'
/

##CELL_PARAMETERS
##0.5 0.5 0.0
##0.0 0.5 0.5
##0.5 0.0 0.5

ATOMIC_SPECIES
Al 26.9815385 Al.UPF
ATOMIC_POSITIONS
Al 0.5000000 0.5000000 -2.121320
Al 0.0000000 0.0000000 -1.414213
Al 0.5000000 0.5000000 -0.707107
Al 0.0000000 0.0000000 0.000000
Al 0.5000000 0.5000000 0.707107
Al 0.0000000 0.0000000 1.414213
Al 0.5000000 0.5000000 2.121320
K_POINTS  {automatic}
$k $k 1 0 0 0
EOF

    pw.x < $scf_name.in > $scf_name.out

      rm -rf alu.*

      cd ../
tot_en=`grep "!    total energy" ${fname}/${scf_name}.out | awk '{printf "%15.12f\n",$5}'`

echo "$k  $tot_en" >> k_mesh_conv_$ecut
echo "$ecut $tot_en" >> ecut_conv_$k*$k*$k
   done # k
done # ecut

