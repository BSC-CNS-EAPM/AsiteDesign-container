################## BASE IMAGE ######################

FROM bsceapm/asitedesign_base:5.0

################## METADATA ######################

LABEL maintainer="Albert Cañellas-Sole <albert.canellas@bsc.es>" \
    container="AsiteDesign" \
    about.summary="design catalytic residues, perform in silico directed evolution of an existing active site." \
    about.home="https://github.com/masoudk/AsiteDesign" \
    software.version="1.0"

################## INSTALLATION ######################

ARG USER
ARG PASS

# Install PyRosetta
RUN conda config --add channels https://${USER}:${PASS}@conda.graylab.jhu.edu
RUN conda install pyrosetta=2020.20+release.c522e9e

WORKDIR /home/AsiteDesign
RUN python Setup.py build && \
    python Setup.py install

WORKDIR /home/projects
