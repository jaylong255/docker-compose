FROM ubuntu:latest AS worker

RUN apt-get update && apt-get install -y \
    sudo \
    libicu-dev \
    libbz2-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++\
    nodejs\
    npm

    