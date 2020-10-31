FROM paperspace/dl-containers:tensorflow1140-py36-cu100-cdnn7-jupyter
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common wget cmake git g++ g++-5 gcc-5 g++-7 gcc-7
ENV MINICONDA_INSTALLER_SCRIPT=Miniconda3-latest-Linux-x86_64.sh
ENV MINICONDA_PREFIX=/usr/local
RUN wget https://repo.continuum.io/miniconda/$MINICONDA_INSTALLER_SCRIPT
RUN chmod +x $MINICONDA_INSTALLER_SCRIPT
RUN bash $MINICONDA_INSTALLER_SCRIPT -b -f -p $MINICONDA_PREFIX
RUN conda update -n base -c defaults conda
ADD environment.yml /
RUN git clone --recursive https://github.com/lmb-freiburg/demon.git && git clone --depth=1 https://github.com/lmb-freiburg/tfutils.git
RUN conda env create -f /environment.yml
RUN conda create --name tf-upg tensorflow==2.2.0 && conda init bash && bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate demon && conda list' && bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate tf-upg && /usr/local/envs/tf-upg/bin/tf_upgrade_v2 --intree /tfutils --inplace' && bash -c 'source /usr/local/etc/profile.d/conda.sh && conda activate tf-upg && /usr/local/envs/tf-upg/bin/tf_upgrade_v2 --intree /demon --outtree /demon_v2 --reportfile /report.txt' && bash -c 'source /usr/local/etc/profile.d/conda.sh && conda remove --name tf-upg --all'