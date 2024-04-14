# Fetching the minified node image on apline linux
FROM node:slim

# Setting up the work directory
WORKDIR /app

# Copying all the files in our project
COPY ./src /app
COPY ./package.json /app/package.json
COPY ./tsconfig.json /app/tsconfig.json

# Installing dependencies
RUN npm install
RUN npx tsc

# Exposing server port
EXPOSE 9000