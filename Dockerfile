FROM ubuntu:xenial

# Update to latest packages
RUN apt-get update && \
    apt-get install ipython python-setuptools wget bzip2 git gcc python3.7 -y

# Install PyRosetta from source
RUN wget https://USERNAME:PASSWORD@graylab.jhu.edu/download/PyRosetta4/archive/release/PyRosetta4.Release.python27.ubuntu/PyRosetta4.Release.python27.ubuntu.release-184.tar.bz2

# Extract
RUN tar -xvjf PyRosetta4.Release.python27.ubuntu.release-184.tar.bz2 && \
    rm PyRosetta4.Release.python27.ubuntu.release-184.tar.bz2 && \
    cd PyRosetta4.Release.python27.ubuntu.release-184/setup/ && \
    python setup.py install

# Install biotite
RUN pip install biotite

# Install MDAnalysis
pip install --upgrade MDAnalysis

# Install mpi4py
python -m pip install mpi4py

#Install OpenMM
RUN wget http://www.fftw.org/fftw-3.3.10.tar.gz && \
    tar xfz fftw-* && \
    ./configure && \
    make && \
    make install

ADD openmm-master.zip
RUN cd openmm* && \
    ./install.sh && \
    python -m simtk.testInstallation
