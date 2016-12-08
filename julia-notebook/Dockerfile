# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/scipy-notebook

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gnupg2 \
    dirmngr \
    curl \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Sundials
RUN apt-get update && \ 
    apt-get install -y --no-install-recommends \
    libsundials-cvode1 \
    libsundials-cvodes2 \
    libsundials-ida2 \
    libsundials-idas0 \
    libsundials-kinsol1 \
    libsundials-nvecserial0 \
    libsundials-serial \
    libsundials-serial-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# NLopt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnlopt0 \
    libnlopt-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Ipopt
RUN mkdir ipopt && cd ipopt && wget  http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.1.tgz && \
    tar -xzf Ipopt-3.12.1.tgz && cd Ipopt-3.12.1 && \
    cd ThirdParty/Blas && ./get.Blas && ./configure --prefix=/usr/local --disable-shared --with-pic && make install && cd ../.. && \
    cd ThirdParty/Lapack && ./get.Lapack && ./configure --prefix=/usr/local --disable-shared --with-pic && make install && cd ../.. && \
    cd ThirdParty/Mumps && ./get.Mumps && cd ../ASL && ./get.ASL && cd ../.. && \
    env LIBS='-lgfortran' ./configure --prefix=/usr/local --enable-dependency-linking coin_skip_warn_cxxflags=yes --with-blas=/usr/local/lib/libcoinblas.a --with-lapack=/usr/local/lib/libcoinlapack.a && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/ipopt.conf && ldconfig && \
    cd ../.. && \
    rm -rf ipopt

RUN mkdir cbc && cd cbc && wget http://www.coin-or.org/download/source/Cbc/Cbc-2.8.12.tgz && \
    tar -xzf Cbc-2.8.12.tgz && cd Cbc-2.8.12 && \
    ./configure --prefix=/usr/local --enable-dependency-linking --without-blas --without-lapack --enable-cbc-parallel && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/cbc.conf && ldconfig && \
    cd ../.. && \
    rm -rf cbc

# MPI
RUN apt-get update && \
    apt-get install -y \
    openmpi-bin \
    libopenmpi-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Stan
RUN mkdir stan && cd stan && wget https://github.com/stan-dev/cmdstan/releases/download/v2.5.0/cmdstan-2.5.0.tar.gz && \
    tar -xzvf cmdstan-2.5.0.tar.gz && mv cmdstan /usr/share/cmdstan && \
    (cd /usr/share/cmdstan && make build) && \
    echo "export CMDSTAN_HOME=/usr/share/cmdstan" > /etc/profile.d/cmdstan.sh && \
    chmod 755 /etc/profile.d/cmdstan.sh && \
    cd .. && \
    rm -rf stan

# Nemo
RUN apt-get update && \
    apt-get install -y \
    m4 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir mpir && cd mpir && wget http://mpir.org/mpir-2.7.2.tar.bz2 && \
    tar -xvf mpir-2.7.2.tar.bz2 && cd mpir-2.7.2 && \
    ./configure M4=/usr/bin/m4 --enable-gmpcompat --disable-static --enable-shared && \
    make && make install && \
    cd ../.. && \
    rm -rf mpir

RUN mkdir mpfr && cd mpfr && wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.3.tar.bz2 && \
    tar -xvf mpfr-3.1.3.tar.bz2 && cd mpfr-3.1.3 && \
    ./configure --with-gmp=/usr/local --disable-static --enable-shared && \
    make && make install && \
    cd ../.. && \
    rm -rf mpfr

RUN mkdir flint2 && cd flint2 && git clone https://github.com/ianabc/flint2.git && \
    cd flint2 && \
    ./configure --disable-static --enable-shared --with-mpir --with-mpfr && \
    make && make install && \
    cd ../.. && \
    rm -rf flint2

# Julia dependencies
RUN mkdir -p /opt/julia-0.5.0 && \
  curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.0-linux-x86_64.tar.gz | tar -C /opt/julia-0.5.0 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.5.0 /opt/julia-0.5
RUN rm -f /opt/julia && ln -fs /opt/julia-0.5.0 /opt/julia
RUN ln -fs /opt/julia/bin/julia /usr/bin/julia
RUN chown -R $NB_USER /opt/julia-0.5.0


# Install packages as NB_USER
USER $NB_USER

RUN echo 'push!(Base.LOAD_CACHE_PATH, "/opt/julia-0.5.0/share/julia/site/lib/v0.5")' >> /opt/julia-0.5.0/etc/julia/juliarc.jl
RUN echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /opt/julia-0.5.0/etc/julia/juliarc.jl

ADD julia_packages.sh /tmp/julia_packages.sh
RUN /tmp/julia_packages.sh

RUN mv $HOME/.local/share/jupyter/kernels/julia-0.5 $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local

# Not sure why, but these files end up rw only for NB_USER
RUN chmod -R go+r /opt/julia-0.5.0/share/julia/site/lib/v0.5
