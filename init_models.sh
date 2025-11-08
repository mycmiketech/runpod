#!/bin/bash
# === RunPod ComfyUI Model Setup (Fixed) ===

echo "🔧 Setting up persistent model directories..."

# 1. Create model folders in your persistent storage (volume)
mkdir -p /runpod-volume/models/checkpoints
mkdir -p /runpod-volume/models/loras
mkdir -p /runpod-volume/models/controlnet
mkdir -p /runpod-volume/workflows
mkdir -p /runpod-volume/outputs

echo "✅ Created folders under /runpod-volume/models"

# 2. Make sure ComfyUI models folder exists
mkdir -p /workspace/ComfyUI/models

# 3. Create symlinks (force overwrite if exist)
ln -sfn /runpod-volume/models/checkpoints /workspace/ComfyUI/models/checkpoints
ln -sfn /runpod-volume/models/loras /workspace/ComfyUI/models/loras
ln -sfn /runpod-volume/models/controlnet /workspace/ComfyUI/models/controlnet

echo "✅ Symlinks created for checkpoints, loras, and controlnet"

# 4. Verify links
echo "🔍 Verifying symbolic links..."
ls -l /workspace/ComfyUI/models

# 5. Create test file to verify persistence
echo "test file" > /runpod-volume/models/test.txt

if [ -f /workspace/ComfyUI/models/test.txt ]; then
    echo "✅ Persistence check passed — linking is working!"
else
    echo "❌ Persistence check failed. Please verify /runpod-volume is mounted."
fi

echo "🎉 All done! You can now add models to /runpod-volume/models/"
