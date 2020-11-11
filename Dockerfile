FROM paperspace/dl-containers:2.0.0-gpu-py3-jupyter-lab-scipy-pillow
RUN add-apt-repository --yes ppa:ubuntu-toolchain-r/test
RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common cmake g++ g++-4.8 gcc-4.8 g++-5 gcc-5 g++-7 gcc-7
RUN apt update \
	&& cd / \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git \
	&& git clone --recursive https://github.com/lmb-freiburg/demon.git \
	&& git clone --depth=1 https://github.com/lmb-freiburg/tfutils.git \
	&& apt remove --auto-remove -y git \
	&& tf_upgrade_v2 --intree /tfutils --inplace --reportfile /report_tfutils.txt \
	&& tf_upgrade_v2 --intree /demon --outtree /demon_v2 --reportfile /report_demon.txt
