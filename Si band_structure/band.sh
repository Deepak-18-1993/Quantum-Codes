#!/bin/bash
# Script to perform band structure calculation

PREFIX="sil"
ELEMENT="Si"

# Path to pw.x executable
ESPRESSO_PW="/usr/bin/pw.x"

# Equilibrium lattice parameter.
LATT_EQ=10.26  # enter in bohr

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
    ibrav=2, celldm(1)=$LATT_EQ, nat=2, ntyp=1,
    ecutwfc =$ECUT
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    diagonalization = 'david'
 /

ATOMIC_SPECIES
 $ELEMENT   28.0855   Si.pz-vbc.UPF 
ATOMIC_POSITIONS
 $ELEMENT  0.00 0.00 0.00
 $ELEMENT  0.25 0.25 0.25
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
    ibrav=  2, celldm(1) =$LATT_EQ, nat=  2, ntyp= 1,
    ecutwfc =$ECUT, nbnd=8
 /
 &electrons
    conv_thr =  1.0d-8
    mixing_beta = 0.7
    diagonalization='david'
 /
ATOMIC_SPECIES
 $ELEMENT  28.0855  Si.pz-vbc.UPF
ATOMIC_POSITIONS
 $ELEMENT 0.00 0.00 0.00
 $ELEMENT 0.25 0.25 0.25
K_POINTS {crystal_b}
6
 0.500  0.500  0.500  30 !L
 0.000  0.000  0.000  30 !G 
 0.500  0.000  0.500  30 !X
 0.625  0.250  0.625  30 !U
 0.375  0.375  0.750  30 !K
 0.000  0.000  0.000  30 !G 
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
