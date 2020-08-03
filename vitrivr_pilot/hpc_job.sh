#!/bin/bash
#
#SBATCH --job-name=skeldump_conv_2017
#
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=128gb
#SBATCH --time=4-00:00:00

module load singularity

# Dir setup
mkdir -p cineast/logs
mkdir -p cineast/out
mkdir -p cineast/cache

# DB setup
singularity run \
  --bind cineast/logs:/opt/cineast/logs \
  --bind cineast/out:/opt/cineast/out \
  --bind cineast/cache:/opt/cineast/cache \
  $EXTRA_SINGULARITY_ARGS \
  cineast.sif $(pwd)/cineast.json \
  setup

# Extraction
singularity exec \
  --bind cineast/logs:/opt/cineast/logs \
  --bind cineast/out:/opt/cineast/out \
  --bind cineast/cache:/opt/cineast/cache \
  $EXTRA_SINGULARITY_ARGS \
  cineast.sif bash -c \
    'java -Djava.awt.headless=true \
    -jar $CINEAST_JAR cineast.json extract \
    --extraction cineast_job.json'
