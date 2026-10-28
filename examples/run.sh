#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_hf_voice info
PYTHONPATH=src python -m gbt_hf_voice check --payload '{}'
PYTHONPATH=src python -m gbt_hf_voice run   --payload '{}'
