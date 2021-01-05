#!/bin/bash
# Script to optimize the lattice parameter of Ge.

PREFIX='Ge'

latt_param='10.81 10.82 10.83 10.84 10.85 10.86 10.87 10.89 10.90 10.91 10.92 10.93 10.94 10.95' # List of lattice parameters (a).

for latt in $latt_param # Sweep across the 'a' values to find the 'a' corresponding to the lowest total energy of the system.
do
   fname="$latt"
   scf_name="Ge.scf.$fname" # file name
   echo latt_param = $fname
   mkdir latt_$fname
   cp ge_pbe_v1.4.uspp.F.UPF latt_$fname
   cd latt_$fname
   # Create the input file Ge.scf.in.
   cat > $scf_name.in << !
 &control
    calculation='scf'
    restart_mode='from_scratch',
    pseudo_dir='./',
    outdir='./'
    prefix='$PREFIX',
 /
 &system
    ibrav=2, celldm(1)=$latt, nat=2, ntyp=1,
    ecutwfc =50
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    diagonalization = 'david'
 /

ATOMIC_SPECIES
 Ge   72.64   ge_pbe_v1.4.uspp.F.UPF
ATOMIC_POSITIONS
 Ge  0.00 0.00 0.00
 Ge  0.25 0.25 0.25
K_POINTS  {automatic}
9 9 9 0 0 0
!

   # Running the scf calculation
   pw.x < $scf_name.in > $scf_name.out

   # rm -rf $PREFIX.* # This removes the $PREFIX.save directory

   cd ../ # Go back to the directory from where this script is executed.

   tot_en=`grep "!    total energy" latt_${fname}/${scf_name}.out | awk '{printf "%15.12f\n",$5}'`
   # The awk command here prints the 5th column from the file. The 5th column corresponds to the total energy value.

   # Write the values of the 'a' and total energy corresponding to that 'a' into the file en_conv.
   # The >> symbols indicates that the data in each run must be appended to the same file and not overwrite the file.
   echo "$latt $tot_en" >> en_conv1

done 
