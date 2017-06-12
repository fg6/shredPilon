#!/bin/bash
set -o errexit

thisdir=`pwd`
source $thisdir/mysettings.sh

mkdir -p $dir
cd $dir

ok=0
if [ ! -d $scriptdir ]; then echo; echo "Could not find script-dir in" $scriptdir; else ok=$(($ok+1)); fi
if [ ! -f $draft ]; then echo; echo "Could not find draft assembly fasta in" $draft;  else ok=$(($ok+1)); fi
if [ ! -f $reads1 ]; then echo; echo "Could not find reads1 fastq in" $reads1;  else ok=$(($ok+1)); fi
if [ ! -f $reads2 ]; then echo; echo "Could not find reads2 fastq in" $reads2;  else ok=$(($ok+1)); fi
if [ ! $ok -eq 4 ]; then echo; echo " ****  Error! Something is wrong! Giving up! **** "; echo; exit; 
else echo; echo " All input files found! Proceeding with pipeline.."; fi

$runshred 2>&1 
