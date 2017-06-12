#!/bin/bash
set -o errexit

myinst=$1
notshred=$2  
reads1=$3
reads2=$4
dir=$5

if [ $# -lt 5 ]  || [ $1 == '-h' ]; then
    echo; echo "  Usage:" $(basename $0) \</full/path/to/shredPilon\> \</full/path/to/draft\> \</full/path/to/reads1\> \</full/path/to/reads2\>   \</full/path/to/destdir\>
    echo "   /full/path/to/shredPilon: location of shredPilon "
    echo "   /full/path/to/draft: location of draft assembly (fasta) "
    echo "   /full/path/to/read1: location of illumina read1.fastq"
    echo "   /full/path/to/read2: location of illumina read2.fastq"
    echo "   /full/path/to/destdir: location of your project "
    exit
fi

thisdir=`pwd`
scriptdir=$myinst/utils/myscripts

mkdir -p $dir

sub1="s#MYSHREDPILON#$myinst#g"
sub2="s#MYDRAFT#$notshred#g"
sub3="s#MYREADS1#$reads1#g"
sub4="s#MYREADS2#$reads2#g"
sub5="s#MYDESTDIR#$dir#g"

sed $sub1 $myinst/utils/myscripts/settings.sh | sed $sub2 | sed $sub3 | sed $sub4 | sed $sub5 > $dir/mysettings.sh
cp  $myinst/utils/myscripts/pipeline.sh $dir/mypipeline.sh
chmod +x $dir/*.sh

echo; echo  " Your new project is set in folder: " $dir;
echo " Modify relevant paramters in " $dir/mysettings.sh
