#! /bin/bash
# mothurReferences.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Other variables
OUTDIR=data/mothur/references/ # Directory for storing mothur reference files



####################################
# Preparing Mothur Reference Files #
####################################

echo PROGRESS: Preparing mothur reference files. 

# Making reference output directory
mkdir -p "${OUTDIR}"/ "${OUTDIR}"/tmp/



echo PROGRESS: Preparing SILVA database v4 sequence alignment files. 

# Downloading the prepared SILVA database from the mothur website
# For more inforamtion see https://mothur.org/wiki/silva_reference_files/
curl -L -R -o "${OUTDIR}"/tmp/silva.nr_v132.tgz -z "${OUTDIR}"/tmp/silva.nr_v132.tgz https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.nr_v132.tgz

# Decompressing the database
tar -xvzf "${OUTDIR}"/tmp/silva.nr_v132.tgz -C "${OUTDIR}"/tmp/

# Using mothur to pull out bacterial sequences and only keep sequences from the v4 region of the 16S rRNA DNA region
mothur "#get.lineage(fasta="${OUTDIR}"/tmp/silva.nr_v132.align, taxonomy="${OUTDIR}"/tmp/silva.nr_v132.tax, taxon=Bacteria);
	pcr.seqs(fasta=current, start=11894, end=25319, keepdots=F, processors=8)"

# Renaming the final output files
mv "${OUTDIR}"/tmp/silva.nr_v132.pick.align "${OUTDIR}"/silva.nr.align
mv "${OUTDIR}"/tmp/silva.nr_v132.pick.pcr.align "${OUTDIR}"/silva.v4.align



echo PROGRESS: Preparing Ribosomal Database Project taxonomy files. 

# Downloading the prepared RDP database from the mothur website
# For more information see https://mothur.org/wiki/rdp_reference_files/
curl -L -R -o "${OUTDIR}"/tmp/trainset16_022016.rdp.tgz -z "${OUTDIR}"/tmp/trainset16_022016.rdp.tgz https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset16_022016.rdp.tgz

# Decompressing the database
tar -xvzf "${OUTDIR}"/tmp/trainset16_022016.rdp.tgz -C "${OUTDIR}"/tmp/

# Move the taxonomy files out of the tmp dir
mv "${OUTDIR}"/tmp/trainset16_022016.rdp/trainset16_022016* "${OUTDIR}"/



# Cleaning up reference dir
rm -rf "${OUTDIR}"/tmp/
