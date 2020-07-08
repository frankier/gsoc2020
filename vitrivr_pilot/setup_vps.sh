#!/bin/bash

set -o xtrace
set -euo pipefail

VPS_BOOTSTRAP=$(
cat <<-EOT
	set -o xtrace;
	set -euo pipefail;

	PATH="/usr/sbin:\$PATH";

	cd $VPS_PILOT_BASE;
	ln -sf ./from_local/Makefile.remote Makefile;
	echo "Running VPS Makefile on \$( whoami )@\$( hostname )";
	EXT_HOST="$EXT_HOST" VIDEO_DIR="$VIDEO_DIR" make $@;
EOT
)

if [ "${1-remote}" = "local" ]; then
	shift
	echo "Running local Makefile"
	make -f Makefile.local $@
else
	echo "Running local Makefile"
	make -f Makefile.local
	echo "Ensuring work dir on VPS"
	ssh $VPS_LOGIN_STR mkdir -p $VPS_PILOT_BASE/from_local
	echo "Running rsync to VPS"
	rsync -az --delete . $VPS_LOGIN_STR:$VPS_PILOT_BASE/from_local
	echo "Running VPS remote bootstrap"
fi
