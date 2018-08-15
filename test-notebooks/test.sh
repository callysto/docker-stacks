#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cp $DIR/*.ipynb /tmp

for i in /tmp/*.ipynb; do
  pytest --nbval-lax $i
done
