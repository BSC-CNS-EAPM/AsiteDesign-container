FROM continuumio/miniconda3
MAINTAINER Albert Cañellas <albert.canellas@bsc.es>
#FROM continuumio/miniconda3

# Update to latest packages
RUN apt update && apt upgrade -y && \
    apt install bzip2 zip gcc libopenmpi-dev python3-pip -y

# Install PyRosetta from source
ARG USER
ARG PASS
ENV USER=$USER
ENV PASS=$PASS
ENV PYTHONPATH=/home/EDesign_p
ENV PATH=/home/EDesign_p:$PATH

# Set the workind directory
WORKDIR /home

RUN conda update -n base -c defaults conda

RUN pip3 install --upgrade wheel MDAnalysis

# Install
RUN pip3 install ipython biotite

# Extract
# RUN echo "https://USERNAME:PASSWORD@conda.graylab.jhu.edu" >>
ADD PyRosetta4.Release.python37.ubuntu.release-324.tar.bz2 .
RUN cd PyRosetta4.Release.python37.ubuntu.release-324/setup/ && \
    python setup.py install

# Install conda packages

RUN conda create --name edesign
#RUN conda activate edesign && \
RUN sed '/conda activate base/d' ~/.bashrc # no funciona idk why
RUN echo "conda activate edesign" >> ~/.bashrc
RUN conda install -c omnia -c conda-forge openmm yaml mpi4py python=3.7

#Install fftw
RUN wget http://www.fftw.org/fftw-3.3.10.tar.gz && \
    tar xfz fftw-* && \
    rm fftw-3.3.10.tar.gz && \
    cd fftw-3.3.10 && \
    ./configure && \
    make && \
    make install

# Install EDisgn
ADD EDesign_p.tar.gz /home
WORKDIR /home/EDesign_p
RUN python Setup.py build && \
    python Setup.py install

WORKDIR /home/hostDirectory
# Command to run at start of container
#CMD ["sh", "-c", "python -m ActiveSiteDesign $1.yaml > $1.out"]
