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

# Julia dependencies
RUN mkdir -p /opt/julia-0.5.0 && \
  curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.0-linux-x86_64.tar.gz | tar -C /opt/julia-0.5.0 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.5.0 /opt/julia-0.5
RUN rm -f /opt/julia && ln -fs /opt/julia-0.5.0 /opt/julia
RUN ln -fs /opt/julia/bin/julia /usr/bin/julia
RUN chown -R $NB_USER /opt/julia-0.5.0

# Install packages as NB_USER
USER $NB_USER

RUN JULIA_PKGDIR="/opt/julia-0.5.0/share/julia/site" julia -e 'Pkg.init(); Pkg.add("IJulia"); Pkg.add("PyPlot"); Pkg.add("Interact"); Pkg.add("Colors"); Pkg.add("SymPy"); Pkg.add("PyCall"); Pkg.add("Gadfly"); Pkg.add("RDatasets"); Pkg.add("HDF5"); Pkg.build("IJulia"); Pkg.build("PyPlot"); Pkg.build("Gadfly")'
RUN echo 'push!(Base.LOAD_CACHE_PATH, "/opt/julia-0.5.0/share/julia/site/lib/v0.5")' >> /opt/julia-0.5.0/etc/julia/juliarc.jl
RUN echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /opt/julia-0.5.0/etc/julia/juliarc.jl

RUN mv $HOME/.local/share/jupyter/kernels/julia-0.5 $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local

# Not sure why, but these files end up rw only for NB_USER
RUN chmod -R go+r /opt/julia-0.5.0/share/julia/site/lib/v0.5
