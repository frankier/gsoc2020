#!/bin/bash

set -o xtrace
set -euo pipefail

echo "Ensuring work dir on HPC"
ssh $HPC_LOGIN_STR mkdir -p $HPC_PILOT_BASE/from_local
echo "Running rsync on HPC"
rsync -az --delete . $HPC_LOGIN_STR:$HPC_PILOT_BASE/from_local
echo "Indexing videos on HPC (tunnelling to VPS)"
ssh $HPC_LOGIN_STR bash <<-EOT
	set -o xtrace;
	set -euo pipefail;

	module load singularity;

	cd $HPC_PILOT_BASE;
	ln -sf ./from_local/Makefile.hpc Makefile;
	echo "Running HPC Makefile on \$( whoami )@\$( hostname )";
	mkdir -p thumbnails;
	VIDEO_DIR="$VIDEO_DIR" THUMB_DIR="\$(pwd)/thumbnails" JSON_OUT="\$(pwd)/indexed_json" make --debug=jb $@;
	sbatch hpc_job.sh
EOT
