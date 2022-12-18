#!/bin/bash
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

note='G4_casper with TEPC only. 4cm of brain 1mm away from the TEPC shell. 140 MeV'

# ask for parameters
# select if Carbon (C) or protons (P) or orhters
nuclei=P

labelIndex="A"
# select sepcific subdirectory on the outpath
outSubPath="caster_TEPC${labelIndex}"

# select root fot the radioprotection project (containing both macro and radioprotection-build)
pathRadix=~/gitClone/Geant4TEPCLGAD/

# select macro Path 
# fix this to point to marco path
# usually 
#${pathRadix}/macro/createdMacro/${outSubPath}
macroPath=${pathRadix}/Macro/createdMacro/casper/${labelIndex}

# from now on, no additional mandatory information are required

# #debug 
# echo $macroPath


#path di geat
geantPath=${pathRadix}/radioprotection-build/radioprotection


# #debug 
# echo $geantPath

#fa cose (crea le cartelle di output se non esistono gia')
outPath=~/outdata/$outSubPath/$nuclei
mkdir -p $outPath

#idConcatenati
idConc=""

gdrive_folder='TEPCOnly/casper/4cm_brain/'

#send message
python3 /home/enrico.pierobon/tBot/send.py "Run ${labelIndex} JobStarted"
python3 /home/enrico.pierobon/tBot/send.py "Run ${labelIndex}: saving on HPC: ${outSubPath}. Loading on gdrive = ${gdrive_folder}. Note = ${note}"


# conta quanti ne ha mandati
i=1
# loop sui file di macro
for f in $macroPath/*.mac 
do
	# sed for the index of the run
        j=$(echo $f | sed -e 's/.*[^0-9]\([0-9]\+\)[^0-9]*$/\1/')

	#debug
        #echo $j

	# Name of the qsubScript
	PFQ="G4${labelIndex}_${nuclei}_${j}"

	echo $PFQ

	#substitution


	#qsubbo passando i parametri: idx che e' la run, mac che e' il path della macro outPath
	id=`qsub -N ${PFQ} -v 'label='${labelIndex}', idx='${j}', mac='${f}', op='${outPath}', g4s='${geantPath}'' Qrun.sh`
        echo $id

	idConc=${idConc}:${id}

	i=$((i+1))

done


python3 /home/enrico.pierobon/tBot/send.py "Run ${labelIndex} Submitted with IDs${idConc}"
#carico e tar
#commandToRun="qsub -l select=1:ncpus=20:mem=64gb -N tarRun -v 'tarName=\"TEPC_ONLY_4cm_brain${nuclei}\", path=\"${outPath}\",rl=\"${labelIndex}\", gDriveFolder=\"TEPCOnly/casper/4cm_brain/${labelIndex}\"' -W depend=afterany${idConc} QpostRun.sh"
commandToRun="qsub -l select=1:ncpus=20:mem=64gb -N tarRun -v 'tarName=\"run_${nuclei}\", path=\"${outPath}\",rl=\"${labelIndex}\", gDriveFolder=\"${gdrive_folder}${labelIndex}\"' -W depend=afterany${idConc} QpostRun.sh"
idrunA=`eval ${commandToRun}`
#echo $commandToRun

echo $idrunA
python3 /home/enrico.pierobon/tBot/send.py "Run ${labelIndex}: data Analisys sbmitted with ID: ${idrunA}"



