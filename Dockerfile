FROM ubuntu:latest
MAINTAINER Albert Cañellas <albert.canellas@bsc.es>
#FROM continuumio/miniconda3

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
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Install
RUN pip3 install ipython biotite

# Extract
# RUN echo "https://USERNAME:PASSWORD@conda.graylab.jhu.edu" >>
ADD PyRosetta4.Release.python37.ubuntu.release-324.tar.bz2 .
RUN cd PyRosetta4.Release.python37.ubuntu.release-324/setup/ && \
    python setup.py install

# Install conda packages
#RUN conda create --name edesign
#RUN conda activate edesign && \
#RUN sed '/conda activate base/d' ~/.bashrc # no funciona idk why
#RUN echo "conda activate edesign" >> ~/.bashrc
RUN conda install -c omnia -c conda-forge mpi openmm pyyaml mpi4py psutil #mdanalysis

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
