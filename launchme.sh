#!/bin/bash
set -o errexit

whattodo=$1

thisdir=`pwd`
launchdir="$(dirname $0)"

if [[ $launchdir == '.' ]]; then
    myinst=`pwd`
else
    myinst=$launchdir
fi

if [ $# -lt 1 ] || [ $1 == '-h' ]; then
    echo; echo "  Usage:" $(basename $0) \<command\> 
    echo "  command: command to be run. Options: install, setup, test"
    # echo "   Check" https://github.com/fg6/forACT/blob/master/README.md "for detailed instructions"
    echo "  "

    exit
fi


if [ $whattodo == "install" ]; then
  ###################################################
  echo; echo " Installing shredPilon ..."
  ###################################################
  source $thisdir/utils/install.sh  $myinst
fi


if [ $whattodo == "setup" ]; then
  ###################################################
  # echo; echo " Setup for your project in progress..."
  ###################################################
  if [ $# -lt 4 ]  || [ $2 == '-h' ]; then
      echo; echo "  Usage:" $(basename $0) setup  \</full/path/to/draft\>  \</full/path/to/read1\> \</full/path/to/read2\>  \</full/path/to/destdir\>
      echo "   /full/path/to/draft: location of draft assembly (fasta) "
      echo "   /full/path/to/read1: location of illumina read1.fastq
      echo "   /full/path/to/read2: location of illumina read2.fastq
      echo "   /full/path/to/destdir: location of your project "
      echo
      exit
  fi
  draft=$2   
  reads1=$3
  reads2=$4
  dir=$5
  $thisdir/utils/myscripts/setup.sh  $myinst $draft $reads1 $reads2 $dir
fi


if [ $whattodo == "test" ]; then
  ###################################################
  #echo; echo " Testing with E.coli data"
  ###################################################
  #$thisdir/utils/myscripts/runtest.sh  $myinst
  echo not active yet
fi
