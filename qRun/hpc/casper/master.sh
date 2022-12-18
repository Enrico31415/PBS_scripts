#!/bin/bash
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

# ask for parameters
# select if Carbon (C) or protons (P) or orhters
nuclei=P

labelIndex="Al"
# select sepcific subdirectory on the outpath
outSubPath="casper${labelIndex}"

# select root fot the radioprotection project (containing both macro and radioprotection-build)
pathRadix=~/gitClone/g4_casper

# select macro Path 
# fix this to point to marco path
# usually 
#${pathRadix}/macro/createdMacro/${outSubPath}
macroPath=${pathRadix}/macro/run_macros

# from now on, no additional mandatory information are required

# #debug 
# echo $macroPath

module load python-3.8.13


#path di geat
geantPath=${pathRadix}/build/radioprotection


# #debug 
# echo $geantPath

#fa cose (crea le cartelle di output se non esistono gia')
outPath=~/outdata/$outSubPath/$nuclei
mkdir -p $outPath

#idConcatenati
idConc=""

#send message
python3 /home/enrico.pierobon/tBot/send.py "Run ${labelIndex} JobStarted"

# conta quanti ne ha mandati
i=1
# loop sui file di macro
for f in $macroPath/*.mac 
do
	# sed for the index of the run
        j=$(echo $f | sed -e 's/.*[^0-9]\([0-9]\+\)[^0-9]*$/\1/')

	#debug
    echo $f
    echo $j

	# Name of the qsubScript
	PFQ="G4S_${nuclei}_${j}"

	echo $PFQ

	#substitution


	#qsubbo passando i parametri: idx che e' la run, mac che e' il path della macro outPath
	id=`qsub -N ${PFQ} -v 'idx='${j}', mac='${f}', op='${outPath}', g4s='${geantPath}'' Qrun.sh`
    echo $id

	idConc=${idConc}:${id}

	i=$((i+1))

done


#python3 /home/enrico.pierobon/tBot/send.py "Run ${labelIndex} Submitted with IDs${idConc}"
#carico e tar
commandToRun="qsub -l select=1:ncpus=\"$i\":mem=64gb -N tarRun -v 'tarName=\"rateTEPC${nuclei}\", path=\"${outPath}\",rl=\"${labelIndex}\", gDriveFolder=\"TEPCOnly/casper/wt5mmAl${labelIndex}\"' -W depend=afterany${idConc} QpostRun.sh"
idrunA=`eval ${commandToRun}`
#echo $commandToRun

echo $idrunA
#python3 /home/enrico.pierobon/tBot/send.py "Run ${labelIndex}: data Analisys sbmitted with ID: ${idrunA}"



