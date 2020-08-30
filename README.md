[Progress is on the wiki.](https://github.com/frankier/gsoc2020/wiki)

This repository is for small odds/ends and to point to other places where the
actual coding has taken place including forks of other projects.

## Contents

* `attic` contains old and abandoned work:
  * Hand pose annotation
  * Singularity def files for Cineast (Docker is used now)
* `openpose_singularity` contains Singularity container for OpenPose
* `skelshop` contains a *submodule* for the skelshop utility, which contains
  all the Python code/Snakemake pipelines, for skeleton dumping, tracking,
  segmentation, and embedding pipelines
* `forks` contains *submodules* with forks of existing repos:
  * `javacpp-presets-add-openpose`: OpenPose JavaCPP binding
  * `opencv_wrapper`: Add a couple of extra methods
  * `openpose`: Improve Python API and enable broken tracking
  * `slurm`: (Snakemake SLURM profile) Run SLURM outside container by
    communicating over the filesystem
* `vitrivr_pilot` contains scripts to deploy pilot Vitrivr instance
* `refreeze_hand_tracking` contains code to refreeze a pretrained hand
  detection model 
