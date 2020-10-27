FROM crazyt/demon:base
ENV CUDA_DIR_NAME=cuda-10.0
ADD prepare.sh /
RUN bash /prepare.sh
RUN apt-get update && apt-get install -y gcc-4.9 g++-4.9
ADD build_lmspecialops.sh /
RUN bash /build_lmspecialops.sh
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && conda install h5py'
ADD build_multivih5datareader.sh /
RUN bash /build_multivih5datareader.sh
#Test import
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/ LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so PYTHONPATH=$PYTHONPATH:/tfutils/python/tfutils:/tfutils/python:/demon_v2/lmbspecialops/python:/demon_v2/python/depthmotionnet/v2:/demon_v2/python LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow python -c "import lmbspecialops"'
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && LD_LIBRARY_PATH=/usr/local/$CUDA_DIR_NAME/targets/x86_64-linux/lib/stubs/ MULTIVIH5DATAREADEROP_LIB=/demon_v2/build/multivih5datareaderop/multivih5datareaderop.so PYTHONPATH=/demon_v2/python/depthmotionnet python -c "import datareader"'
ENV PYTHONPATH=:/demon_v2/python/:/demon_v2/lmbspecialops/python:/tfutils/python
ENV LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so
ENV MULTIVIH5DATAREADEROP_LIB=/demon_v2/build/multivih5datareaderop/multivih5datareaderop.so
RUN find /demon_v2/build ! -name 'multivih5datareaderop.so' -type f -exec rm -f {} +
RUN find /demon_v2/lmbspecialops/build ! -name 'lmbspecialops.so' -type f -exec rm -f {} +
ENV WANDB_MODE=dryrun
RUN apt install -y python3-pip
RUN python3 -m pip install jupyterlab wandb
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && pip install wandb'



RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y nvidia-450=450.36.06-0ubuntu1 || true
EXPOSE 8888
CMD jupyter-lab --ip="*" --no-browser --allow-root