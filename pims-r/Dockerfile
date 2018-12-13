# Build as jupyterhub/singleuser
# Run with the DockerSpawner in JupyterHub

FROM callysto/pims-minimal

MAINTAINER Ian Allison <iana@pims.math.ca>

# Configure environment
ENV NB_USER=jovyan
ENV HOME=/home/$NB_USER
USER $NB_USER

# R
RUN conda config --add channels r && \
    conda install --quiet --yes \
    'gxx_linux-64' \
    'gmp' \
    'mpfr' \
    'r-base=3.5*' \
    'r-essentials=3.5*' \
    'r-gmp' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-dplyr=0.7*' \
    'r-ggplot2=3.0*' \
    'r-tidyr=0.8*' \
    'r-lsmeans' \
    'r-shiny=1.1*' \
    'r-rmarkdown=1.10*' \
    'r-forecast=8.4*' \
    'r-stringr=1.3*' \
    'r-stringi=1.2*' \
    'r-rsqlite=2.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=1.0*' \
    'r-car=3.0*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-tidyverse=1.2*' \
    'r-randomforest=4.6*' && conda clean -tipsy

COPY Rprofile.site /opt/conda/lib/R/etc/Rprofile.site

USER jupyter
# Configure environment
ENV NB_USER=jupyter \
    NB_UID=9999
ENV HOME=/home/$NB_USER

