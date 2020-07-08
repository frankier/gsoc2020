#!/bin/bash

set -o xtrace
set -euo pipefail

exec ssh -A $SLURM_JOB_NODELIST bash <<-SSHSCOPE
	set -o xtrace
	set -euo pipefail

	module load singularity

	cd $(pwd)
	ssh -L 127.0.0.1:1865:127.0.0.1:1865 gallo.cosi.cwru.edu &
	mkdir -p cineast/logs
	mkdir -p cineast/out
	singularity run \
	  --bind cineast/logs:/opt/cineast/logs \
	  --bind cineast/out:/opt/cineast/out \
          $EXTRA_SINGULARITY_ARGS \
	  cineast.sif $(pwd)/cineast.json \
	  extract --extraction $(pwd)/cineast_job.json && touch $1
SSHSCOPE
