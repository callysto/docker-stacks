#!/bin/bash
set -e

if [[ -z $NB_USER ]]; then
  echo "NB_USER is not set"
  exit 1
fi

if [[ -z $NB_UID ]]; then
  echo "NB_UID is not set"
  exit 1
fi

if getent passwd $NB_UID > /dev/null ; then
  echo "$NB_USER ($NB_UID) exists"
else
  echo "Creating user $NB_USER ($NB_UID)"
  useradd -u $NB_UID -s $SHELL $NB_USER
fi

notebook_arg=""
if [[ -n "${NOTEBOOK_DIR:+x}" ]]; then
    notebook_arg="--notebook-dir=${NOTEBOOK_DIR}"
fi

if [[ ! -z $JUPYTERHUB_API_TOKEN ]]; then
  sudo -E PATH="${CONDA_DIR}/bin:$PATH" -E LD_LIBRARY_PATH="${CONDA_DIR}/lib" -u $NB_USER jupyterhub-singleuser \
    ${notebook_arg} \
    $@
else
  . /usr/local/bin/start.sh jupyter notebook $*
fi
