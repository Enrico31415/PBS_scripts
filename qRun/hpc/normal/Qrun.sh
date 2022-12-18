#!/bin/sh
#PBS -l walltime=05:59:59
#PBS -l select=1:ncpus=72:mem=8gb
#PBS -e /home/enrico.pierobon/logs/
#PBS -o /home/enrico.pierobon/logs/
#PBS -q short_cpuQ


#prende come parametri:
#$idx = indice delle run
#$mac = path della macro
#$op = pathDiOutput
#$g4s = geant4source
#$label = label della run

source ~/prog/geant4/geant4.10.06.p01-install/bin/geant4.sh


# mi metto sulla cartella di output
cd $op

#creo la cartella di run
mkdir run$idx
cd run$idx

python3 /home/enrico.pierobon/tBot/send.py "Run ${label}-${PBS_JOBID}-${idx} started"
#lacio
$g4s $mac 0 > ../infoRun${idx}.info


python3 /home/enrico.pierobon/tBot/send.py "Run ${label}-${PBS_JOBID}-${idx} ended"
