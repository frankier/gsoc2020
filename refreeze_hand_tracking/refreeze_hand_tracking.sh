#!/usr/bin/env bash

git clone https://github.com/victordibia/handtracking.git || true
git clone https://github.com/tensorflow/models.git || true
cd models && docker build -f research/object_detection/dockerfiles/tf1/Dockerfile -t export-graph . && cd ..

rm -rf ./handtracking/model-checkpoint/ssdlitemobilenetv2/hand_inference_graph/saved_model || true

docker run \
    --mount type=bind,source="$(pwd)"/handtracking/model-checkpoint/ssdlitemobilenetv2,target=/checkpoints \
    export-graph python object_detection/export_inference_graph.py \
    --input_type image_tensor \
    --pipeline_config_path /checkpoints/pipeline.config \
    --trained_checkpoint_prefix /checkpoints/model.ckpt \
    --output_directory /checkpoints/refrozen

mv ./handtracking/model-checkpoint/ssdlitemobilenetv2/refrozen/frozen_inference_graph.pb refrozen_inference_graph.pb
