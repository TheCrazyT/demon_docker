#!/bin/bash
DEMON_DIR=$PWD/demon
DEMON_DIR2=$PWD/demon_v2


echo '#########find / -name "libcublas*.so*"###########'
find / -name "libcublas*.so*"

sed -i "s/import tensorflow/import tensorflow as tf/" demon/python/depthmotionnet/datareader/__init__.py
sed -i "s/tensorflow\./tf\./" demon/python/depthmotionnet/datareader/__init__.py
cd $DEMON_DIR/lmbspecialops
git checkout master
git status
python3 -m pip install --upgrade keyrings.alt
rm -Rf demon_v2 2>/dev/null

cd /
# Install minimal prerequisites (Ubuntu 18.04 as reference)
apt update && apt install -y wget unzip pkg-config libzstd1
# Download and unpack sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.3.1.zip
unzip opencv.zip
# Create build directory
mkdir -p opencv_build && cd opencv_build
# Configure
cmake -DCUDA_ARCH_LIST="7.0" ../opencv-3.3.1
# Build
cmake --build .
make install
cd /
rm opencv.zip
rm -Rf opencv-3.3.1


