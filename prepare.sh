#!/bin/bash

apt-get update
apt-get install -y git wget unzip pkg-config libzstd1
if [ "$?" != "0" ]
then
	exit 1
fi

DEMON_DIR=$PWD/demon
DEMON_DIR2=$PWD/demon_v2
source /usr/local/etc/profile.d/conda.sh
conda activate demon
sed -i "s/import tensorflow/import tensorflow as tf/" demon_v2/python/depthmotionnet/datareader/__init__.py
sed -i "s/tensorflow\./tf\./" demon_v2/python/depthmotionnet/datareader/__init__.py
cd $DEMON_DIR/lmbspecialops
git checkout master
git pull origin master
if [ "$?" != 0 ]
then
	exit 1
fi
git status
echo grep PIEH src/decode_flo_op.cc
grep PIEH src/decode_flo_op.cc
cp -R $DEMON_DIR/lmbspecialops $DEMON_DIR2/


cd $DEMON_DIR2/lmbspecialops


python3 -m pip install --upgrade keyrings.alt
if [ "$?" != 0 ]
then
	exit 1
fi
rm -Rf demon_v2 2>/dev/null
conda activate demon

cd /
# Install minimal prerequisites (Ubuntu 18.04 as reference)
apt update
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
	echo opencv install failed
	exit 1
fi
cd /
rm opencv.zip
rm -Rf opencv-3.3.1
rm -Rf opencv_build
#apt remove -y git wget unzip pkg-config libzstd1
#if [ "$?" != "0" ]
#then
#	exit 1
#fi
apt remove -y git wget
if [ "$?" != "0" ]
then
	exit 1
fi
