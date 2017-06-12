#!/bin/bash
set -o errexit

thisdir=`pwd`
source $thisdir/mysettings.sh
debug=$1

mkdir -p  $outdir
cd $outdir 
if [[ ! -f mysettings.sh ]]; then
    ln -sf $thisdir/mysettings.sh .
fi

#######################################################
###################### ALIGN READS ####################
#######################################################
if [ ! -f $bamfile ]; then
    # this can be splitup in chunks so it's faster? and run in lsf
    $scriptdir/bwa.sh 
fi
checkfile=`$scriptdir/checkfile.sh $bamfile 1`
err=`echo $checkfile | tail -1`
if [[ $err > 0 ]]; then  echo; echo "   " $checkfile; exit; fi
echo " 1. Bam file ready"
echo

#######################################################
################# FIND CONTIG GROUPS  ################
#######################################################
file=$splitdir/groups.list
mkdir -p $splitdir
cd $splitdir
if [[ ! -f mysettings.sh ]]; then
    ln -sf $thisdir/mysettings.sh .
fi
if [ ! -f $file ]; then
    $srcdir/selgroups/selgroups $draft 10  # split in 10Mb 
fi
checkfile=`$scriptdir/checkfile.sh $file 2`
err=`echo $checkfile | tail -1`
if [[ $err > 0 ]]; then  echo; echo "   " $checkfile; exit; fi
echo " 2. Groups ready"
echo

#######################################################
###################### RUN PILON  #####################
#######################################################
ngroups=`wc -l $splitdir/groups.list | awk '{print $1}'`
ndone=`ls $splitdir/split*/pilon.fasta  2> /dev/null | wc -l`
#echo "groups="$ngroups "done="$ndone

if [[ $ndone < $ngroups ]]; then
    cd $splitdir
    l=0
    while read target
    do

	mkdir -p $splitdir/split$l
	cd $splitdir/split$l
	if [[ ! -f mysettings.sh ]]; then
	    ln -sf $thisdir/mysettings.sh .
	fi
	checkfile=`$scriptdir/checkfile.sh  ./pilon.fasta 3`
	err=`echo $checkfile | tail -1`
	if [[ $err > 0 ]]; then 	
	    sed "s/TARGETS/$target/g" $scriptdir/pilon.sh | sed "s/threads 5/threads 5/g" > pilon.sh
	    chmod +x pilon.sh   
	    bsub -J pilonT -q $queue -o ./out.%J -e ./errout.%J -n$ncpus -R"span[ptile=$ncpus] select[mem>$nmem] rusage[mem=$nmem]" -M$nmem  ./pilon.sh
	fi

	l=$(($l+1))
    done < groups.list

    sleep 15
    njobs=`bjobs 2>/dev/null | grep "pilonT" | wc -l`
    if [[ $njobs > 0 ]]; then
	while [ $njobs -ge 1 ]; do
            sleep 60
            njobs=`bjobs 2>/dev/null| grep "pilonT" | wc -l`
	done
	sleep 10
    fi
    sleep 60
fi
ndone=`ls $splitdir/split*/pilon.fasta 2> /dev/null | wc -l`
if [[ $ndone < $ngroups ]]; then echo "  Error: some pilon.fasta are missing!"; exit; fi
echo " 3. Split fasta ready"
echo


#######################################################
################# SHRED DRAFT ASSEMBLY ################
#######################################################
file=$outdir/pilon.fasta
cd $splitdir
if [ ! -f $file ]; then
    cat split*/*fasta > $outdir/pilon.fasta
fi
checkfile=`$scriptdir/checkfile.sh $file 4`
err=`echo $checkfile | tail -1`
if [[ $err > 0 ]]; then  echo; echo "   " $checkfile; exit; fi
newctgs=`$srcdir/n50/n50 $outdir/pilon.fasta | awk '{print $4}'`
octgs=`$srcdir/n50/n50 $draft  | awk '{print $4}'`

if [[ $newctgs != $octgs ]]; then echo "  Error! new fasta has wrong number of contigs! "; exit; fi

echo " 4. All done"
echo "    New draft assembly is in" $file
echo



