# Build as jupyterhub/singleuser
# Run with the DockerSpawner in JupyterHub

FROM jupyter/pims-minimal

MAINTAINER Ian Allison <iana@pims.math.ca>

USER $NB_USER

RUN pip install git+https://github.com/data-8/nbgitpuller \
 && jupyter serverextension enable --sys-prefix nbgitpuller

USER root
