#!/bin/bash
cd /
grep PIEH /demon/lmbspecialops/src/decode_flo_op.cc

cp -R /demon/lmbspecialops /demon_v2/
rm -Rf /demon_v2/lmbspecialops/build 2>/dev/null
cd /demon_v2/lmbspecialops/

grep PIEH src/decode_flo_op.cc

mkdir /demon_v2/lmbspecialops/build
cd /demon_v2/lmbspecialops/build



#cmake -DCMAKE_C_COMPILER=/usr/bin/gcc-7 -DCMAKE_CXX_COMPILER=/usr/bin/g++-7 -DTENSORFLOW_INCLUDE_DIR=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so.1 -DCUDA_ARCH_LIST="7.0" -DCMAKE_LINK_WHAT_YOU_USE=1 -UCMAKE_CXX_STANDARD -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" -DPYTHON_EXECUTABLE=/usr/local/envs/demon/bin/python3.6 ..
#ln -s /usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so.1 /usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so
#cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_C_COMPILER=/usr/bin/gcc-7 -DCMAKE_CXX_COMPILER=/usr/bin/g++-7 -DTENSORFLOW_INCLUDE_DIR=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so -DCUDA_ARCH_LIST="7.0" -DCMAKE_LINK_WHAT_YOU_USE=1 -UCMAKE_CXX_STANDARD -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" -DPYTHON_EXECUTABLE=/usr/local/envs/demon/bin/python3.6 ..
ln -s /usr/local/lib/python3.6/dist-packages/tensorflow_core/libtensorflow_framework.so.2 /usr/local/lib/python3.6/dist-packages/tensorflow/libtensorflow_framework.so
ln -s /usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/libcuda.so /usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/libcuda.so.1
LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/ cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=/usr/bin/gcc-4.8 -DCMAKE_CXX_COMPILER=/usr/bin/g++-4.8 -DTENSORFLOW_INCLUDE_DIR=/usr/local/lib/python3.6/dist-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/lib/python3.6/dist-packages/tensorflow/libtensorflow_framework.so -DCUDA_ARCH_LIST="5.2" -DCMAKE_LINK_WHAT_YOU_USE=1 -UCMAKE_CXX_STANDARD -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" -DPYTHON_EXECUTABLE=/usr/bin/python3.6 ..
if [ "$?" != "0" ]
then
	exit 1
fi

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