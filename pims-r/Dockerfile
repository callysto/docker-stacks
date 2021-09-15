ARG BASE_CONTAINER=callysto/pims-minimal
FROM $BASE_CONTAINER

LABEL maintainer="Ian Allison <iana@pims.math.ca>"

# Configure environment
ENV NB_USER=jovyan
ENV HOME=/home/$NB_USER
USER $NB_USER
WORKDIR $HOME

# R
RUN mamba install --quiet --yes \
    'gxx_linux-64' \
    'gmp' \
    'mpfr' \
    'r-base' \
    'r-essentials' \
    'r-gmp' \
    'r-irkernel' \
    'r-plyr' \
    'r-devtools' \
    'r-dplyr' \
    'r-ggplot2' \
    'r-ggally' \
    'r-hmisc' \
    'r-tidyr' \
    'r-languageserver' \
    'r-lsmeans' \
    'r-shiny' \
    'r-rmarkdown' \
    'r-forecast' \
    'r-stringr' \
    'r-stringi' \
    'r-rsqlite' \
    'r-reshape2' \
    'r-nycflights13' \
    'r-car' \
    'r-caret' \
    'r-rcurl' \
    'r-crayon' \
    'r-testthat' \
    'r-tidyverse' \
    'r-randomforest' \
    'r-janitor' \
    'r-palmerpenguins' \
    && mamba clean --all -f -y

COPY Rprofile.site /opt/conda/lib/R/etc/Rprofile.site

RUN Rscript -e "install.packages('repurrsive', dependencies=TRUE)" && \
  Rscript -e "install.packages('canlang', dependencies=TRUE)"

USER jupyter
# Configure environment
ENV NB_USER=jupyter \
    NB_UID=9999
ENV HOME=/home/$NB_USER
WORKDIR $HOME
