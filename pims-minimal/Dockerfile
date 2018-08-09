FROM callysto/scipy-notebook

MAINTAINER Ian Allison <iana@pims.math.ca>

RUN conda install --yes astropy \
  atlas \
  boto \
  beautifulsoup4 \
  cartopy \
  colorlover \
  cvxopt \
  geos \
  gfortran_linux-64 \
  gmp \
  gmaps \
  keras \
  html5lib \
  imageio \
  lapack \
  markdown \
  mpfr \
  mpld3 \
  nltk \
  pandas=0.22* \
  plotly \
  proj4 \
  pyqt \
  pysal \
  qgrid \
  rdflib \
  tensorflow \
  textblob \
  lxml && \
  conda remove --quiet --yes --force qt pyqt && \
  conda clean -tipsy

RUN conda install --yes -c damianavila82 rise && \
  conda clean -tipsy

COPY requirements.txt /tmp/requirements.txt
# And the stuff that isn't in anaconda
RUN pip install -r /tmp/requirements.txt

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
RUN jupyter lab build

RUN pip install git+https://github.com/data-8/nbgitpuller \
 && jupyter serverextension enable --sys-prefix nbgitpuller

RUN mkdir -p /home/$NB_USER/.config/matplotlib \
  && echo "backend: Agg" >> /home/$NB_USER/.config/matplotlib/matplotlibrc

USER root
# fetch juptyerhub-singleuser entrypoint
RUN wget -q https://raw.githubusercontent.com/jupyterhub/jupyterhub/0.8.1/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser && \
    chmod 755 /usr/local/bin/jupyterhub-singleuser

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  fonts-dejavu \
  python-dev \
  hdf5-tools \
  libhdf5-100 \
  libgmp-dev \
  libmpfr-dev \
  libzmq5 \
  libzmq5-dev \
  libssl-dev \
  less openssh-client zip \
  man git libxrender1 \
  pyqt4-dev-tools \
  gnupg procps && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /bin/tar /bin/gtar

RUN REPO="http://www.deb-multimedia.org stretch main non-free" \
 && echo "deb $REPO stretch main non-free" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 65558117 \
 && apt-get update && apt-get install -y ffmpeg && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY pip.conf /etc/pip.conf

ENV SHELL /bin/bash

COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN useradd -m -s /bin/bash -N -u 9999 jupyter
USER jupyter
# Configure environment
ENV NB_USER=jupyter \
    NB_UID=9999
ENV HOME=/home/$NB_USER
WORKDIR $HOME

