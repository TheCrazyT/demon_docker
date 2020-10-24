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
if [ "$?" != 0 ]
then
	exit 1
fi
rm -Rf demon_v2 2>/dev/null
conda activate demon

#tensorflow-gpu from conda-forge won't work (detects no gpu)
pip install tensorflow-gpu==1.4.0
if [ "$?" != "0" ]
then
	exit 1
fi

cd /
# Install minimal prerequisites (Ubuntu 18.04 as reference)
apt update && apt install -y wget unzip pkg-config libzstd1
if [ "$?" != "0" ]
then
	exit 1
fi
# Download and unpack sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.3.1.zip
if [ "$?" != "0" ]
then
	exit 1
fi

unzip opencv.zip
if [ "$?" != "0" ]
then
	exit 1
fi

# Create build directory
mkdir -p opencv_build && cd opencv_build
# Configure
cmake -DCUDA_ARCH_BIN="5.2" -DCUDA_ARCH_LIST="5.2" ../opencv-3.3.1
if [ "$?" != "0" ]
then
	exit 1
fi
# Build
cmake --build .
if [ "$?" != "0" ]
then
	exit 1
fi
make install
if [ "$?" != "0" ]
then
	exit 1
fi
cd /
rm opencv.zip
rm -Rf opencv-3.3.1


