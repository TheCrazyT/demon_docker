#!/bin/bash
cd /
apt-get update
apt-get install -y git wget unzip pkg-config libzstd1 cuda-libraries-10-0 cuda-libraries-dev-10-0
if [ "$?" != "0" ]
then
	exit 1
fi

echo '#########find / -name "libtensorflow_framework.so*###########'
find / -name "libtensorflow_framework.so*"
echo '#########find / -name "libnpps*.so*###########'
find / -name "libnpps*.so*"
echo '#########find / -name "libcublas*.so*###########'
find / -name "libcublas*.so*"
echo '#########find / -name "libcuda*.so*###########'
find / -name "libcuda*.so*"
echo '#########find / -name "libcudnn*.so*###########'
find / -name "libcudnn*.so*"
echo '#########find / -name "libcufft*.so*###########'
find / -name "libcufft*.so*"
echo '#########ls /usr/lib/x86_64-linux-gnu/libcu*.so*###########'
ls /usr/lib/x86_64-linux-gnu/libcu*.so*
echo '#########ls /usr/local/cuda-10.0/targets/x86_64-linux/lib/###########'
ls /usr/local/cuda-10.0/targets/x86_64-linux/lib/
echo '#########ls /usr/bin/gcc-*###########'
ls /usr/bin/gcc-*
echo '#########ls /usr/bin/g++-*###########'
ls /usr/bin/g++-*


DEMON_DIR=$PWD/demon
DEMON_DIR2=$PWD/demon_v2

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

cd /

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

ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppc.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppc.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppial.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppial.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppicc.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppicc.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppicom.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppicom.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppidei.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppidei.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppif.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppif.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppig.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppig.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppim.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppim.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppist.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppist.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppisu.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppisu.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppitc.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppitc.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnpps.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libnpps.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libcufft.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libcufft.so
ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libcublas.so.10.0 /usr/local/cuda-10.0/targets/x86_64-linux/lib/libcublas.so

# Create build directory
mkdir -p opencv_build && cd opencv_build
# Configure
cmake -DCUDA_nppc_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppc.so.10.0 -DCUDA_nppial_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppial.so.10.0 -DCUDA_nppicc_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppicc.so.10.0 -DCUDA_nppicom_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppicom.so.10.0 -DCUDA_nppidei_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppidei.so.10.0 -DCUDA_nppif_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppif.so.10.0 -DCUDA_nppig_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppig.so.10.0 -DCUDA_nppim_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppim.so.10.0 -DCUDA_nppist_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppist.so.10.0 -DCUDA_nppisu_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppisu.so.10.0 -DCUDA_nppitc_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnppitc.so.10.0 -DCUDA_npps_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libnpps.so.10.0 -DCUDA_cufft_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libcufft.so.10.0 -DCUDA_cublas_LIBRARY=/usr/local/cuda-10.0/targets/x86_64-linux/lib/libcublas.so.10.0 -DCUDA_ARCH_BIN="5.2" -DCUDA_ARCH_LIST="5.2" ../opencv-3.3.1
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
