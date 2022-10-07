FROM bsceapm/asitedesign_base:3.0
MAINTAINER Albert Cañellas <albert.canellas@bsc.es>

ARG USER
ARG PASS

# Install PyRosetta
RUN conda config --add channels https://${USER}:${PASS}@conda.graylab.jhu.edu
RUN conda install pyrosetta=2020.20+release.c522e9e

WORKDIR /home/AsiteDesign
RUN python Setup.py build && \
    python Setup.py install

WORKDIR /home/projects
