Setup VPS and index on HPC::

```
EXT_HOST=gallo.cosi.cwru.edu \
  VIDEO_DIR=/mnt/rds/redhen/gallina/tv/2017 \
  VPS_LOGIN_STR=frr7@gallo.cosi.cwru.edu \
  VPS_PILOT_BASE='~/vitrivr_pilot' \
  HPC_LOGIN_STR=frr7@hpc4.case.edu \
  HPC_PILOT_BASE=/mnt/rds/redhen/gallina/home/frr7/vitrivr_pilot \
  ./setup_vps.sh && ./index_on_hpc.sh
```

After this is finished, you can ssh into the VPS manually, kill the running
cottontail and use `./runall.sh` which will start all the daemons in a screen
session.
