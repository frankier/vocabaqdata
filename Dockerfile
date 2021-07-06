FROM ubuntu:20.04

RUN apt-get update -qq -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    	build-essential \
        wget \
        python3-dev \
        python3-pip \
        git \
        rar \
        r-base \
        default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /vocabaqdata/

RUN python3 -m pip install --upgrade poetry==1.1.7

ADD pyproject.toml poetry.lock /vocabaqdata/

RUN poetry export \
      --without-hashes > requirements.txt && \
    python3 -m pip install -r requirements.txt && \
    rm requirements.txt && \
    rm -rf /root/.cache

RUN ln -sf /usr/bin/python3 /usr/bin/python

ADD . /vocabaqdata/
