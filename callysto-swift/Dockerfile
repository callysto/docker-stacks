FROM callysto/pims-r
MAINTAINER Callysto <sysadmin@callysto.ca>
USER $NB_USER

RUN pip install python-keystoneclient
RUN pip install git+https://github.com/callysto/s3contents@swiftfs

COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

USER root
