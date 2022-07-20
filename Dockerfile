FROM ubuntu:latest

# Update to latest packages
RUN apt update && apt upgrade -y && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update && \
    apt install python-setuptools wget bzip2 git gcc python3.7 python-is-python3 -y

# Install PyRosetta from source
ARG USER
ARG PASS
ENV USER=$USER
ENV PASS=$PASS

WORKDIR /home
RUN wget https://${USER}:${PASS}@graylab.jhu.edu/download/PyRosetta4/archive/release/PyRosetta4.Release.python27.ubuntu/PyRosetta4.Release.python27.ubuntu.release-305.tar.bz2

# Extract
RUN tar -xvjf PyRosetta4.Release.python27.ubuntu.release-305.tar.bz2
RUN rm PyRosetta4.Release.python27.ubuntu.release-305.tar.bz2
RUN cd PyRosetta4.Release.python27.ubuntu.release-305/setup/ && \
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
    ./configure && \
    make && \
    make install

# Install openmm
ADD openmm-master.zip .
RUN cd openmm* && \
    ./install.sh && \
    python -m simtk.testInstallation

# Install EDisgn
ADD EDesign_p-main.zip .
RUN cd EDesing_* && \
    python Setup.py
