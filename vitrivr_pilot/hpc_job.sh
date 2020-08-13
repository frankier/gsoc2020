#!/bin/bash
#
#SBATCH --job-name=cineast_extract
#
#SBATCH --ntasks=23
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4gb
#SBATCH --time=2-00:00:00

printf "Start: " >> ./timing.txt
date +"%s" >> ./timing.txt

module load singularity

# Extraction
while read VIDEO_FILE; do
  export VIDEO_FILE
  srun --ntasks=1 --cpus-per-task=2 hpc_node_job.sh --export ALL &
done < input_files.txt
wait

printf "End: " >> ./timing.txt
date +"%s" >> ./timing.txt
