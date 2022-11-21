#!/bin/sh
#PBS -l walltime=05:59:00
#PBS -l select=1:ncpus=72:mem=8gb
#PBS -e /home/enrico.pierobon/logs/
#PBS -o /home/enrico.pierobon/logs/
#PBS -q short_cpuQ


#prende come parametri:
#$idx = indice delle run
#$mac = path della macro
#$op = pathDiOutput
#$g4s = geant4source

source ~/prog/geant4/geant4.10.06.p01-install/bin/geant4.sh

#module load python-3.8.13

# mi metto sulla cartella di output
cd $op

#creo la cartella di run
mkdir run$idx
cd run$idx

# copy requested macros
cp /home/enrico.pierobon/gitClone/g4_casper/macro/*.mac .
cp $g4s .

#python3 /home/enrico.pierobon/tBot/send.py "RunH ${idx} started"
#lacio
./radioprotection $mac > ../infoRun${idx}.info


#python3 /home/enrico.pierobon/tBot/send.py "RunH$ ${idx} ended"
