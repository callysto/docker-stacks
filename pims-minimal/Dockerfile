FROM jupyter/scipy-notebook

MAINTAINER Ian Allison <iana@pims.math.ca>

RUN conda install --yes astropy \
  atlas \
  boto \
  beautifulsoup4 \
  gfortran_linux-64 \
  gmp \
  gmaps \
  keras \
  html5lib \
  lapack \
  markdown \
  mpfr \
  mpld3 \
  nltk \
  pyqt \
  tensorflow \
  lxml && \
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
 && apt-key adv --keyserver pgp.mit.edu --recv-keys 65558117 \
 && apt-get update && apt-get install -y ffmpeg && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY pip.conf /etc/pip.conf

ENV SHELL /bin/bash

COPY systemuser.sh /srv/singleuser/systemuser.sh

CMD ["sh", "/srv/singleuser/systemuser.sh"]

RUN mkdir -p /opt/notebook/local_templates && mkdir -p /etc/jupyter
COPY notebook.html /opt/notebook/local_templates/notebook.html
COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN mkdir -p /home/$NB_USER/.config/matplotlib \
  && echo "backend: Agg" >> /home/$NB_USER/.config/matplotlib/matplotlibrc
