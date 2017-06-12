
# illumina pair reads aligned to draft assembly:
bamfile=/lustre/scratch117/sciops/team117/hpag/fg6/analysis/Yeast/s288c/test_shredPilon/bwa.filtered.bam
# draft assembly:
assembly=/lustre/scratch117/sciops/team117/hpag/fg6/analysis/Yeast/s288c/miniasm/assembly.fa

mypilon=`echo java -Xmx16G -jar /software/hpag/pilon/r1.22/jars/pilon-dev.jar`

$mypilon --genome $assembly --frags $bamfile --threads 5 --targets "TARGETS" 

