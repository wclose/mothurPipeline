## Mothur Analysis Pipeline

This repo can be used to generate all of the desired output files from mothur (shared, tax, alpha/beta diversity, ordiations, etc.). The workflow is designed to work with [Snakemake](https://snakemake.readthedocs.io/en/stable/) and [Conda](https://docs.conda.io/en/latest/) with minimal intervention by the user. If you want to know more about what the steps are and why we use them, you can read up on them at the [Mothur wiki](https://www.mothur.org/wiki/MiSeq_SOP).

### Usage

#### Dependencies
* Install [Miniconda](https://docs.conda.io/en/latest/miniconda.html).
* Have paired end sequencing data.
* That's it!

#### Running analysis

1. Transfer all of your raw paired-end sequencing data into `data/mothur/raw` in this repo.
    > **NOTE:** Because of the way `mothur` parses sample names, it doesn't like it when you have hyphens or underscores in the **sample names** (emphasis on sample names, **not** the filename itself). 
    > E.g. a sequence file from mouse 10, day 10:  
        > **BAD** = *M10-10*_S91_L001_R1_001.fastq.gz  
        > **BAD** = *M10_10*_S91_L001_R1_001.fastq.gz  
        > **GOOD** = *M10D10_S91*_L001_R1_001.fastq.gz   
    > There is a script (`coda/bash/mothurNames.sh`) you can use to change hyphens to something else. Feel free to modify it for removing extra underscores as needed.
```
cp PATH/TO/SEQUENCEDIR/* data/mothur/raw
```

2. Create the master Snakemake environment.
    > **NOTE:** If you already have a conda environment with snakemake installed, you can skip this step.
```
conda env create -f envs/snakemake.yaml
```

3. Activate the environment that contains snakemake.
```
conda activate snakemake
```

4. Edit the options at the top of the Snakefile to set downstream analysis options.
```
nano Snakefile
```

Things to change (everything else can/should be left as is):
* **mothurMock**: Put the names (just the names of the samples, not the full filename with all of the sequencer information) of all of your mock samples here.
* **mothurControl**: Sames as for the mocks, you'll want to put the names of your controls here.
* **mothurAlpha**: The names of the alpha diversity metrics you want calculated. More info [HERE](https://www.mothur.org/wiki/Summary.single). 
* **mothurBeta**: The names of the beta diversity metrics you want calculated. More info [HERE](https://www.mothur.org/wiki/Dist.shared).

5. Test the workflow to make sure everything looks good.
```
snakemake --use-conda -np
```

6. Run the workflow to generate the desired outputs. All of the results will be available in `data/mothur/process/` when the workflow is completed. Should something go wrong, all of the log files will be available in `logs/mothur/`.
```
snakemake --use-conda
```







