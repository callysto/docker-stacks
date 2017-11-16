# Build as jupyterhub/singleuser
# Run with the DockerSpawner in JupyterHub

FROM jupyter/julia-notebook

MAINTAINER Ian Allison <iana@pims.math.ca>

EXPOSE 8888

USER root
# fetch juptyerhub-singleuser entrypoint
RUN wget -q https://raw.githubusercontent.com/jupyterhub/jupyterhub/0.8.1/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser && \
    chmod 755 /usr/local/bin/jupyterhub-singleuser

RUN apt-get update && apt-get install -y \
  build-essential \
  fonts-dejavu \
  python-dev \
  gfortran \
  libzmq5 \
  libzmq5-dev \
  libssl-dev \
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
    'r-base=3.4.2' \
    'r-essentials=1.7*' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-dplyr=0.7*' \
    'r-ggplot2=2.2*' \
    'r-tidyr=0.7*' \
    'r-shiny=1.0*' \
    'r-rmarkdown=1.6*' \
    'r-forecast=8.2*' \
    'r-stringr=1.2*' \
    'r-stringi=1.1*' \
    'r-rsqlite=2.0*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-tidyverse=1.1*' \
    'r-randomforest=4.6*' && conda clean -tipsy

RUN echo "deb http://www.deb-multimedia.org stretch main non-free" >> /etc/apt/sources.list
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 65558117
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan

RUN conda install --yes atlas \
  boto \
  beautifulsoup4 \
  gmaps \
  keras \
  html5lib \
  lapack \
  markdown \
  mpld3 \
  nltk \
  pyqt \
  tensorflow && \
  conda clean -tipsy

RUN conda install --yes -c damianavila82 rise && \
  conda clean -tipsy

ADD requirements.txt /tmp/requirements.txt
# And the stuff that isn't in anaconda
RUN pip install -r /tmp/requirements.txt

ADD Rprofile.site /opt/conda/lib/R/etc/Rprofile.site

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix

# Install but don't enable
RUN jupyter labextension install @jupyterlab/google-drive
RUN jupyter labextension disable @jupyterlab/google-drive

USER root

ADD pip.conf /etc/pip.conf

# Show Julia where conda libraries are
# Add essential packages
RUN apt-get update && apt-get -y install libhdf5-100 hdf5-tools && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN userdel jovyan
ENV SHELL /bin/bash

ADD systemuser.sh /srv/singleuser/systemuser.sh

CMD ["sh", "/srv/singleuser/systemuser.sh"]

RUN mkdir -p /opt/notebook/local_templates
ADD notebook.html /opt/notebook/local_templates/notebook.html
RUN mkdir -p /etc/jupyter
ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
