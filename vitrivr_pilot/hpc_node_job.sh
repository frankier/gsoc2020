#!/usr/bin/env bash

set -o xtrace

STEP_ID=$SLURM_JOB_ID-$SLURM_STEP_ID

WORK=$(pwd)/work/$STEP_ID
export THUMB_DIR=$WORK/thumbs
export JSON_OUT=$WORK/json
export JOB=$WORK/cineast_job.json

SCRATCHWORK=/scratch/$USER/cineast_extract/$STEP_ID
export CINEAST_LOGS=$SCRATCHWORK/logs
export CINEAST_OUT=$SCRATCHWORK/out
export CINEAST_CACHE=$SCRATCHWORK/cache

mkdir -p $WORK $THUMB_DIR $JSON_OUT \
  $CINEAST_LOGS $CINEAST_OUT $CINEAST_CACHE

cat from_local/cineast_job.json | \
  envsubst '$VIDEO_FILE $VIDEO_BASE $THUMB_DIR $JSON_OUT' > $JOB

singularity exec \
  --bind $CINEAST_LOGS:/opt/cineast/logs \
  --bind $CINEAST_OUT:/opt/cineast/out \
  --bind $CINEAST_CACHE:/opt/cineast/cache \
  $EXTRA_SINGULARITY_ARGS \
  cineast.sif bash -c \
    "cd \$CINEAST && \
    java -Djava.awt.headless=true \
    -jar \$CINEAST_JAR cineast.json extract \
    --extraction $JOB"
