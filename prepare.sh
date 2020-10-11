#!/bin/bash
DEMON_DIR=$PWD/demon
DEMON_DIR2=$PWD/demon_v2
source /usr/local/etc/profile.d/conda.sh
conda activate demon
sed -i "s/import tensorflow/import tensorflow as tf/" demon/python/depthmotionnet/datareader/__init__.py
sed -i "s/tensorflow\./tf\./" demon/python/depthmotionnet/datareader/__init__.py
cd $DEMON_DIR/lmbspecialops
git checkout master
git status
python3 -m pip install --upgrade keyrings.alt
rm -Rf demon_v2 2>/dev/null
conda activate tf-upg
tf_upgrade_v2 --intree $DEMON_DIR --outtree $DEMON_DIR2 --reportfile report.txt