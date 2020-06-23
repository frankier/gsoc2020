#!/bin/bash
#
#SBATCH --job-name=skeldump_conv_2017
#
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=50gb
#SBATCH --time=5-00:00:00

cd /mnt/rds/redhen/gallina
module load singularity

srun singularity exec ~/gsoc2020_skeldump.sif python \
    /opt/redhen/skeldump/skeldump.py \
    conv --cores 40 --mode BODY_25_HANDS \
    monolithic-tar projects/2017_openpose_body_hand.tar home/frr7/openpose2017
