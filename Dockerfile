FROM ubuntu:latest
MAINTAINER Albert Cañellas <albert.canellas@bsc.es>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Update to latest packages
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git zip gcc libopenmpi-dev python3-pip -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PyRosetta from source
ARG USER
ARG PASS
ENV USER=$USER
ENV PASS=$PASS
ENV PYTHONPATH=/home/EDesign_p
ENV PATH=/home/EDesign_p:$PATH

# Set the workind directory
WORKDIR /home

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

# Install PyRosetta
RUN conda config --add channels https://${USER}:${PASS}@conda.graylab.jhu.edu
RUN conda install pyrosetta=2020.20+release.c522e9e

# Extra packages
RUN pip install biotite MDAnalysis

# Install conda packages
RUN conda install -c omnia -c conda-forge biopython cython mpi4py
RUN rm /opt/conda/lib/python3.7/site-packages/MDAnalysis/lib/nsgrid.cpython-37m-x86_64-linux-gnu.so
ADD nsgrid.cpython-37m-x86_64-linux-gnu.so /opt/conda/lib/python3.7/site-packages/MDAnalysis/lib/

#Install fftw
RUN wget http://www.fftw.org/fftw-3.3.10.tar.gz && \
    tar xfz fftw-* && \
    rm fftw-3.3.10.tar.gz && \
    cd fftw-3.3.10 && \
    ./configure && \
    make && \
    make install

# Install AsiteDesign
RUN git clone https://github.com/masoudk/AsiteDesign.git /home
WORKDIR /home/AsiteDesign
RUN python Setup.py build && \
    python Setup.py install

WORKDIR /home/projects
