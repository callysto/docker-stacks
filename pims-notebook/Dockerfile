# Build as jupyterhub/singleuser
# Run with the DockerSpawner in JupyterHub

FROM jupyter/datascience-notebook

MAINTAINER Ian Allison <iana@pims.math.ca>

EXPOSE 8888

USER root
# fetch juptyerhub-singleuser entrypoint
RUN wget -q https://raw.githubusercontent.com/jupyterhub/jupyterhub/0.6.1/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser && \
    chmod 755 /usr/local/bin/jupyterhub-singleuser

RUN apt-get update && apt-get install -y \
  build-essential \
  python-dev \
  gfortran \
  libzmq5 \
  libzmq5-dev \
  less openssh-client zip \
  man git libxrender1 \
  pyqt4-dev-tools \
  gnupg procps && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

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
RUN JULIA_PKGDIR="/usr/share/julia/site" julia -e 'Pkg.init(); Pkg.add("IJulia"); Pkg.add("Gadfly"); Pkg.add("RDatasets"); Pkg.add("HDF5")'
RUN echo "push!(Base.DL_LOAD_PATH, \"$CONDA_DIR/lib\"); push!(Base.LOAD_PATH, \"/usr/share/julia/site/v0.4\"); push!(Base.LOAD_CACHE_PATH, \"/usr/share/julia/site/lib/v0.4\")" > /etc/julia/juliarc.jl
RUN sed -i 's?/home/jovyan/.julia?/usr/share/julia/site?' /opt/conda/share/jupyter/kernels/julia-0.4/kernel.json 
RUN chmod -R go+r /usr/share/julia/site

RUN apt-get update && apt-get -y upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN userdel jovyan
ENV SHELL /bin/bash

ADD systemuser.sh /srv/singleuser/systemuser.sh

CMD ["sh", "/srv/singleuser/systemuser.sh"]
