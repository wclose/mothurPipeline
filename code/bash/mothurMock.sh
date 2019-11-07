#! /bin/bash
# mothurMock.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Other variables
export OUTDIR=data/mothur/references/ # Directory for storing mothur reference files



####################
# Running Pipeline #
####################

echo PROGRESS: Preparing v4 mock sequence files for mothur. 

# Making reference output directory and a tmp dir for processing
mkdir -p "${OUTDIR}"/ "${OUTDIR}"/tmp/

# We use ZymoBIOMICS Microbial Community Standard (Cat. no. D6306) as our mock community standard
# More information can be found at https://www.zymoresearch.com/zymobiomics-community-standard
# Downloading sequence files for mock community members
wget -N -P "${OUTDIR}"/tmp/ https://s3.amazonaws.com/zymo-files/BioPool/ZymoBIOMICS.STD.refseq.v2.zip

# Decompressing
unzip -o "${OUTDIR}"/tmp/ZymoBIOMICS.STD.refseq.v2.zip -d "${OUTDIR}"/tmp/

# Overwriting the current mock sequence file if one already exists, creates the file if it doesn't exist
echo -n "" > "${OUTDIR}"/zymo.mock.16S.fasta

# Concatenating all of the sequence files into a single reference file
for FASTA in "${OUTDIR}"/tmp/ZymoBIOMICS.STD.refseq.v2/ssrRNAs/*; do

	cat "${FASTA}" >> "${OUTDIR}"/zymo.mock.16S.fasta

done

# Copying data files to tmp dir for v4 alignment
cp "${OUTDIR}"/silva.seed.align "${OUTDIR}"/zymo.mock.16S.fasta "${OUTDIR}"/tmp/

# Aligning mock sequences to the SILVA v4 region
# Will generate the following warning message '[WARNING]: 4 of your sequences generated alignments that eliminated too many bases' 
# because 4 of the community sequences are from Cryptococcus and Saccharomyces so those will be filtered out
mothur "#align.seqs(fasta="${OUTDIR}"/tmp/zymo.mock.16S.fasta, reference="${OUTDIR}"/tmp/silva.seed.align, processors=8);
	pcr.seqs(fasta="${OUTDIR}"/tmp/zymo.mock.16S.align, start=11894, end=25319, keepdots=F);
	degap.seqs(fasta="${OUTDIR}"/tmp/zymo.mock.16S.pcr.align)"

# Sorting the output file by the first field (read name) and second letter (ignores the '>' at the read header and will sort on the second letter instead)
# Not super important but it makes it more human friendly
awk '{ORS=NR%2?",":"\n";print}' "${OUTDIR}"/tmp/zymo.mock.16S.pcr.ng.fasta | sort -k 1.2 | tr , '\n' > "${OUTDIR}"/zymo.mock.16S.v4.fasta

# Cleaning up
rm -rf "${OUTDIR}"/tmp/
