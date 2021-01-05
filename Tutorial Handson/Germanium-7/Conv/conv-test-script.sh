#!/bin/bash

#ecut_list='30 40 50 60'
ecut_list='10 15 20 25 30 35 40 45 50 55 60'
k_list='2 3 4 5 6 7 8'
#k_list='2 3 4 5 10 15 20 25 30'

for ecut in $ecut_list
do
   for k in $k_list
   do
      fname="$ecut.$k"
      scf_name="Ge.scf.$fname"
      #echo $fname
      mkdir $fname
      cd $fname
      cp ../ge_pbe_v1.4.uspp.F.UPF .
      cat > $scf_name.in << EOF
 &control
    calculation='scf'
    restart_mode='from_scratch',
    pseudo_dir='./',
    outdir='./'
    prefix='sil',
 /
 &system    
    ibrav=2, celldm(1)=10.63290817, nat=2, ntyp=1,
    ecutwfc =$ecut
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    diagonalization = 'david'
 /

##CELL_PARAMETERS
##0.5 0.5 0.0
##0.0 0.5 0.5
##0.5 0.0 0.5

ATOMIC_SPECIES
 Ge   72.59  ge_pbe_v1.4.uspp.F.UPF 
ATOMIC_POSITIONS
 Ge  0.00 0.00 0.00 
 Ge  0.25 0.25 0.25 
K_POINTS  {automatic}
$k $k $k 0 0 0
EOF

    pw.x < $scf_name.in > $scf_name.out

      rm -rf sil.*

      cd ../
tot_en=`grep "!    total energy" ${fname}/${scf_name}.out | awk '{printf "%15.12f\n",$5}'`

echo "$k  $tot_en" >> k_mesh_conv_$ecut
echo "$ecut $tot_en" >> ecut_conv_$k-$k-$k
   done # k
done # ecut
