build:
    #!/usr/bin/env bash
    npx tsc
    cp -r node_modules dist/node_modules
    cd dist
    rm -f api.zip
    zip -r api.zip *


run:
    #!/usr/bin/env bash
    source {{justfile_directory()}}/.env
    npx tsc
    DYNAMODB_REGION=$DYNAMODB_REGION \
    DYNAMODB_TABLE=$DYNAMODB_TABLE \
    PORT=$API_PORT \
    node dist/app.local.js