#!/bin/bash
source /usr/local/etc/profile.d/conda.sh
conda activate demon
rm -Rf /demon_v2/lmbspecialops/build 2>/dev/null
mkdir /demon_v2/lmbspecialops/build
cd /demon_v2/lmbspecialops/build

echo '#########find / -name "libcublas*.so*"###########'
find / -name "libcublas*.so*"
echo '#########find / -name "libcuda*.so*"###########'
find / -name "libcuda*.so*"
echo '#########find / -name "libcudnn*.so*"###########'
find / -name "libcudnn*.so*"
echo '#########ls /usr/bin/gcc-*###########'
ls /usr/bin/gcc-*
echo '#########ls /usr/bin/g++-*###########'
ls /usr/bin/g++-*


#cmake -DCMAKE_C_COMPILER=/usr/bin/gcc-7 -DCMAKE_CXX_COMPILER=/usr/bin/g++-7 -DTENSORFLOW_INCLUDE_DIR=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so.1 -DCUDA_ARCH_LIST="7.0" -DCMAKE_LINK_WHAT_YOU_USE=1 -UCMAKE_CXX_STANDARD -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" -DPYTHON_EXECUTABLE=/usr/local/envs/demon/bin/python3.6 ..
#ln -s /usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so.1 /usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so
#cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_C_COMPILER=/usr/bin/gcc-7 -DCMAKE_CXX_COMPILER=/usr/bin/g++-7 -DTENSORFLOW_INCLUDE_DIR=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so -DCUDA_ARCH_LIST="7.0" -DCMAKE_LINK_WHAT_YOU_USE=1 -UCMAKE_CXX_STANDARD -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" -DPYTHON_EXECUTABLE=/usr/local/envs/demon/bin/python3.6 ..
ln -s /usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so.1 /usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so
ln -s /usr/local/cuda-8.0/targets/x86_64-linux/lib/stubs/libcuda.so /usr/local/cuda-8.0/targets/x86_64-linux/lib/stubs/libcuda.so.1
LD_LIBRARY_PATH=/usr/local/cuda-8.0/targets/x86_64-linux/lib/stubs/ cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_C_COMPILER=/usr/bin/gcc-4.9 -DCMAKE_CXX_COMPILER=/usr/bin/g++-4.9 -DTENSORFLOW_INCLUDE_DIR=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/include -DTENSORFLOW_FRAMEWORK_LIB=/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow/libtensorflow_framework.so -DCUDA_ARCH_LIST="5.2" -DCMAKE_LINK_WHAT_YOU_USE=1 -UCMAKE_CXX_STANDARD -DCMAKE_CXX_FLAGS="-mno-avx512f -D_GLIBCXX_USE_CXX11_ABI=0" -DPYTHON_EXECUTABLE=/usr/local/envs/demon/bin/python3.6 ..
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
#cd /demon_v2/lmbspecialops/build/lib && /usr/bin/cmake -E cmake_link_script CMakeFiles/lmbspecialops.dir/link.txt --verbose=1
#/usr/bin/c++ -fPIC -D_GLIBCXX_USE_CXX11_ABI=0 -Wall -O3 -DNDEBUG -fopenmp -shared -Wl,-soname,lmbspecialops.so -o lmbspecialops.so CMakeFiles/lmbspecialops.dir/correlation.cc.o CMakeFiles/lmbspecialops.dir/correlation_1d.cc.o CMakeFiles/lmbspecialops.dir/decode_flo_op.cc.o CMakeFiles/lmbspecialops.dir/decode_lz4_op.cc.o CMakeFiles/lmbspecialops.dir/decode_lz4_raw_op.cc.o CMakeFiles/lmbspecialops.dir/decode_pfm_op.cc.o CMakeFiles/lmbspecialops.dir/decode_ppm_op.cc.o CMakeFiles/lmbspecialops.dir/decode_webp_op.cc.o CMakeFiles/lmbspecialops.dir/depthtoflow.cc.o CMakeFiles/lmbspecialops.dir/depthtonormals.cc.o CMakeFiles/lmbspecialops.dir/encode_flo_op.cc.o CMakeFiles/lmbspecialops.dir/encode_lz4_op.cc.o CMakeFiles/lmbspecialops.dir/encode_lz4_raw_op.cc.o CMakeFiles/lmbspecialops.dir/encode_pfm_op.cc.o CMakeFiles/lmbspecialops.dir/encode_webp_op.cc.o CMakeFiles/lmbspecialops.dir/flow_out_of_frame.cc.o CMakeFiles/lmbspecialops.dir/flowtodepth.cc.o CMakeFiles/lmbspecialops.dir/flowtodepth2.cc.o CMakeFiles/lmbspecialops.dir/flowwarp.cc.o CMakeFiles/lmbspecialops.dir/leakyrelu.cc.o CMakeFiles/lmbspecialops.dir/median3x3downsample.cc.o CMakeFiles/lmbspecialops.dir/replacenonfinite.cc.o CMakeFiles/lmbspecialops.dir/resample.cc.o CMakeFiles/lmbspecialops.dir/scaleinvariantgradient.cc.o CMakeFiles/lmbspecialops.dir/warp2d.cc.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_correlation_1d_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_correlation_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_depthtoflow_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_depthtonormals_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_flowwarp_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_leakyrelu_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_median3x3downsample_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_replacenonfinite_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_resample_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_rotation_format.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_scaleinvariantgradient_cuda.cu.o CMakeFiles/lmbspecialops.dir/lmbspecialops_generated_warp2d_cuda.cu.o  /usr/local/envs/demon/lib64/libcudart_static.a -lpthread -ldl -L/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow -l:libtensorflow_framework.so.1 -Wl,--no-as-needed /usr/lib/x86_64-linux-gnu/librt.so ../lz4/src/lz4-build/contrib/cmake_unofficial/liblz4.a ../webp/src/webp-build/src/.libs/libwebp.a