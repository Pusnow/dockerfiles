#!/bin/bash
set -e

for conf in /conf/*.conf; do
    wg-quick up "${conf}"
done
