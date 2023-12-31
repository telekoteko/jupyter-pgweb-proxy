FROM jupyter/minimal-notebook:latest

USER root
RUN apt-get update \
 && apt-get install -y \
    curl \
    unzip \
    wget

# install pgweb
ENV PGWEB_VERSION=0.14.0
RUN wget -q "https://github.com/sosedoff/pgweb/releases/download/v${PGWEB_VERSION}/pgweb_linux_amd64.zip" \
 && unzip pgweb_linux_amd64.zip -d /usr/bin \
 && mv /usr/bin/pgweb_linux_amd64 /usr/bin/pgweb

# setup package, enable classic extension, build lab extension
USER "${NB_USER}"
WORKDIR "${HOME}"
RUN python3 -m pip install --no-cache-dir https://github.com/telekoteko/jupyter-pgweb-proxy/releases/download/1.0.0/jupyter-pgweb-proxy-1.0.0.tar.gz
RUN jupyter serverextension enable --sys-prefix jupyter_server_proxy

# copy configs, update permissions as root
USER root
RUN cp /etc/jupyter/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config_base.py
COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
RUN fix-permissions /etc/jupyter

USER "${NB_USER}"
