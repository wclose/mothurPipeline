#! /bin/bash
# mothurPCoA.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Set the variables to be used in this script
export DIST=${1:?ERROR: Need to define DIST.}



###################
# PCoA Ordination #
###################

# Calculating PCoA ordination
echo PROGRESS: Calculating PCoA ordination and metrics.

# Run diversity analysis on new aligned data set
mothur "#pcoa(phylip="${DIST}")"
