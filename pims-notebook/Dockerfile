# Build as jupyterhub/singleuser
# Run with the DockerSpawner in JupyterHub

FROM jupyter/julia-notebook

MAINTAINER Ian Allison <iana@pims.math.ca>

EXPOSE 8888

USER root
# fetch juptyerhub-singleuser entrypoint
RUN wget -q https://raw.githubusercontent.com/jupyterhub/jupyterhub/0.6.1/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser && \
    chmod 755 /usr/local/bin/jupyterhub-singleuser

RUN apt-get update && apt-get install -y \
  build-essential \
  fonts-dejavu \
  python-dev \
  gfortran \
  libzmq5 \
  libzmq5-dev \
  less openssh-client zip \
  man git libxrender1 \
  pyqt4-dev-tools \
  gnupg procps && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# R
# R packages including IRKernel which gets installed globally.
# Pin r-base to a specific build number for https://github.com/jupyter/docker-stacks/issues/210#issuecomment-246081809
RUN conda config --add channels r && \
    conda install --quiet --yes \
    'rpy2=2.8*' \
    'r-base=3.3.1 1' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-devtools=1.11*' \
    'r-dplyr=0.4*' \
    'r-ggplot2=2.1*' \
    'r-tidyr=0.5*' \
    'r-shiny=0.13*' \
    'r-rmarkdown=0.9*' \
    'r-forecast=7.1*' \
    'r-stringr=1.0*' \
    'r-rsqlite=1.0*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-randomforest=4.6*' && conda clean -tipsy

RUN echo "deb http://www.deb-multimedia.org stretch main non-free" >> /etc/apt/sources.list
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 65558117
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan

RUN conda install --yes pyqt \
  beautifulsoup4 \
  html5lib \
  mpld3 \
  nltk && \
  conda clean -tipsy

RUN conda install --yes -c damianavila82 rise && \
  conda clean -tipsy

ADD requirements.txt /tmp/requirements.txt
# And the stuff that isn't in anaconda
RUN pip install -r /tmp/requirements.txt

# Python 2 stuff
ENV CONDA_PY2ENV "python2"
ENV CONDA_ACTIVATE_PY2 "source activate $CONDA_PY2ENV"
RUN conda install -y -n $CONDA_PY2ENV pyqt \
  boto3 botocore \
  beautifulsoup4 \
  html5lib \
  mpld3 \
  nltk && conda clean -tipsy

RUN bash -c "$CONDA_ACTIVATE_PY2 && pip install git+https://github.com/simpeg/simpeg.git"

ADD Rprofile.site /opt/conda/lib/R/etc/Rprofile.site


USER root
# Show Julia where conda libraries are
# Add essential packages
RUN apt-get update && apt-get -y install libhdf5-10 hdf5-tools && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN userdel jovyan
ENV SHELL /bin/bash

ADD systemuser.sh /srv/singleuser/systemuser.sh

CMD ["sh", "/srv/singleuser/systemuser.sh"]
