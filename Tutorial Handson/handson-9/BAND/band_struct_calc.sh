#!/bin/bash
# Script to perform band structure calculation

PREFIX="Al"
ELEMENT="Al"

# Path to pw.x executable
ESPRESSO_PW="pw.x"

# Equilibrium lattice parameter.
LATT_EQ=7.637663,  # enter in bohr

# k-mesh dimensions
K_MESH=6

# Ecut value
ECUT=50  # enter in Ry

# Create *.scf.in file to perform SCF calculation.
cat>$ELEMENT.scf.in<<EOF
 &control
    calculation='scf'
    restart_mode='from_scratch',
    pseudo_dir='./',
    outdir='./'
    prefix='$PREFIX',
 /
 &system    
    ibrav=2, celldm(1)=$LATT_EQ, nat=1, ntyp=1,
    ecutwfc =$ECUT, occupations='smearing', smearing='gaussian', degauss=0.003
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    diagonalization = 'david'
 /

ATOMIC_SPECIES
 $ELEMENT   26.9815385   Al.UPF 
ATOMIC_POSITIONS
 $ELEMENT  0.00 0.00 0.00
K_POINTS  {automatic}
$K_MESH $K_MESH $K_MESH 0 0 0
EOF

$ESPRESSO_PW  < $ELEMENT.scf.in > $ELEMENT.scf.out

echo Completed SCF calculation. Now starting bands calculation...

# Create *.band.in file to perform the band structure calculation by making
# use of self-consistent charge density from the previous SCF calculation.
cat>$ELEMENT.band.in<<EOF
 &control
    calculation='bands'
    pseudo_dir = './',
    outdir='./',
    prefix='$PREFIX'
 /
 &system
    ibrav=  2, celldm(1) =$LATT_EQ, nat=1, ntyp= 1,
    ecutwfc =$ECUT, nbnd=8
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    diagonalization='david'
 /
ATOMIC_SPECIES
 $ELEMENT  26.9815385  Al.UPF
ATOMIC_POSITIONS
 $ELEMENT 0.00 0.00 0.00
K_POINTS {crystal_b}
6
  0.00  0.00  0.00  30 !G
  0.50  0.50  0.00  30 !X
  0.75  0.50  0.25  30 !W
  0.50  0.00  0.00  30 !L
  0.00  0.00  0.00  30 !G
  0.50  0.50  0.00  30 !X
EOF
/usr/bin/pw.x < $ELEMENT.band.in > $ELEMENT.band.out

cat>$ELEMENT.bandx.in<<EOF
&BANDS
  prefix="$PREFIX"
  outdir="./"
  filband="Bandx.dat"
/
EOF
/usr/bin/bands.x < $ELEMENT.bandx.in > $ELEMENT.bandx.out
