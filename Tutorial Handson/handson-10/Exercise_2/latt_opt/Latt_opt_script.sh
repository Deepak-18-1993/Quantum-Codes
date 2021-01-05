#!/bin/bash
# Script to optimize the lattice parameter of Al.

PREFIX='alu'

latt_param='5.20 5.21 5.22 5.23 5.24 5.25 5.26 5.27 5.28 5.29 5.30 5.31 5.32 5.33 5.34 5.35 5.36 5.37 5.38 5.39 5.40 5.41 5.42 5.43 5.44 5.45 5.46 5.47 5.48 5.49 5.50' # List of lattice parameters (a).

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
&SYSTEM
ibrav = 6, ! This signifies tetragonal unit cell
celldm(1) = $latt, ! The lattice parameter, a
celldm(3) = 8.D0, ! c/a, c is along the vertical axis
nat = 7,
ntyp = 1,
ecutwfc = 12.D0,
occupations = "smearing",
smearing = "gaussian",
degauss = 0.05D0,
/
&ELECTRONS
conv_thr = 1.D-6,
mixing_beta = 0.3D0,
/
&IONS

/
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
K_POINTS {automatic}
6 6 1 0 0 0
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
