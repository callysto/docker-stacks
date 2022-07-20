ARG BASE_CONTAINER=callysto/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Ian Allison <iana@pims.math.ca>"

RUN mamba install --quiet --yes \
  altair \
  astropy \
  black \
  boto3 \
  beautifulsoup4 \
  biopython \
  cartopy \
  colorlover \
  cvxopt \
  flake8 \
  folium \
  fuzzywuzzy \
  geos \
  geopandas \
  geopy \
  gfortran_linux-64 \
  gmp \
  geopandas \
  googletrans \
  html5lib \
  imageio \
  ipysheet \
  ipycanvas \
  ipywidgets \
  lapack \
  markdown \
  mpfr \
  mpld3 \
  nbconvert \
  nbval \
  nltk \
  nodejs \
  openpyxl \
  pandas \
  plotly \
  proj \
  psutil \
  pyqt \
  pysal \
  pyspellchecker \
  pytest \
  pytrends \
  qgrid \
  rdflib \
  spacy \
  spacy-model-en_core_web_sm \
  spacy-model-en_core_web_md \
  spacy-model-en_core_web_lg \
  stats_can \
  tensorflow \
  textblob \
  textstat \
  tqdm \
  vega \
  vega_datasets \
  unidecode \
  wikipedia \
  wordcloud \
  lxml && \
  conda install rise && \
  mamba remove --quiet --yes --force qt pyqt && \
  mamba clean --all -f -y

COPY pip.conf /etc/pip.conf
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN jupyter nbextension enable --py callystonb --sys-prefix

RUN mkdir -p /home/$NB_USER/.config/matplotlib \
  && echo "backend: Agg" >> /home/$NB_USER/.config/matplotlib/matplotlibrc

USER root

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  dvipng \
  fonts-dejavu \
  python-dev \
  hdf5-tools \
  libhdf5-103 \
  libgmp-dev \
  libmpfr-dev \
  libzmq5 \
  libzmq5-dev \
  libssl-dev \
  less openssh-client zip \
  man git libxrender1 \
  pyqt5-dev-tools \
  gnupg procps tzdata vim && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /bin/tar /bin/gtar


ENV SHELL /bin/bash

COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN useradd -m -s /bin/bash -N -u 9999 jupyter
USER jupyter
# Configure environment
ENV NB_USER=jupyter \
    NB_UID=9999
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/ \
    HOME=/home/$NB_USER
WORKDIR $HOME
