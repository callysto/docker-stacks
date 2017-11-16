# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/scipy-notebook

MAINTAINER Ian Allison <iana@pims.math.ca>

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
RUN mkdir ipopt && cd ipopt && wget  http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.8.tgz && \
    tar -xzf Ipopt-3.12.8.tgz && cd Ipopt-3.12.8 && \
    cd ThirdParty/Blas && ./get.Blas && ./configure --prefix=/usr/local --disable-shared --with-pic && make install && cd ../.. && \
    cd ThirdParty/Lapack && ./get.Lapack && ./configure --prefix=/usr/local --disable-shared --with-pic && make install && cd ../.. && \
    cd ThirdParty/Mumps && ./get.Mumps && cd ../ASL && ./get.ASL && cd ../.. && \
    env LIBS='-lgfortran' ./configure --prefix=/usr/local --enable-dependency-linking coin_skip_warn_cxxflags=yes --with-blas=/usr/local/lib/libcoinblas.a --with-lapack=/usr/local/lib/libcoinlapack.a && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/ipopt.conf && ldconfig && \
    cd ../.. && \
    rm -rf ipopt

RUN mkdir cbc && cd cbc && wget http://www.coin-or.org/download/source/Cbc/Cbc-2.9.9.tgz && \
    tar -xzf Cbc-2.9.9.tgz && cd Cbc-2.9.9 && \
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
RUN mkdir stan && cd stan && wget https://github.com/stan-dev/cmdstan/releases/download/v2.17.0/cmdstan-2.17.0.tar.gz && \
    tar -xzvf cmdstan-2.17.0.tar.gz && mv cmdstan-2.17.0 /usr/share/cmdstan && \
    (cd /usr/share/cmdstan && echo "CC=g++" >> make/local && echo "CXX=g++" >> make/local && make build) && \
    echo "export CMDSTAN_HOME=/usr/share/cmdstan" > /etc/profile.d/cmdstan.sh && \
    chmod 755 /etc/profile.d/cmdstan.sh && \
    cd .. && \
    rm -rf stan

# Nemo
RUN apt-get update && \
    apt-get install -y \
    m4 \
    yasm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir mpir && cd mpir && wget http://mpir.org/mpir-3.0.0.tar.bz2 && \
    tar -xvf mpir-3.0.0.tar.bz2 && cd mpir-3.0.0 && \
    ./configure M4=/usr/bin/m4 --enable-gmpcompat --disable-static --enable-shared && \
    make && make install && \
    cd ../.. && \
    rm -rf mpir

RUN mkdir mpfr && cd mpfr && wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.6.tar.bz2 && \
    tar -xvf mpfr-3.1.6.tar.bz2 && cd mpfr-3.1.6 && \
    ./configure --with-gmp=/usr/local --disable-static --enable-shared && \
    make && make install && \
    cd ../.. && \
    rm -rf mpfr

RUN mkdir flint2 && cd flint2 && git clone https://github.com/ianabc/flint2 && \
    cd flint2 && \
    ./configure --disable-static --enable-shared --with-mpir --with-mpfr && \
    make && make install && \
    cd ../.. && \
    rm -rf flint2

# Julia 
RUN mkdir -p /opt/julia-0.6.1 && \
  curl -s -L https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz | tar -C /opt/julia-0.6.1 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.6.1 /opt/julia-0.6
RUN rm -f /opt/julia && ln -fs /opt/julia-0.6.1 /opt/julia
RUN ln -fs /opt/julia/bin/julia /usr/bin/julia
RUN chown -R 1000:100 /opt/julia-0.6.1

# Cairo Build deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libacl1-dev \
    gettext \
    zlib1g-dev \
    libffi-dev \
    libpng-dev \
    libpixman-1-dev \
    libpoppler-dev \
    librsvg2-dev \
    libcairo2-dev \
    libpango1.0-0 \
    tk-dev \
    pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install packages as NB_USER
USER $NB_USER

RUN echo 'push!(Base.LOAD_CACHE_PATH, "/opt/julia-0.6/share/julia/site/lib/v0.6")' >> /opt/julia-0.6/etc/julia/juliarc.jl
RUN echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /opt/julia-0.6/etc/julia/juliarc.jl
RUN mkdir -p /home/$NB_USER/.config/matplotlib && echo "backend: Agg" >> /home/$NB_USER/.config/matplotlib/matplotlibrc
ADD package-installs.jl /tmp/package-installs.jl
RUN JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia /tmp/package-installs.jl && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"BinDeps\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Cairo\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Calculus\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Clustering\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Clp\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Colors\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"DataArrays\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"DataFrames\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"DataFramesMeta\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Dates\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"DecisionTree\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Distributions\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Distances\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"GLM\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"GraphLayout\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"HDF5\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"HypothesisTests\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Ipopt\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"JSON\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"KernelDensity\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Lazy\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"MLBase\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"MultivariateStats\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"NLopt\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"NMF\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Optim\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"ODE\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Patchwork\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"PDMats\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"PGFPlots\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"PyCall\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"PyPlot\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Quandl\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"QuantEcon\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"RDatasets\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"SQLite\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Stan\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"StatsBase\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Sundials\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"TextAnalysis\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"TimeSeries\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"ZipFile\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"MLBase\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"Clustering\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Pkg.add(\"IJulia\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Pkg.build(\"IJulia\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"IJulia\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"ZMQ\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "Base.compilecache(\"ZMQ\")" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "import Plots" && \
    LD_LIBRARY_PATH=/opt/conda/lib JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "import PyPlot" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "import IJulia" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "import DataFrames" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "import Optim" && \
    JULIA_PKGDIR=/opt/julia-0.6/share/julia/site julia -e "import KernelDensity"


RUN mv $HOME/.local/share/jupyter/kernels/julia-0.6 $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local

# Not sure why, but these files end up rw only for NB_USER
RUN chmod -R go+r /opt/julia-0.6/share/julia/site/lib/v0.6
