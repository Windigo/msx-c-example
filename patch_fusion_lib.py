#!/usr/bin/env python3
"""
Patch Fusion-C library .rel files for SDCC 4.5.0 compatibility.
Adds 'sdcccall(1)' to the O (options) line in each .rel file.
"""

import os
import glob

LIB_DIR = 'fusion-c-lib/lib-rebuild'

for f in glob.glob(os.path.join(LIB_DIR, '*.rel')):
    with open(f, 'rb') as fh:
        data = fh.read()

    lines = data.split(b'\n')
    modified = False

    for i, line in enumerate(lines):
        if line.startswith(b'O -mz80') and b'sdcccall' not in line:
            lines[i] = line.replace(b'-mz80', b'-mz80 sdcccall(1)')
            modified = True
            break

    if modified:
        with open(f, 'wb') as fh:
            fh.write(b'\n'.join(lines))
        print(f'Patched: {os.path.basename(f)}')
