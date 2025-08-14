#!/usr/bin/env bash
# Robust start script that works on Lightning Studio (no failing venv creation)
echo "=== ComfyUI robust start script ==="

PY=python3

# Try to create venv if allowed; if not allowed (Studio), continue using system python
if [ ! -d "venv" ]; then
  echo "Trying to create venv..."
  if $PY -m venv venv 2>/dev/null; then
    echo "venv created and will be used."
    source venv/bin/activate
  else
    echo "venv creation failed or not permitted — using system/conda python environment."
  fi
else
  # If venv exists, activate it; if activation fails, continue with system python
  source venv/bin/activate || echo "Could not activate venv, continuing with system python"
fi

# Ensure pip is up-to-date for the used python binary
$PY -m pip install --upgrade pip setuptools wheel || echo "warning: pip upgrade failed"

# Install requirements into the active environment (venv or Studio conda)
if [ -f requirements.txt ]; then
  echo "Installing python requirements (this may take a few minutes)..."
  $PY -m pip install -r requirements.txt 2>&1 | tee pip_install.log || echo "Some pip installs failed; see pip_install.log"
else
  echo "No requirements.txt found; continuing."
fi

# As a safety: ensure crucial packages present (non-fatal)
$PY -m pip install huggingface_hub safetensors 2>&1 | tee -a pip_install.log || echo "warning: could not install huggingface_hub/safetensors"

PORT="${PORT:-8188}"
echo "Starting ComfyUI on port $PORT (logs -> comfy_run.log)."
# Start app and log output
$PY main.py --listen --port "$PORT" 2>&1 | tee comfy_run.log
