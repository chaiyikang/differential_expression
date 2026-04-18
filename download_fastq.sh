#!/usr/bin/env bash
# Download paired-end FASTQs for two samples from SRA.
# Run from the project root; files land in ./fastq/

set -euo pipefail

mkdir -p fastq
cd fastq

for SRR in SRR28499039 SRR28499036; do
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