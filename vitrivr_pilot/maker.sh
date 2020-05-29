#!/bin/bash

if [ "$1" = "local" ]; then
	shift
	echo "Running local Makefile"
	make -f Makefile.local $@
else
	echo "Running local Makefile"
	make -f Makefile.local
	echo "Ensuring work dir"
	ssh $LOGIN_STR mkdir -p $PILOT_BASE/from_local
	echo "Running rsync"
	rsync -az --delete . $LOGIN_STR:$PILOT_BASE/from_local
	echo "Running remote bootstrap"
	ssh $LOGIN_STR /bin/bash <<-EOT
		cd $PILOT_BASE
		ln -sf ./from_local/Makefile.remote Makefile
		echo "Running remote Makefile on \$( whoami )@\$( hostname )"
		PATH="\$HOME/.udocker/bin:\$PATH" EXT_HOST="$EXT_HOST" VIDEO_DIR="$VIDEO_DIR" make $@
	EOT
fi
