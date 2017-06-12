# shredPilon
Pipeline to run Pilon on a draft assembly in parallel chunks


## Instructions
Download repository and install utilities/compile tools: 

	git clone https://github.com/fg6/shredPilon.git
	cd forACT
	./launchme.sh install
  
### Run the pipeline for a project: 
#### Step 1: setup folder and scripts:
	$ ./launchme.sh setup </full/path/to/draft> </full/path/to/read1> </full/path/to/read2> </full/path/to/destdir>   
    /full/path/to/draft: location of draft assembly (fasta) 
    /full/path/to/read1: location of illumina read1.fastq
    /full/path/to/read2: location of illumina read2.fastq
    /full/path/to/destdir: folder where to run the pipeline (Please provide full path)

#### Step 2: run the pipeline:

	$ cd /full/path/to/destdir
	$ ./mypipeline.sh
Please note: the pipeline is autmated for running at Sanger, otherwise change the Pilon location in the utils/myscripts/pilon.sh script. The pipeline will launch a series of lsf jobs, so run it from a machine that supports lsf jobs.

#### Results:
The resulting assembly will be in /full/path/to/destdir/1Mb_groups/pilon.fasta
