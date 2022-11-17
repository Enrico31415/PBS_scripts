#!/bin/sh
#PBS -l walltime=999:00:00
#PBS -l ncpus=48
#PBS -e localhost:/mnt/data1/pierobon/log/
#PBS -o localhost:/mnt/data1/pierobon/log/
#PBS -N G4_casper
#PBS -q move-it

#dove si trova l'eseguibile
execPath=/mnt/data1/pierobon/code/g4_casper/build/radioprotection
#dove si trovano le macro
macroPath=/mnt/data1/pierobon/code/g4_casper
#sottocartella specifica
specificLocalOut=g4_casper/run2
#come del cluster
clusterHome=/home/$USER

#path della home del cluster, dove si andrà a scrivere
homeOutput=/home/$USER/$specificLocalOut
#path che specifica il ulteriormente il tipo di output

# path dell'output dove saranno copiati tutti i file generati (a meno degli errori)
output=/mnt/data1/$USER/$specificLocalOut

#importa geant
cd /mnt/data2/geant4.10.06.p06-install/bin
. mnt/data2/geant4.10.06.p06-install/bin/geant4.sh

#mettiti sulla così usa il disco locale (così va più veloce?)
cd $clusterHome

#rimuovi i file se esistono già
rm -rf $specificLocalOut
mkdir $specificLocalOut
cd $specificLocalOut

# copy macros
cp $execPath .

# copy macros
cp $macroPath/*.mac .

# run the simulation
$execPath run.mac > log.info

# move the stuff to new path
mkdir -p /mnt/data2/$specificLocalOut
mv *.root /mnt/data2/$specificLocalOut/
mv log.info /mnt/data2/$specificLocalOut/
