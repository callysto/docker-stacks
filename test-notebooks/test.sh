#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cp -a $DIR/* /tmp

pushd /tmp
while IFS='' read -r dir ; do
  pushd "$dir"
  while IFS='' read -r notebook ; do
    pytest --nbval-lax "$notebook"
  done < <(ls *.ipynb)
  popd
done < <(ls -d */)
