#!/bin/sh
#PBS -l walltime=06:00:00
#PBS -e /home/enrico.pierobon/logs/
#PBS -o /home/enrico.pierobon/logs/
#PBS -q short_cpuQ

#stop execution on error
set -e

#$path = path dei file di output
#$tarName = nome del file da tarare
#$gDriveFolder = cartella in cui carica
#rl = label index, to print to associate to the job

# send message
python3 /home/enrico.pierobon/tBot/send.py "Data Anal ${PBS_JOBID}-${rl} started, creating tar"

#tarName
tarName=${tarName}.tar.gz

#grdivePath
rclonePath="gdrive:SimResultShared/"$gDriveFolder
#tarData
echo $path
cd $path

#faccio il tar
ls -d */ | sed 's#/##' |  xargs -i -n 1 -P 0 tar -czvf "{}.tar.gz" "{}"

# faccio la cartella
rclone mkdir $rclonePath

#carico
ls *.tar.gz |  xargs -i -n 1 -P 0 rclone copy "{}" $rclonePath

ls *.info |  xargs -i -n 1 -P 0 rclone copy "{}" $rclonePath

python3 /home/enrico.pierobon/tBot/send.py "Data Anal ${PBS_JOBID}-${rl} tar completed, starting analisys"
# faccio l'analisi

ls -d "$PWD/"**/  |  xargs -i -n 1 -P 0 singularity exec ~/singulo/r3.6.3G.img Rscript /home/enrico.pierobon/singulo/RSc/rate3/anal.R {}

python3 /home/enrico.pierobon/tBot/send.py "Data Anal ${PBS_JOBID}-${rl} analisys completed, starting upload"

ls */ -d | xargs -n 1 -P 1 -i rclone mkdir  ${rclonePath}/{}
# load rdata
ls */ -d |  xargs -i -n 1 -P 0 rclone copy "{}" ${rclonePath}/{}  --include="*.RData"
# load PNG grap
ls */ -d |  xargs -i -n 1 -P 0 rclone copy "{}" ${rclonePath}/{}   --include="*.png"

python3 /home/enrico.pierobon/tBot/send.py "Data ${PBS_JOBID}-${rl} analisys completed. END"
