#! /bin/bash
# mothurSubsampleShared.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Set the variables to be used in this script
export SHARED=${1:?ERROR: Need to define SHARED.} # Shared file
export COUNT=${2:?ERROR: Need to define COUNT.} # Count file generated from shared file
export SUBTHRESH=${3:?ERROR: Need to define SUBTHRESH.} # Setting threshold for minimum number of reads to subsample



############################
# Subsampling Shared Files #
############################

# Subsampling reads based on count tables
echo PROGRESS: Subsampling shared file.

# Pulling smallest number of reads greater than or equal to $SUBTHRESH for use in subsampling 
READCOUNT=$(awk -v SUBTHRESH="${SUBTHRESH}" '$2 >= SUBTHRESH { print $2}' "${COUNT}" | sort -n | head -n 1)

# Debugging message
echo PROGRESS: Subsampling to "${READCOUNT}" reads.

# Subsampling reads based on $READCOUNT
mothur "#sub.sample(shared="${SHARED}", size="${READCOUNT}")"
