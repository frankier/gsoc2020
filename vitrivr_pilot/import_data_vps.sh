#!/usr/bin/env bash

ssh -t $VPS_LOGIN_STR <<-EOT
	cd $VPS_PILOT_BASE && \
	  INPUT_FILES="$INPUT_FILES" \
	  WORK_DIR="$WORK_DIR" \
	  H5_BASE="$H5_BASE" \
	  VIDEO_BASE="$VIDEO_BASE" \
	  THREADS=8 \
	  screen -d -m -c load_screenrc
EOT
