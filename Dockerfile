FROM ubuntu:latest
#FROM continuumio/miniconda3

# Update to latest packages
RUN apt update && apt upgrade -y && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update && \
    apt install python-setuptools wget bzip2 zip git gcc python3.7 libopenmpi-dev python3-distutils python3-dev python3-pip python-is-python3 -y

# Install PyRosetta from source
ARG USER
ARG PASS
ENV USER=$USER
ENV PASS=$PASS

# Set the workind directory
WORKDIR /home

RUN pip install --upgrade pip wheel

# Install
RUN pip install ipython

# Extract
ADD PyRosetta4.Release.python37.ubuntu.release-324.tar.bz2 .
RUN cd PyRosetta4.Release.python37.ubuntu.release-324/setup/ && \
    python setup.py install

# Install biotite
RUN pip install biotite

# Install MDAnalysis
RUN pip install --upgrade MDAnalysis

# Install mpi4py
RUN python -m pip install mpi4py

#Install OpenMM
RUN wget http://www.fftw.org/fftw-3.3.10.tar.gz && \
    tar xfz fftw-* && \
    rm fftw-3.3.10.tar.gz && \
    cd fftw-3.3.10 && \
    ./configure && \
    make && \
    make install

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Install openmm
RUN conda install -c omnia openmm && \
    python -m simtk.testInstallation

# Install EDisgn
ADD EDesign_p-main.tar.gz .
RUN cd EDesign_* && \
    python Setup.py build && \
    python Setup.py install


#CMD ["/bin/bash"]
