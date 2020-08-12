#!/bin/bash

set -o xtrace
set -euo pipefail

echo "Ensuring work dir on HPC"
ssh $HPC_LOGIN_STR mkdir -p $HPC_PILOT_BASE/from_local
echo "Running rsync on HPC"
rsync -az --delete \
  cineast_job.json \
  cineast_extraction_config.json \
  hpc_job.sh \
  hpc_node_job.sh \
  Makefile.hpc \
  videos_from_h5s.py \
  $HPC_LOGIN_STR:$HPC_PILOT_BASE/from_local
echo "Indexing videos on HPC"
ssh $HPC_LOGIN_STR bash <<-EOT
	set -o xtrace;
	set -euo pipefail;

	export H5_BASE="$H5_BASE"
	export VIDEO_BASE="$VIDEO_BASE"

	module load singularity;
	module unload python/3.5.1;

	cd $HPC_PILOT_BASE;
	ln -sf ./from_local/Makefile.hpc Makefile;
	echo "Running HPC Makefile on \$( whoami )@\$( hostname )";
	mkdir -p thumbnails;
	make $@;
	sbatch hpc_job.sh
EOT
