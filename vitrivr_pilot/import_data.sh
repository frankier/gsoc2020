#!/usr/bin/env bash

# Set up
set -o xtrace
shopt -s globstar
mkdir -p logs out cache

CINEAST="singularity run \
--bind $(pwd)/logs:/opt/cineast/logs \
--bind $(pwd)/out:/opt/cineast/out \
--bind $(pwd)/cache:/opt/cineast/cache \
--bind $WORK_DIR \
--bind $H5_BASE \
--bind $VIDEO_BASE \
cineast.sif cli $(pwd)/cineast.json"

CINEIMPORT="$CINEAST import --batchsize 512 --threads $THREADS"

# Deleting old Cottontail database
rm -rf ./cottontaildb-data/catalogue.db ./cottontaildb-data/schema_cineast

# Start Cottontail
echo "Starting Cottontail..."
singularity exec \
  --bind $(pwd)/cottontaildb-data:/cottontaildb-data \
  cottontail.sif \
  /cottontaildb-bin/bin/cottontaildb \
  /cottontaildb-data/config.json &
COTTONTAIL_PID=$!

echo "Waiting 10s for start up..."
sleep 10
echo "Continuing..."

bash <<-EOT
# Create entities
$CINEAST setup
$CINEAST setup --extraction cineast_job.json

# Import JSON
for JSON_DIR in $WORK_DIR/*/json
do
  $CINEIMPORT -t json -i $JSON_DIR
done

# Import poses
$CINEIMPORT -t posehdf5 -i $H5_BASE

# Import preembedded hand poses
$CINEIMPORT -t handpreembedjson -i $H5_BASE

# Import subtitles
while read VIDEO_FILE; do
  SUB_FILE="${VIDEO_FILE%.*}.txt"
  OCR_FILE="${VIDEO_FILE%.*}.ocr"
  
  $CINEIMPORT -t redhensub \
    -i $VIDEO_BASE/$SUB_FILE
  $CINEIMPORT -t redhenocr \
    -i $VIDEO_BASE/$OCR_FILE
done < $INPUT_FILES
wait
EOT

# Create indices
$CINEAST optimize

# Kill Cottontail
kill $COTTONTAIL_PID

# Copy thumbnails
mkdir -p $VPS_PILOT_BASE/thumbnails
cp -r $WORK_DIR/*/thumbs/* $VPS_PILOT_BASE/thumbnails
