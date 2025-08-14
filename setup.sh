#!/usr/bin/env bash
set -e
python -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
if [ -f requirements.txt ]; then
  python -m pip install -r requirements.txt
else
  python -m pip install huggingface_hub safetensors
fi
