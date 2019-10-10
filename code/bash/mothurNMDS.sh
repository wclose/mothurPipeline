#! /bin/bash
# mothurNMDS.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Set the variables to be used in this script
export DIST=${1:?ERROR: Need to define DISTLIST.}

# Other variables
export SEED=20170415



###################
# NMDS Ordination #
###################

# Calculating NMDS ordination
echo PROGRESS: Calculating NMDS ordination and metrics.

# Calculate axes for the whole distance file
mothur "#nmds(phylip="${DIST}", seed="${SEED}")"
