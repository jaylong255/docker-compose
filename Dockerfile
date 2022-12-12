# Set host user and group id for all stages
ARG HOST_USER_UID=1001
ARG HOST_USER_GID=1001

# Add a target for php cli to use as a worker
FROM php:8.0.2-cli AS php

ARG HOST_USER_UID
ARG HOST_USER_GID

RUN apt-get update

RUN apt-get update && apt-get install -y \
    build-essential \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev \
    libfreetype6 \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    # mysql \
    libxml2-dev 

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add the user that will be expected
RUN addgroup --gid ${HOST_USER_GID} nginx
RUN adduser --system --no-create-home --uid $HOST_USER_UID --ingroup nginx webuser

WORKDIR /app

COPY ./laravel /app

FROM nginx:alpine as web

ARG HOST_USER_UID
ARG HOST_USER_GID
ARG UPSTREAM

RUN apk add --upgrade brotli-libs

# Copy nginx config from files we packaged in
COPY ./nginx/nginx.conf /etc/nginx/

# Add the user that php expects to the nginx group
RUN adduser --system --no-create-home -D --uid $HOST_USER_UID --ingroup nginx webuser
