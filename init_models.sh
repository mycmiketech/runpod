#!/bin/bash
# === Model Initializer ===
# Checks for required model files and downloads any that are missing.

set -e
MODEL_DIR="/runpod-volume/models"

download_model () {
    local URL=$1
    local DEST=$2
    if [ ! -f "$DEST" ]; then
        echo "[init_models] Downloading $(basename "$DEST")..."
        wget -q --show-progress -O "$DEST" "$URL"
    else
        echo "[init_models] Found existing $(basename "$DEST"), skipping."
    fi
}

echo "[init_models] Checking and downloading base models..."

# Flux Dev SDXL
download_model "https://huggingface.co/lllyasviel/flux-dev-sdxl/resolve/main/flux-dev.safetensors" \
  "$MODEL_DIR/flux/flux-dev.safetensors"

# WAN 2.2 5B
download_model "https://huggingface.co/Waniverse/WAN-2.2/resolve/main/wan-v2.2-5b.safetensors" \
  "$MODEL_DIR/wan/wan-v2.2-5b.safetensors"

# SDXL Base & Refiner
download_model "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors" \
  "$MODEL_DIR/sdxl/sd_xl_base_1.0.safetensors"
download_model "https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors" \
  "$MODEL_DIR/sdxl/sd_xl_refiner_1.0.safetensors"

# ControlNet Depth + Canny
download_model "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth" \
  "$MODEL_DIR/controlnet/control_v11f1p_sd15_depth.pth"
download_model "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth" \
  "$MODEL_DIR/controlnet/control_v11p_sd15_canny.pth"

echo "[init_models] Model initialization complete."
