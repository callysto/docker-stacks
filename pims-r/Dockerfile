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
    'r-base=3.4.2' \
    'r-essentials=1.7*' \
    'r-gmp' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-dplyr=0.7*' \
    'r-ggplot2=2.2*' \
    'r-tidyr=0.7*' \
    'r-lsmeans' \
    'r-shiny=1.0*' \
    'r-rmarkdown=1.6*' \
    'r-forecast=8.2*' \
    'r-stringr=1.2*' \
    'r-stringi=1.1*' \
    'r-rsqlite=2.0*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-car=2.1*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-tidyverse=1.1*' \
    'r-randomforest=4.6*' && conda clean -tipsy

COPY Rprofile.site /opt/conda/lib/R/etc/Rprofile.site

USER jupyter
# Configure environment
ENV NB_USER=jupyter \
    NB_UID=9999
ENV HOME=/home/$NB_USER

