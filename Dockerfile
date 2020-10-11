FROM ubuntu
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y python3 cmake git g++ g++-7 gcc-7
RUN apt install wget
ENV MINICONDA_INSTALLER_SCRIPT=Miniconda3-latest-Linux-x86_64.sh
ENV MINICONDA_PREFIX=/usr/local
RUN wget https://repo.continuum.io/miniconda/$MINICONDA_INSTALLER_SCRIPT
RUN chmod +x $MINICONDA_INSTALLER_SCRIPT
RUN bash $MINICONDA_INSTALLER_SCRIPT -b -f -p $MINICONDA_PREFIX
ADD environment.yml /
RUN conda env create -f /environment.yml
RUN git clone --recursive https://github.com/lmb-freiburg/demon.git
RUN conda env create --name tf-upg tensorflow
RUN conda init bash
ADD prepare.sh /
RUN bash /prepare.sh
ADD build_lmspecialops.sh /
RUN bash /build_lmspecialops.sh
ADD build_multivih5datareader.sh /
RUN bash /build_multivih5datareader.sh
RUN git clone --depth=1 https://github.com/lmb-freiburg/tfutils.git
RUN source /usr/local/etc/profile.d/conda.sh && conda activate tf-upg && tf_upgrade_v2 --intree /tfutils --inplace
#Test it
RUN LMBSPECIALOPS_LIB=/demon_v2/lmbspecialops/build/lib/lmbspecialops.so PYTHONPATH=$PYTHONPATH:/tfutils/python/tfutils:/tfutils/python:/demon_v2/lmbspecialops/python:/demon_v2/python/depthmotionnet/v2:/demon_v2/python LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/envs/demon/lib/python3.6/site-packages/tensorflow python -c "import lmbspecialops"
ENTRYPOINT /bin/bash