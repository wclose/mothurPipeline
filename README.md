## Mothur Analysis Pipeline

This repo can be used to generate all of the desired output files from mothur (shared, tax, alpha/beta diversity, ordiations, etc.). The workflow is designed to work with [Snakemake](https://snakemake.readthedocs.io/en/stable/) and [Conda](https://docs.conda.io/en/latest/) with minimal intervention by the user. If you want to know more about what the steps are and why we use them, you can read up on them at the [Mothur wiki](https://www.mothur.org/wiki/MiSeq_SOP).

### Usage

#### Dependencies
* MacOSX or Linux operating system.
* Install [Miniconda](https://docs.conda.io/en/latest/miniconda.html).
* Have paired end sequencing data.

<br />

#### Running analysis

**1.** Clone this repository and move into the project directory.
```
git clone https://github.com/wclose/mothurPipeline.git
cd mothurPipeline
```

<br />

**2.** Transfer all of your raw paired-end sequencing data into `data/mothur/raw/`. 
> **NOTE:** Because of the way `mothur` parses sample names, it doesn't like it when you have hyphens or underscores in the **sample names** (emphasis on sample names, **not** the filename itself). There is a script (`code/bash/mothurNames.sh`) you can use to change hyphens to something else. Feel free to modify it for removing extra underscores as needed.
>
> <br />
>
> E.g. a sequence file from mouse 10, day 10:  
> * **BAD** = *M10-10*_S91_L001_R1_001.fastq.gz  
> * **BAD** = *M10_10*_S91_L001_R1_001.fastq.gz  
> * **GOOD** = *M10D10*_S91_L001_R1_001.fastq.gz

<br />

Copy sequences to the raw data directory.
```
cp PATH/TO/SEQUENCEDIR/* data/mothur/raw/
```

<br />

**3.** Create the master Snakemake environment.
> **NOTE:** If you already have a conda environment with snakemake installed, you can skip this step.
```
conda env create -f envs/snakemake.yaml
```

<br />

**4.** Activate the environment that contains snakemake.
```
conda activate snakemake
```

<br />

**5.** Edit the options at the top of the Snakefile to set downstream analysis options.
```
nano Snakefile
```

Things to change (everything else can/should be left as is):
* **mothurMock**: Put the names (just the names of the samples, not the full filename with all of the sequencer information) of all of your mock samples here.
* **mothurControl**: Sames as for the mocks, you'll want to put the names of your controls here.
* **mothurAlpha**: The names of the alpha diversity metrics you want calculated. More info [HERE](https://www.mothur.org/wiki/Summary.single). 
* **mothurBeta**: The names of the beta diversity metrics you want calculated. More info [HERE](https://www.mothur.org/wiki/Dist.shared).

<br />

**6.** Test the workflow to make sure everything looks good.
```
snakemake -np
```

<br />

**7.** If you want to see how everything fits together, you can run the following to generate a flowchart of the various steps. Alternatively, I have included the [flowchart](dag.svg) for the test data to show how everything fits together. You may need to download the resulting image locally to view it properly.
> **NOTE:** If you are using MacOSX, you will need to install `dot` using [homebrew](https://brew.sh/) or some alternative process before running the following command.
```
snakemake --dag | dot -Tsvg > dag.svg
```

<br />

**8.** Run the workflow to generate the desired outputs. All of the results will be available in `data/mothur/process/` when the workflow is completed. Should something go wrong, all of the log files will be available in `logs/mothur/`.
```
snakemake --use-conda
```

<br />

#### Running the workflow on a cluster

**1.** Before running any jobs on the cluster, change the `ACCOUNT` and `EMAIL` fields in the following files for whichever cluster you're using:
* PBS: [cluster profile configuration](config/pbs-torque/cluster.yaml) and the [cluster submission script](code/snakemake.pbs)
* Slurm: [cluster profile configuration](config/slurm/cluster.yaml) and the [cluster submission script](code/snakemake.sh)

<br /> 

**2.** Run the Snakemake workflow.
> **Note**: If you wish to rerun the workflow after having it successfully complete, use the `--forcerun` or the `--forceall` flags.
* To run the entire workflow locally (without the cluster):
```
snakemake --use-conda
```

<br /> 

* To run the rules as individual jobs on a PBS cluster:
```
mkdir -p logs/pbs/
snakemake --use-conda --profile config/pbs-torque/ --latency 90
```
Or to run a job that manages the workflow for you instead:
```
qsub code/snakemake.pbs
```

<br /> 

* To run the rules as individual jobs on a Slurm cluster:
```
mkdir -p logs/slurm/
snakemake --use-conda --profile config/slurm/ --latency 90
```
Or to run a job that manages the workflow for you instead:
```
sbatch code/snakemake.sh
```
