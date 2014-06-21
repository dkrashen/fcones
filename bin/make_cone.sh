#!/bin/bash

datadir=conedata$1
mkdir $datadir 

printf "generating inequalities..."
bin/f_ineqs.sage $1 > $datadir/ineqs$1
printf "done. (place in file $datadir/ineqs$1)\n"
printf "generating extremal rays..."
bin/lrs $datadir/ineqs$1 | bin/buffer 5000 5000 > $datadir/rays$1
printf "done. (place in file $datadir/rays$1)\n"

