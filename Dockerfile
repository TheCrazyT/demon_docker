FROM crazyt/demon:base_tf2
ENV CUDA_DIR_NAME=cuda-10.0
ADD prepare.sh /
RUN bash /prepare.sh
ADD build_lmspecialops.sh /
RUN bash /build_lmspecialops.sh && find /demon_v2/lmbspecialops/build ! -name 'lmbspecialops.so' -type f -exec rm -f {} +
RUN pip install h5py
ADD build_multivih5datareader.sh /
RUN bash /build_multivih5datareader.sh \
	&& find /demon_v2/build ! -name 'multivih5datareaderop.so' -type f -exec rm -f {} +
RUN python3.6 -c "import tensorflow"
#Test import
#RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/:/usr/local/lib/python3.6/dist-packages/tensorflow LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so PYTHONPATH=$PYTHONPATH:/tfutils/python/tfutils:/tfutils/python:/demon_v2/lmbspecialops/python:/demon_v2/python/depthmotionnet/v2:/demon_v2/python python3.6 -c "import lmbspecialops"'
#RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/ MULTIVIH5DATAREADEROP_LIB=/demon_v2/build/multivih5datareaderop/multivih5datareaderop.so PYTHONPATH=/demon_v2/python/depthmotionnet python3.6 -c "import datareader"'
RUN bash -c 'LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/:/usr/local/lib/python3.6/dist-packages/tensorflow LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so PYTHONPATH=$PYTHONPATH:/tfutils/python/tfutils:/tfutils/python:/demon_v2/lmbspecialops/python:/demon_v2/python/depthmotionnet/v2:/demon_v2/python python3.6 -c "import lmbspecialops"'
RUN bash -c 'LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/ MULTIVIH5DATAREADEROP_LIB=/demon_v2/build/multivih5datareaderop/multivih5datareaderop.so PYTHONPATH=/demon_v2/python/depthmotionnet python3.6 -c "import datareader"'
ENV PYTHONPATH=:/demon_v2/python/:/demon_v2/lmbspecialops/python:/tfutils/python
ENV LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so
ENV MULTIVIH5DATAREADEROP_LIB=/demon_v2/build/multivih5datareaderop/multivih5datareaderop.so
ENV WANDB_MODE=dryrun
RUN apt install -y python3-pip
RUN python3 -m pip install wandb
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so
RUN pip install wandb

EXPOSE 8888
CMD jupyter-lab --ip="*" --no-browser --allow-root