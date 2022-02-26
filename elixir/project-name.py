#!/usr/bin/env python3
import os
import sys
from urllib.parse import urlparse

if sys.argv[1:]:
    url = sys.argv[1]
    parsed = urlparse(url)
    basename = os.path.basename(parsed.path)
    if basename.endswith(".git"):
        basename = basename[:-4]
    print(basename)