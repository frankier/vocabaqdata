#!/bin/bash

TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

cleanup() {
  rm -rf $TMPDIR
}

trap cleanup INT TERM
snakemake -j1 --dry-run --quiet
cleanup
