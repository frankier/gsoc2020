Generate a passphrase-less key at ~/.ssh/id_gallo and add it to
~/.ssh/authorized_keys on gallo.

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

Import all data into Cottontail using Cineast

```
VIDEO_BASE=/mnt/rds/redhen/gallina/tv \
  VPS_LOGIN_STR=frr7@gallo.cosi.cwru.edu \
  VPS_PILOT_BASE='~/vitrivr_pilot' \
  H5_BASE=/mnt/rds/redhen/gallina/home/frr7/openposeellen \
  INPUT_FILES=/mnt/rds/redhen/gallina/home/frr7/vitrivr_pilot/input_files.txt \
  WORK_DIR=/mnt/rds/redhen/gallina/home/frr7/vitrivr_pilot/work/ \
  ./import_data_vps.sh
```

`index_on_hpc.sh` tries to clean up after itself, but always double check with
`squeue -u frr7` and `scancel` if need be.

After this is finished, you can ssh into the VPS manually,and use `./runall.sh`
which will start all the daemons in a screen session.
