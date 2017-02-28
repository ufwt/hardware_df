

#=========================================Initialization
rootdir=$(pwd)
resultfile='result.txt'
testdir='testdir'
outdir1='stage1_basic'
outdir2='stage2_switch'
outdir3='stage3_prune'

if test -d ${outdir1}
then 
	#rm -rf ${outdir1}/
	#mkdir ${outdir1}
	echo Remove old stage1_basic files.
else
	mkdir ${outdir1}
	echo Make stage1_basic dir.
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

if test -f ${resultfile}
then 
	rm ${resultfile}
	touch ${resultfile}
	echo Remove old results...
else
	touch ${resultfile}
	echo Make results log file...
fi


function scandir() {

	local cur_dir workdir  

	workdir=$1


	cd ${workdir}
    if  ${workdir} = "/" 
    then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi

    for curfile in $(ls ${cur_dir})
	do
		if test -d ${curfile}
        then
            cd ${curfile}
            scandir ${cur_dir}/${curfile} ${outdir}
            cd ..
        else	 
			num=$[num+1]
			echo [${num}] Switching: ${curfile}
			spatch --sp-file ${rootdir}/hdf_linux.cocci  ${cur_dir}/${curfile}  -o ${full_outdir1}/switched-${curfile}
		fi
	done


}

#======================================== main procedure
#call scandir to recersively check all the source files.
echo Start analyzing...
echo Stage 1: Basic match 

#spatch -cocci_file basic.cocci -D count=0 -dir ${testdir}

#python copy_files.py
echo Result log: ${resultfile}.
echo Source files copied to: ${stage1_basic}\
echo Stage 1: Finished.

echo Stage 2: switch wrapper functions.
echo ==================================================
full_testdir=$(pwd)/${outdir1}
full_outdir1=$(pwd)/${outdir2}
scandir ${full_testdir} 
echo Stage 1: Finished.

echo Stage 2:













