#!/bin/bash
set -e

for conf in /conf/*.conf; do
    wg-quick down "${conf}" || true
    wg-quick up "${conf}"
done
