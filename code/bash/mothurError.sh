#! /bin/bash
# mothurError.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Set the variables to be used in this script
export ERRORFASTA=${1:?ERROR: Need to define ERRORFASTA.}
export ERRORCOUNT=${2:?ERROR: Need to define ERRORCOUNT.}
export MOCKV4=${3:?ERROR: Need to define MOCKV4.}
export MOCKGROUPS=${4:?ERROR: Need to define MOCKGROUPS.} # List of mock groups in raw data dir separated by '-'

# Other variables
export OUTDIR=data/mothur/process/



######################
# Run Error Analysis #
######################

# Calculating error rates compared to Zymo reference sequences
echo PROGRESS: Calculating sequencing error rate.

mothur "#get.groups(fasta="${ERRORFASTA}", count="${ERRORCOUNT}", groups="${MOCKGROUPS}");
	seq.error(fasta=current, count=current, reference="${MOCKV4}", aligned=F)"



# Moving error analysis files to error directory
echo PROGRESS: Storing error logs.

mkdir -p "${OUTDIR}"/error_analysis

mv "${OUTDIR}"/errorinput.* "${OUTDIR}"/error_analysis/
