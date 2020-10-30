#!/bin/bash
source /usr/local/etc/profile.d/conda.sh
conda activate demon


echo '######find -name "Dense"'
find / -name "Dense"

echo '######find -name "opencv.hpp"'
find / -name "opencv.hpp"

echo '######find -name "*opencv*"'
find / -name "*opencv*"
ls -la /opencv_build

sed -i s/get_gpu_count\(\)/1/g /demon_v2/training/v2/training.py
(echo "#include <iostream>" && cat /demon_v2/multivih5datareaderop/multivih5datareader.h) > /tmp/multivih5datareader.h
cp /tmp/multivih5datareader.h /demon_v2/multivih5datareaderop/multivih5datareader.h
export DEMON_DIR=/demon_v2
cd $DEMON_DIR # change to the demon root directory
rm -Rf build > /dev/null
mkdir build
cd build
#cmake -DCMAKE_BUILD_TYPE=Release -UCMAKE_CXX_STANDARD -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" -DTENSORFLOW_INCLUDE_DIR=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so.1 -DPYTHON_EXECUTABLE=/usr/local/envs/demon/bin/python3.6 ..
LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/ cmake -DCMAKE_BUILD_TYPE=Release -UCMAKE_CXX_STANDARD -DCMAKE_C_FLAGS="-I/usr/local/include" -DCMAKE_CXX_FLAGS="-I/usr/local/include -D_GLIBCXX_USE_CXX11_ABI=0" -DTENSORFLOW_INCLUDE_DIR=/usr/local/lib/python3.6/dist-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/lib/python3.6/dist-packages/tensorflow/libtensorflow_framework.so -DPYTHON_EXECUTABLE=/usr/bin/python3.6 ..
if [ "$?" != "0" ]
then
	exit 1
fi

make clean
if [ "$CORES" != "" ]
then
	make VERBOSE=1 -j $CORES
	if [ "$?" != "0" ]
	then
		exit 1
	fi
else
	make VERBOSE=1
	if [ "$?" != "0" ]
	then
		exit 1
	fi
fi
