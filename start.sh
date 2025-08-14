#!/usr/bin/env bash
set -euo pipefail
PY=python3

# create venv if missing
if [ ! -d "venv" ]; then
  $PY -m venv venv
fi
source venv/bin/activate

pip install --upgrade pip setuptools

if [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

PORT="${PORT:-8188}"
echo "Starting ComfyUI on port $PORT (logs -> comfy_run.log)"
python main.py --listen --port "$PORT" 2>&1 | tee comfy_run.log
