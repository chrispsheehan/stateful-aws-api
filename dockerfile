# Fetching the minified node image on apline linux
FROM node:slim

# Setting up the work directory
WORKDIR /app

# Copying all the files in our project
COPY ./src /app/src
COPY ./package.json /app/package.json
COPY ./tsconfig.json /app/tsconfig.json

ENV NODE_ENV=production

# Installing dependencies
RUN npm install
RUN npm install ts-node

# Exposing server port
EXPOSE 9000

CMD ["npx", "ts-node", "src/app.local.ts"]