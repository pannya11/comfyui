#!/usr/bin/env bash
echo "=== ComfyUI robust start script ==="
PY=python3

# Try to create/activate venv; if not allowed, proceed with system python
if [ ! -d "venv" ]; then
  if $PY -m venv venv 2>/dev/null; then
    source venv/bin/activate
  else
    echo "venv not available — using system python"
  fi
else
  source venv/bin/activate || echo "Could not activate venv; continuing with system python"
fi

# make sure pip is available
$PY -m pip install --upgrade pip setuptools wheel || echo "pip upgrade failed (non-fatal)"

# install requirements (may take several minutes)
if [ -f requirements.txt ]; then
  $PY -m pip install -r requirements.txt 2>&1 | tee pip_install.log || echo "pip install had errors; see pip_install.log"
fi

# ensure key packages
$PY -m pip install huggingface_hub safetensors 2>&1 | tee -a pip_install.log || echo "could not install huggingface_hub/safetensors (non-fatal)"

PORT="${PORT:-8188}"
echo "Starting ComfyUI on port $PORT (logs -> comfy_run.log)"
$PY main.py --listen --port "$PORT" 2>&1 | tee comfy_run.log
