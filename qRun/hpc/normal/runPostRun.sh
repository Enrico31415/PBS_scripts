#!/bin/bash
#start the data analisys
nuclei=P

labelIndex="S"
# select sepcific subdirectory on the outpath
outSubPath="calibNew${labelIndex}"


# select macro Path 
# fix this to point to marco path
# usually 
#${pathRadix}/macro/createdMacro/${outSubPath}

# from now on, no additional mandatory information are required

# #debug 
# echo $macroPath



#path di geat

outPath=~/outdata/$outSubPath/$nuclei

i=10

commandToRun="qsub -l select=1:ncpus=\"$i\":mem=64gb -N tarRun -v 'tarName=\"run${nuclei}\", path=\"${outPath}\",rl=\"${labelIndex}\", gDriveFolder=\"TEPCOnly/rate3/${labelIndex}\"' QpostRun.sh"
idrunA=`eval ${commandToRun}`
