FROM jupyter/pims-minimal

MAINTAINER Ian Allison <iana@pims.math.ca>

# Sundials, NLopt, MPI, Nemo, Cairo
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsundials-cvode1 \ 
    libsundials-cvodes2 \
    libsundials-ida2 \
    libsundials-idas0 \
    libsundials-kinsol1 \
    libsundials-nvecserial0 \
    libsundials-serial \
    libsundials-serial-dev \
    libnlopt0 \
    libnlopt-dev \
    openmpi-bin \
    libopenmpi-dev \
    m4 \
    yasm \
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

# Ipopt
RUN mkdir -p /opt/ipopt \
  && curl -s -L http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.8.tgz | \
     tar -C /opt/ipopt -x -z --strip-components=1 -f - \
  && cd /opt/ipopt/ThirdParty/Blas && ./get.Blas \
  && ./configure --prefix=/usr/local --disable-shared --with-pic \
  && make install \
  && cd /opt/ipopt/ThirdParty/Lapack && ./get.Lapack \
  && ./configure --prefix=/usr/local --disable-shared --with-pic \
  && make install \
  && cd /opt/ipopt/ThirdParty/Mumps && ./get.Mumps \
  && cd /opt/ipopt/ThirdParty/ASL && ./get.ASL && cd /opt/ipopt \
  && env LIBS='-lgfortran' ./configure --prefix=/usr/local \
    --enable-dependency-linking \
  && make install && echo "/usr/local/lib" > /etc/ld.so.conf.d/ipopt.conf \
  && ldconfig && rm -rf /opt/ipopt

# CBC
RUN mkdir -p /opt/cbc \
  && curl -s -L http://www.coin-or.org/download/source/Cbc/Cbc-2.9.9.tgz | \
     tar -C /opt/cbc -x -z --strip-components=1 -f - \
  && cd /opt/cbc \
  && ./configure --prefix=/usr/local \
    --enable-dependency-linking \
    --without-blas \
    --without-lapack \
    --enable-cbc-parallel \
  && make install && echo "/usr/local/lib" > /etc/ld.so.conf.d/cbc.conf \
  && ldconfig && rm -rf /opt/cbc

# Stan
RUN mkdir -p /opt/cmdstan \
  && curl -s -L https://github.com/stan-dev/cmdstan/releases/download/v2.17.0/cmdstan-2.17.0.tar.gz | \
     tar -C /opt/cmdstan -x -z --strip-components=1 -f - \
  && (cd /opt/cmdstan && echo "CC=g++" >> make/local && echo "CXX=g++" >> make/local && make build) \
  && echo "export CMDSTAN_HOME=/usr/share/cmdstan" > /etc/profile.d/cmdstan.sh \
  && chmod 755 /etc/profile.d/cmdstan.sh \
  && rm -rf /opt/stan

# MPIR
RUN mkdir -p /opt/mpir \
  && curl -s -L http://mpir.org/mpir-3.0.0.tar.bz2 | \
     tar -C /opt/mpir -x -j --strip-components=1 -f - \
  && cd /opt/mpir \
  && ./configure M4=/usr/bin/m4 --enable-gmpcompat --disable-static --enable-shared \
  && make && make install \
  && rm -rf /opt/mpir

# MPFR
RUN mkdir -p /opt/mpfr \
  && cd /opt/mpfr \
  && curl -s -L http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.6.tar.bz2 | \
     tar -C /opt/mpfr -x -j --strip-components=1 -f - \
  && cd /opt/mpfr \
  && ./configure --with-gmp=/usr/local --disable-static --enable-shared \
  && make && make install \
  && rm -rf /opt/mpfr

# Flint2
RUN mkdir -p /opt/flint2 \
  && cd /opt/flint2 \
  && git clone https://github.com/ianabc/flint2 /opt/flint2 \
  && cd /opt/flint2 \
  && ./configure --disable-static --enable-shared --with-mpir --with-mpfr \
  && make && make install \
  &&  rm -rf /opt/flint2

# Julia 
RUN mkdir -p /opt/julia-0.6.2 \
  && curl -s -L https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz | \
     tar -C /opt/julia-0.6.2 -x -z --strip-components=1 -f - \
  && ln -fs /opt/julia-0.6.2 /opt/julia-0.6 \ 
  && rm -rf /opt/julia && ln -fs /opt/julia-0.6.2 /opt/julia \
  && ln -fs /opt/julia/bin/julia /usr/bin/julia \
  && chown -R $NB_USER /opt/julia-0.6.2


# Install packages as NB_USER
USER $NB_USER

RUN echo 'push!(Base.LOAD_CACHE_PATH, "/opt/julia-0.6/share/julia/site/lib/v0.6")' \
     >> /opt/julia-0.6/etc/julia/juliarc.jl \
  && echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" \
     >> /opt/julia-0.6/etc/julia/juliarc.jl

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


RUN mv $HOME/.local/share/jupyter/kernels/julia-0.6 $CONDA_DIR/share/jupyter/kernels/ \
  && chmod -R go+rx $CONDA_DIR/share/jupyter \
  && chmod -R go+r /opt/julia-0.6/share/julia/site/lib/v0.6 \
  && rm -rf $HOME/.local
