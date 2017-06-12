#!/bin/bash
set -o errexit

thisdir=`pwd`
source $thisdir/mysettings.sh

mkdir -p $aldir
cd $aldir

bwa index $draft 
bwa mem -t 20 $draft $reads1 $reads2 | samtools view -F 0x100 -F 0x200 -F 0x400 -F 0x800 -b - | samtools sort - -o $bamfile

# eliminated:  SECONDARY,  QCFAIL,  DUP,  SUPPLEMENTARY
