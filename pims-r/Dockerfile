ARG BASE_CONTAINER=callysto/pims-minimal
FROM $BASE_CONTAINER

LABEL maintainer="Ian Allison <iana@pims.math.ca>"

# Configure environment
ENV NB_USER=jovyan
ENV HOME=/home/$NB_USER
USER $NB_USER

# R
RUN conda install --quiet --yes \
    'gxx_linux-64' \
    'gmp' \
    'mpfr' \
    'r-base=4.0*' \
    'r-essentials=4.0*' \
    'r-gmp=0.6' \
    'r-irkernel=1.1*' \
    'r-plyr=1.8*' \
    'r-devtools=2.3*' \
    'r-dplyr=1.0*' \
    'r-ggplot2=3.3*' \
    'r-ggally=2.0*' \
    'r-hmisc=4.4*' \
    'r-tidyr=1.1*' \
    'r-lsmeans=2.30*' \
    'r-shiny=1.5*' \
    'r-rmarkdown=2.5*' \
    'r-forecast=8.13*' \
    'r-stringr=1.4*' \
    'r-stringi=1.5*' \
    'r-rsqlite=2.2*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=1.0*' \
    'r-car=3.0*' \
    'r-caret=6.0*' \
    'r-rcurl=1.98*' \
    'r-crayon=1.3*' \
    'r-testthat=2.3*' \
    'r-tidyverse=1.3*' \
    'r-randomforest=4.6*' && conda clean --all -f -y

COPY Rprofile.site /opt/conda/lib/R/etc/Rprofile.site

USER jupyter
# Configure environment
ENV NB_USER=jupyter \
    NB_UID=9999
ENV HOME=/home/$NB_USER

