FROM python:3.9-slim
ENV TINI_VERSION v0.19.0
COPY . /
RUN echo "**** install system packages ****" \
 && apt-get update \
 && apt-get upgrade -y --no-install-recommends \
 && apt-get install -y tzdata --no-install-recommends \
 && apt-get install -y gcc g++ libxml2-dev libxslt-dev libz-dev wget \
 && wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-"$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget https://raw.githubusercontent.com/blacktwin/JBOPS/master/utility/plex_api_share.py
 && chmod +x /tini \
 && pip3 install --no-cache-dir --upgrade --requirement /requirements.txt \
 && apt-get --purge autoremove wget gcc g++ libxml2-dev libxslt-dev libz-dev -y \
 && apt-get clean \
 && apt-get update \
 && apt-get check \
 && apt-get -f install \
 && apt-get autoclean \
 && rm -rf /requirements.txt /tmp/* /var/tmp/* /var/lib/apt/lists/*
VOLUME /config
ENTRYPOINT ["/tini", "-s", "python3", "pum.sh", "--"]
