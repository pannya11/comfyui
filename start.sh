#!/usr/bin/env bash
echo "=== ComfyUI start (Studio-safe) ==="
PY=python3

# Try to create and use a venv, but fall back if not possible
if [ ! -d "venv" ]; then
  if $PY -m venv venv 2>/dev/null; then
    source venv/bin/activate
    echo "Activated venv"
  else
    echo "Could not create venv — using system python"
  fi
else
  source venv/bin/activate || echo "Could not activate venv — using system python"
fi

# Upgrade pip
$PY -m pip install --upgrade pip setuptools wheel

# Install all requirements
if [ -f requirements.txt ]; then
  echo "Installing Python requirements..."
  $PY -m pip install --prefer-binary --no-cache-dir -r requirements.txt
fi

PORT="${PORT:-8188}"
echo "Starting ComfyUI (logs -> comfy_run.log)"
$PY main.py --listen --port "$PORT" 2>&1 | tee comfy_run.log
