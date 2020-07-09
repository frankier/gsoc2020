#!/bin/bash

set -o xtrace
set -euo pipefail

exec ssh -A $SLURM_JOB_NODELIST bash <<-SSHSCOPE
	set -o xtrace
	set -euo pipefail

	module load singularity

	cd $(pwd)

	# Set up tunnel to cottontail
	ssh -N -L 127.0.0.1:1865:127.0.0.1:1865 gallo.cosi.cwru.edu &

	# DB setup
	singularity run \
	  cineast.sif $(pwd)/cineast.json \
	  setup

	# Extraction
	mkdir -p cineast/logs
	mkdir -p cineast/out
	mkdir -p cineast/cache
	singularity run \
	  --bind cineast/logs:/opt/cineast/logs \
	  --bind cineast/out:/opt/cineast/out \
	  --bind cineast/cache:/opt/cineast/cache \
          $EXTRA_SINGULARITY_ARGS \
	  cineast.sif $(pwd)/cineast.json \
	  extract --extraction $(pwd)/cineast_job.json && touch $1
SSHSCOPE
