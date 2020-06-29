FROM node:alpine
WORKDIR /usr

RUN npm install -g vue-cli

RUN vue init webpack app

WORKDIR /usr/app
RUN npm install
COPY app_project .
