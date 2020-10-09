Initial VPS setup::

```
EXT_HOST=gallo.cosi.cwru.edu \
  VIDEO_BASE=/mnt/rds/redhen/gallina/tv \
  VPS_LOGIN_STR=frr7@gallo.cosi.cwru.edu \
  VPS_PILOT_BASE='~/vitrivr_pilot' \
  ./setup_vps.sh
```

Indexing on HPC::

```
VIDEO_BASE=/mnt/rds/redhen/gallina/tv \
  H5_BASE=/mnt/rds/redhen/gallina/home/frr7/openposeellen \
  HPC_LOGIN_STR=frr7@hpc4.case.edu \
  HPC_PILOT_BASE=/mnt/rds/redhen/gallina/home/frr7/vitrivr_pilot \
  ./index_on_hpc.sh
```

Pre embedding is part of the embedding training code. Get skelshop and run
something like this on a HPC node:

```
SIF_PATH=/home/frr7/sifs/skelshop_latest.sif SNAKEFILE=/opt/skelshop/embedtrain/Snakefile SING_EXTRA_ARGS="--bind /mnt/rds/redhen/gallina/home/frr7/openposeellen" CLUSC_CONF=/opt/skelshop/contrib/slurm/embedtrain.clusc.json ~/run_coord.sh --config '"EMBED_FLAGS=--device cuda --batch-size 16384"' EMBED_INPUT=/mnt/rds/redhen/gallina/home/frr7/openposeellen --cores 4 pre_embed_all
```

Currently this has to be converted to JSON to workaround an issue in
netcdf-java https://github.com/Unidata/netcdf-java/issues/460

Copy skelshop/contrib/fixups/h5_to_json.sh to same directory prembedding was
run from and run it.

Import all data into Cottontail using Cineast:

```
VIDEO_BASE=/mnt/rds/redhen/gallina/tv \
  VPS_LOGIN_STR=frr7@gallo.cosi.cwru.edu \
  VPS_PILOT_BASE='~/vitrivr_pilot' \
  H5_BASE=/mnt/rds/redhen/gallina/home/frr7/openposeellen \
  PRE_EMBED_HAND_JSON_BASE=/mnt/rds/redhen/gallina/home/frr7/embedtrain/work/pre-embed-hand-json/ \
  INPUT_FILES=/mnt/rds/redhen/gallina/home/frr7/vitrivr_pilot/input_files.txt \
  WORK_DIR=/mnt/rds/redhen/gallina/home/frr7/vitrivr_pilot/work/ \
  ./import_data_vps.sh
```

`index_on_hpc.sh` tries to clean up after itself, but always double check with
`squeue -u frr7` and `scancel` if need be.

After this is finished, you can ssh into the VPS manually,and use `./runall.sh`
which will start all the daemons in a screen session.

The file `vitrivr.apache.conf` can be dropped into `/etc/httpd/conf.d/` to set
up Apache for proxying under `/vitrivr/` and `/cineast/`. Make sure mod_proxy
and mod_proxy_wstunnel are loaded.

You can then tunnel to check using:

```
VPS_LOGIN_STR=frr7@gallo.cosi.cwru.edu ./tunnel_pilot.sh
```
