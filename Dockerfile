# Set host user and group id for all stages
ARG HOST_USER_UID=1001
ARG HOST_USER_GID=1001

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

FROM nginx:alpine as web

ARG HOST_USER_UID
ARG HOST_USER_GID
ARG UPSTREAM

RUN apk add --upgrade brotli-libs

# Copy nginx config from files we packaged in
COPY ./nginx/nginx.conf /etc/nginx/

# Add the user that php expects to the nginx group
RUN adduser --system --no-create-home -D --uid $HOST_USER_UID --ingroup nginx webuser
