

#=========================================Initialization
rootdir=$(pwd)
resultfile1='record1.txt'
resultfile2='record2.txt'
testdir='testdir'
outdir1='stage1_identify'
outdir2='stage2_switch'
outdir3='stage3_prune'


function init(){
	echo prepare workspace.
	if test -d ${outdir1}
	then 
		rm -rf ${outdir1}/
		mkdir ${outdir1}
		echo Remove old stage1_identify files.
	else
		mkdir ${outdir1}
		echo Make stage1_identify dir.
	fi


	if test -d ${outdir2}
	then 
		rm -rf ${outdir2}/
		mkdir ${outdir2}
		echo Remove old stage2_switch files.
	else
		mkdir ${outdir2}
		echo Make stage2_switch dir.
	fi

	if test -d ${outdir3}
	then 
		rm -rf ${outdir3}/
		mkdir ${outdir3}
		echo Remove old stage3_prune files.
	else
		mkdir ${outdir3}
		echo Make stage3_prune dir.
	fi


	if ! test -d ${testdir}
	then 
		mkdir ${testdir}
		echo Make  testdir.
	fi

	if test -f ${resultfile1}
	then 
		rm ${resultfile1}
		touch ${resultfile1}
		echo Remove old results...
	else
		touch ${resultfile1}
		echo Make results log file...
	fi

	if test -f ${resultfile2}
	then 
		rm ${resultfile2}
		touch ${resultfile2}
		echo Remove old results...
	else
		touch ${resultfile2}
		echo Make results log file...
	fi
}

function switch_wrapper() {

#	local cur_dir workdir  
#	workdir=$1
#	cd ${workdir}
#    if  ${workdir} = "/" 
#    then
#        cur_dir=""
#    else
#        cur_dir=$(pwd)
#    fi

#    for curfile in $(ls ${cur_dir})
#	do
#		if test -d ${curfile}
#        then
#            cd ${curfile}
#            switch_wrapper ${cur_dir}/${curfile} 
#            cd ..
#        else	 
#			num=$[num+1]
#			echo [${num}] Switching: ${curfile}
#			spatch --sp-file ${rootdir}/switch.cocci  ${cur_dir}/${curfile}  -o ${full_outdir1}/switched-${curfile}
#		fi
#	done
	full_workdir=${rootdir}/${outdir1}

	full_outdir=${rootdir}/${outdir2}

	for curfile in $(ls ${full_workdir})
	do 
		num=$[num+1]
		echo [${num}] Switching: ${curfile}
		spatch --sp-file ${rootdir}/switch.cocci --no-loops  ${full_workdir}/${curfile}  -o ${full_outdir}/switched-${curfile} 
		#--no-show-diff
	
	done

}

function identify() {
	echo Stage 1: Identify candidate files. 
	time spatch -cocci_file identify.cocci -D count=0 -dir ${testdir} --no-loops
	time python copy_files.py
	echo Result log: ${resultfile}.
	echo Source files copied to: ${stage1_basic}
}

function prune() {
	echo prune

}
#======================================== main procedure=========
echo Start analyzing
# call init() to prepare the working spaces

#init
#================================================================
# identify candidate files from thousands of Linux sources files, 
# based on principle of two reads from same src location 

#identify
#================================================================
# switch 34 wrapper functions to read_wrapper() block_read_wrapper() write_wrapper block_write_wrapper()
echo Stage 2: switch wrapper functions.

#switch_wrapper 
python record_convert.py
#================================================================
# prune false positives
echo Stage 3: prune false postives

#prune

echo finish
