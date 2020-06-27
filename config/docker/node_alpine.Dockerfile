FROM node:alpine
WORKDIR /usr/app
COPY app_project/package.json .
RUN npm install
COPY app_project .
