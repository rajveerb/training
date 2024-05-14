#!/bin/bash

LOG_FILE_PATH=${1}

# Runs benchmark and reports time to convergence

if [ $# -eq 1 ]; then 
       if [ ! -d "./p3torch_logs" ]; then
              mkdir ./p3torch_logs
       fi
       cd pytorch
       # Single GPU training
       echo "One epoch has 58634 iterations with below batch size configuration"
       time python tools/train_mlperf.py --config-file "configs/e2e_mask_rcnn_R_50_FPN_1x.yaml" \
              SOLVER.IMS_PER_BATCH 2 TEST.IMS_PER_BATCH 1 SOLVER.MAX_ITER 720000 SOLVER.STEPS "(480000, 640000)" SOLVER.BASE_LR 0.0025 \
              PREPROCESSING.LOG_FILE_PATH "../p3torch_logs/vtune_included"
       cd ..
else
       cd pytorch
       echo "One epoch has 58634 iterations with below batch size configuration"
       time python tools/train_mlperf.py --config-file "configs/e2e_mask_rcnn_R_50_FPN_1x.yaml" \
              SOLVER.IMS_PER_BATCH 2 TEST.IMS_PER_BATCH 1 SOLVER.MAX_ITER 720000 SOLVER.STEPS "(480000, 640000)" SOLVER.BASE_LR 0.0025
       cd ..
fi
