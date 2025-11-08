#!/bin/bash
# === RunPod Startup Script ===
# Auto setup ComfyUI + Jupyter with persistent storage
# Updated for Flux Dev, Wan 2.2, ControlNet (Depth + Canny)

set -e

echo "[startup] Checking Python..."
if ! command -v python &> /dev/null; then
    echo "[startup] Linking python -> python3..."
    ln -sf $(which python3) /usr/bin/python
fi

echo "[startup] Creating persistent directories..."
mkdir -p /runpod-volume/{models,workflows,outputs,logs,scripts}
mkdir -p /runpod-volume/models/{checkpoints,lora,controlnet,flux,wan,sdxl}

echo "[startup] Ensuring ComfyUI model folders exist..."
mkdir -p /workspace/ComfyUI/models

# Remove old links if they exist
rm -f /workspace/ComfyUI/models/checkpoints
rm -f /workspace/ComfyUI/models/loras
rm -f /workspace/ComfyUI/models/controlnet

# Create symbolic links to persistent storage
ln -s /runpod-volume/models/checkpoints /workspace/ComfyUI/models/checkpoints
ln -s /runpod-volume/models/lora /workspace/ComfyUI/models/loras
ln -s /runpod-volume/models/controlnet /workspace/ComfyUI/models/controlnet

echo "[startup] Setting permissions..."
chmod -R 755 /runpod-volume/models

echo "[startup] Starting ComfyUI..."
nohup python3 /workspace/ComfyUI/main.py --port 8188 > /workspace/logs/comfyui.log 2>&1 &

echo "[startup] Checking Jupyter installation..."
if ! command -v jupyter &> /dev/null; then
    echo "[startup] Installing Jupyter..."
    pip install notebook
fi

echo "[startup] Starting Jupyter Notebook..."
nohup jupyter notebook \
  --notebook-dir=/runpod-volume \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root > /workspace/logs/jupyter.log 2>&1 &

echo "[startup] Waiting 5s before checking logs..."
sleep 5
echo "[startup] ComfyUI log tail:"
tail -n 10 /workspace/logs/comfyui.log

echo "[startup] Jupyter should now be running on port 8888."
echo "[startup] ComfyUI should now be running on port 8188."
