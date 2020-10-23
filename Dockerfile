FROM nvidia/cuda:8.0-devel-ubuntu16.04
RUN apt update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y python3 cmake git g++ g++-5 gcc-5
RUN apt install wget
ENV MINICONDA_INSTALLER_SCRIPT=Miniconda3-latest-Linux-x86_64.sh
ENV MINICONDA_PREFIX=/usr/local
RUN wget https://repo.continuum.io/miniconda/$MINICONDA_INSTALLER_SCRIPT
RUN chmod +x $MINICONDA_INSTALLER_SCRIPT
RUN bash $MINICONDA_INSTALLER_SCRIPT -b -f -p $MINICONDA_PREFIX
RUN conda update -n base -c defaults conda
ADD environment.yml /
RUN conda env create -f /environment.yml
RUN conda create --name tf-upg tensorflow==2.2.0
RUN conda init bash
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && conda list'
RUN git clone --recursive https://github.com/lmb-freiburg/demon.git
RUN git clone --depth=1 https://github.com/lmb-freiburg/tfutils.git
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate tf-upg && /usr/local/envs/tf-upg/bin/tf_upgrade_v2 --intree /tfutils --inplace'
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate tf-upg && /usr/local/envs/tf-upg/bin/tf_upgrade_v2 --intree /demon --outtree /demon_v2 --reportfile /report.txt'
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda remove --name tf-upg --all'
ADD prepare.sh /
RUN bash /prepare.sh
ADD build_lmspecialops.sh /
RUN bash /build_lmspecialops.sh
ADD build_multivih5datareader.sh /
RUN bash /build_multivih5datareader.sh
#Test import
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so PYTHONPATH=$PYTHONPATH:/tfutils/python/tfutils:/tfutils/python:/demon_v2/lmbspecialops/python:/demon_v2/python/depthmotionnet/v2:/demon_v2/python LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow python -c "import lmbspecialops"'
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && MULTIVIH5DATAREADEROP_LIB=/demon_v2/build/multivih5datareaderop/multivih5datareaderop.so PYTHONPATH=/demon_v2/python/depthmotionnet python -c "import datareader"'
ENV PYTHONPATH=:/demon_v2/python/:/demon_v2/lmbspecialops/python:/tfutils/python
ENV LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so
ENV MULTIVIH5DATAREADEROP_LIB=/demon_v2/build/multivih5datareaderop/multivih5datareaderop.so
RUN find /demon_v2/build ! -name 'multivih5datareaderop.so' -type f -exec rm -f {} +
RUN find /demon_v2/lmbspecialops/build ! -name 'lmbspecialops.so' -type f -exec rm -f {} +
ENV WANDB_MODE=dryrun
RUN apt install -y python3-pip
RUN python3 -m pip install jupyterlab wandb
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so
RUN bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && pip install wandb
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y nvidia-450 || true
EXPOSE 8888
CMD jupyter-lab --ip="*" --no-browser --allow-root