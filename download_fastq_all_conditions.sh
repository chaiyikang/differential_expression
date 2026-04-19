#!/usr/bin/env bash
# Download paired-end FASTQs for six representative samples (one per condition)
# Run from project root; files land in ./fastq/

set -euo pipefail

mkdir -p fastq
cd fastq

# One SRR per condition, using replicate 1 throughout for consistency
SRRS=(
  SRR28499039   # LIM1215-S  rep 1
  SRR28499036   # LIM1215-R1 rep 1
  SRR28499033   # LIM1215-R2 rep 1
  SRR28499048   # DiFi-S     rep 1
  SRR28499045   # DiFi-R1    rep 1
  SRR28499042   # DiFi-R2    rep 1
)

for SRR in "${SRRS[@]}"; do
  if [ -f "${SRR}_1.fastq.gz" ]; then
    echo ">>> $SRR already present, skipping."
    continue
  fi

  echo ">>> Fetching $SRR"
  prefetch "$SRR"
  fasterq-dump "$SRR" --split-files --threads 4
  gzip -f "${SRR}"_1.fastq "${SRR}"_2.fastq
  rm -rf "$SRR"
  echo ">>> Done with $SRR"
done

echo ">>> All samples ready:"
ls -lh