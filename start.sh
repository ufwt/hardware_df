

#=========================================Initialization
rootdir=$(pwd)

testdir='testdir'
outdir_iden='stage1_identified'
outdir_swit='stage2_switched'
outdir_refn='stage3_refined'

resultfile_iden='record_identified.txt'
resultfile_refn='record_refined.txt'
resultfile_conv='record_converted.txt'
rm_records='record_removed.txt'



function init(){
	echo prepare workspace.
	if test -d ${outdir_iden}
	then 
		rm -rf ${outdir_iden}/
		mkdir ${outdir_iden}
		echo Remove old stage1_identified files.
	else
		mkdir ${outdir_iden}
		echo Make stage1_identified dir.
	fi


	if test -d ${outdir_swit}
	then 
		rm -rf ${outdir_swit}/
		mkdir ${outdir_swit}
		echo Remove old stage2_switched files.
	else
		mkdir ${outdir_swit}
		echo Make stage2_switched dir.
	fi

	if test -d ${outdir_refn}
	then 
		rm -rf ${outdir_refn}/
		mkdir ${outdir_refn}
		echo Remove old stage3_refined files.
	else
		mkdir ${outdir_refn}
		echo Make stage3_refined dir.
	fi


	if ! test -d ${testdir}
	then 
		mkdir ${testdir}
		echo Make  testdir.
	fi

	if test -f ${resultfile_iden}
	then 
		rm ${resultfile_iden}
		touch ${resultfile_iden}
		echo Remove old record_indentified.txt...
	else
		touch ${resultfile_iden}
		echo Make record_indentified.txt...
	fi

	if test -f ${resultfile_refn}
	then 
		rm ${resultfile_refn}
		touch ${resultfile_refn}
		echo Remove old record_refined.txt...
	else
		touch ${resultfile_refn}
		echo Make record_refined.txt...
	fi

	if test -f ${resultfile_conv}
	then 
		rm ${resultfile_conv}
		touch ${resultfile_conv}
		echo Remove old record_converted.txt...
	else
		touch ${resultfile_conv}
		echo Make record_converted.txt...
	fi

	if test -f ${rm_records}
	then 
		rm ${rm_records}
		touch ${rm_records}
		echo Remove old record_removed.txt...
	else
		touch ${rm_records}
		echo Make record_removed.txt...
	fi
}

# Identify candidate files from thousands of Linux sources files, 
# based on principle of two reads from same src location 
# Later processing will works on these candidate files
function identify() {
	time spatch -cocci_file identify.cocci -D count=0 -dir ${testdir} --no-loops --no-includes  --include-headers --no-safe-expressions --steps 120
	python copy_identified_files.py
	echo Result log: ${resultfile_iden}.
	echo Source files copied to: ${outdir_iden}
}

# Switch 34 wrapper functions to read_wrapper(), block_read_wrapper(), 
# and write_wrapper(), block_write_wrapper() to reduce the possible combinations
function switch_wrapper() {

	full_workdir=${rootdir}/${outdir_iden}
	full_outdir=${rootdir}/${outdir_swit}

	for curfile in $(ls ${full_workdir})
	do 
		num=$[num+1]
		echo [${num}] Switching: ${curfile}
		spatch --sp-file ${rootdir}/switch.cocci --no-loops  ${full_workdir}/${curfile}  -o ${full_outdir}/switched-${curfile} --no-show-diff --no-loops --no-includes --include-headers --no-safe-expressions	
	done

}

# Since some line number changed during switching the wrapper functions
# We need to rerun the pattern matching to generate new records, at the same time adding more refined rules. 
# In the end of this step, we also convert the records log into a python dic for later processing
function refine() {
	time spatch --sp-file refine.cocci -D count=0 -dir ${outdir_swit} --no-loops --no-includes  --include-headers --no-safe-expressions --steps 120
	python copy_refined_files.py
	echo Result log: ${resultfile_refn}.
	echo Source files copied to: ${outdir_refn}

	python convert_record.py
	echo Records log converted to ${resultfile_conv}.
}

function prune() {
	time spatch -cocci_file prune.cocci -D count=0 -dir ${outdir_refn} --no-loops --no-includes --include-headers --no-safe-expressions

}




#======================================== main procedure=========
echo Initialization: prepare the working spaces
#init

#================================================================
echo Stage 1: Identify candidate files.
#identify

#================================================================
echo Stage 2: Switch wrapper functions.
#switch_wrapper 

echo Stage 3: Refined pattern matching. 
refine

#================================================================
echo Stage 4: Prune  positives
prune
python print.py

echo finish
