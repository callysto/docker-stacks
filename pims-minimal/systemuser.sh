#!/bin/sh
set -e
if getent passwd $USER_ID > /dev/null ; then
  echo "$USER ($USER_ID) exists"
else
  echo "Creating user $USER ($USER_ID)"
  useradd -u $USER_ID -s $SHELL $USER
fi

notebook_arg=""
if [ -n "${NOTEBOOK_DIR:+x}" ]
then
    notebook_arg="--notebook-dir=${NOTEBOOK_DIR}"
fi

sudo -E PATH="${CONDA_DIR}/bin:$PATH" -E LD_LIBRARY_PATH="${CONDA_DIR}/lib" -u $USER jupyterhub-singleuser \
  ${notebook_arg} \
  $@

