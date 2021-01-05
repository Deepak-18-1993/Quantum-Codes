#!/bin/bash
# Script to optimize the lattice parameter of Si.

PREFIX='alu'

latt_param='7.40 7.42 7.44 7.46 7.48 7.5 7.52 7.54 7.56 7.58 7.6 7.62 7.64 7.66 7.68 7.7 7.72 7.74 7.76 7.78 7.8' # List of lattice parameters (a).

for latt in $latt_param # Sweep across the 'a' values to find the 'a' corresponding to the lowest total energy of the system.
do
   fname="$latt"
   scf_name="Al.scf.$fname"
   echo latt_param = $fname
   mkdir latt_$fname
   cp Al.UPF latt_$fname
   cd latt_$fname
   # Create the input file Al.scf.in.
   cat > $scf_name.in << EOF
 &control
    calculation='scf'
    restart_mode='from_scratch',
    pseudo_dir='./',
    outdir='./'
    prefix='$PREFIX',
 /
 &system
    ibrav=2, celldm(1)=$latt, nat=1, ntyp=1,occupations='smearing', smearing='gaussian',
    degauss=0.0003 , ecutwfc =30
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    mixing_mode='plain'
    diagonalization = 'david'
 /

ATOMIC_SPECIES
 Al   26.9815385   Al.UPF
ATOMIC_POSITIONS
 Al  0.00 0.00 0.00
K_POINTS  {automatic}
9 9 9 0 0 0
EOF

   # Running the scf calculation
   pw.x < $scf_name.in > $scf_name.out

   rm -rf $PREFIX.* # This removes the $PREFIX.save directory

   cd ../ # Go back to the directory from where this script is executed.

   tot_en=`grep "!    total energy" latt_${fname}/${scf_name}.out | awk '{printf "%15.12f\n",$5}'`
   # The awk command here prints the 5th column from the file. The 5th column corresponds to the total energy value.

   # Write the values of the 'a' and total energy corresponding to that 'a' into the file en_conv.
   # The >> symbols indicates that the data in each run must be appended to the same file and not overwrite the file.
   echo "$latt $tot_en" >> en_conv

done # latt

