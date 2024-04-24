build:
    #!/usr/bin/env bash
    npx tsc
    cp -r node_modules dist/node_modules
    cd dist
    rm -f api.zip
    zip -r api.zip *


run-local:
    #!/usr/bin/env bash
    source {{justfile_directory()}}/.env
    API_PORT=$API_PORT \
    DYNAMODB_REGION=$DYNAMODB_REGION \
    DYNAMODB_TABLE=$DYNAMODB_TABLE \
    DYNAMODB_ENDPOINT=$DYNAMODB_ENDPOINT \
    npx ts-node ./src/app.local.ts


start:
    #!/usr/bin/env bash
    just stop
    docker-compose up --force-recreate


stop:
    #!/usr/bin/env bash
    docker-compose down -v


clean:
    #!/usr/bin/env bash
    just stop
    rm -f docker/dynamodb/shared-local-instance.db


read:
    #!/usr/bin/env bash
    source {{justfile_directory()}}/.env.local
    aws dynamodb scan \
        --region $DYNAMODB_REGION \
        --table-name $DYNAMODB_TABLE \
        --endpoint-url $LOCAL_DYNAMODB_ENDPOINT


# curl -X PUT \
#   -H "Content-Type: application/json" \
#   -d '{"title": "Example Title", "description": "Example Description"}' \
#   http://localhost:9000/api/task
