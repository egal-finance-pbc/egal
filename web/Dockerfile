FROM ubuntu:focal

LABEL maintainer="omarkhd.mx@gmail.com"

RUN apt-get update && apt-get install -y python3.8 python3.8-dev python3-pip
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt

WORKDIR /opt/conellas/web
CMD gunicorn --workers=1 --bind=0.0.0.0:8000 conellas.wsgi
