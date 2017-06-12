#### Parameters to set: ####

shred=1  #Mb
# alignment < noise base-pairs will be considered noise and not show in ACT. default=30000 bp. (for smaller genomes reduce up to 5000 bp)
#noise=30000
# Use lfs jobs:
lfsjobs=1
ncpus=10
nmem=10000
queue=normal


########################
myinst=MYSHREDPILON
draft=MYDRAFT
reads1=MYREADS1
reads2=MYREADS2
dir=MYDESTDIR

scriptdir=$myinst/utils/myscripts
srcdir=$myinst/utils/mysrcs
runshred=$scriptdir/runshred.sh


folder=$shred\Mb_groups
outdir=$dir/$folder
aldir=$outdir/bwa
bamfile=$aldir/bwa.sorted.bam
splitdir=$aldir/split


