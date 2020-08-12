#!/usr/bin/env python3

import sys
import re
from pathlib import Path


STRIP_RE = re.compile(r"(\.h5|_openpose|.unsorted)$")


for path in Path(sys.argv[1]).rglob('*.h5'):
    name = path.name
    prev_name = None
    while prev_name != name:
        prev_name = name
        name = STRIP_RE.sub("", name)
    date, rest = name.split("_", 1)
    year, month, day = date.split("-", 2)
    print(f"{year}/{year}-{month}/{year}-{month}-{day}/{name}.mp4")
