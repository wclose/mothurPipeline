#! /bin/bash
# mothurNMDS.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Set the variables to be used in this script
DIST=${1:?ERROR: Need to define DIST.}
SEED=${2:?ERROR: Need to define SEED.}



###################
# NMDS Ordination #
###################

# Calculating NMDS ordination
echo PROGRESS: Calculating NMDS ordination and metrics.

# Calculate axes for the whole distance file
mothur "#nmds(phylip="${DIST}", seed="${SEED}")"
