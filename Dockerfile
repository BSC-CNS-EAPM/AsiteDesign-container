FROM continuumio/miniconda3
MAINTAINER Albert Cañellas <albert.canellas@bsc.es>
#FROM continuumio/miniconda3

# Update to latest packages
RUN apt update && apt upgrade -y && \
    apt install bzip2 zip gcc libopenmpi-dev -y

# Install PyRosetta from source
ARG USER
ARG PASS
ENV USER=$USER
ENV PASS=$PASS
ENV PYTHONPATH=/home/EDesign_p
ENV PATH=/home/EDesign_p:$PATH

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
RUN pip install mpi4py

#Install fftw
RUN wget http://www.fftw.org/fftw-3.3.10.tar.gz && \
    tar xfz fftw-* && \
    rm fftw-3.3.10.tar.gz && \
    cd fftw-3.3.10 && \
    ./configure && \
    make && \
    make install

# Install miniconda
#ENV CONDA_DIR /opt/conda
#RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh && \
#    /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
#ENV PATH=$CONDA_DIR/bin:$PATH

# Install openm
RUN conda create --name edesign
RUN conda init bash
#RUN echo "conda activate edesign" >> ~/.bashrc
RUN conda activate edesign
RUN conda install -c omnia -c conda-forge openmm yaml

# Install EDisgn
ADD EDesign_p.tar.gz /home
WORKDIR /home/EDesign_p
RUN python Setup.py build && \
    python Setup.py install

WORKDIR /home/hostDirectory
# Command to run at start of container
#CMD ["sh", "-c", "python -m ActiveSiteDesign $1.yaml > $1.out"]
