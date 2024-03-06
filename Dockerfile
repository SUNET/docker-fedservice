FROM python:3.12-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-dev \
    build-essential \
    python3-pip \
    libffi-dev \
    libssl-dev \
    xmlsec1 \
    libyaml-dev
RUN pip3 install --upgrade pip setuptools
COPY requirements.txt requirements.txt
COPY start.sh /
RUN pip3 install -r requirements.txt
RUN cp /src/fedservice/setup_federation/entity.py /
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
CMD ["/start.sh"] 
EXPOSE 7003
