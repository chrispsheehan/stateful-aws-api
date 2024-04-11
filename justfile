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


create-table:
    #!/usr/bin/env bash
    docker-compose down -v
    docker-compose up
    source {{justfile_directory()}}/.env.local
    aws dynamodb create-table \
        --endpoint-url http://localhost:8000 \
        --region $DYNAMODB_REGION \
        --table-name $DYNAMODB_TABLE \
        --billing-mode PAY_PER_REQUEST \
        --key-schema AttributeName=id,KeyType=HASH AttributeName=timestamp,KeyType=RANGE \
        --attribute-definitions \
            AttributeName=id,AttributeType=S \
            AttributeName=timestamp,AttributeType=S \
            AttributeName=ip,AttributeType=S \
        --global-secondary-indexes \
            "IndexName=IpIndex,KeySchema=[{AttributeName=ip,KeyType=HASH}],Projection={ProjectionType=ALL}"

read-table:
    #!/usr/bin/env bash
    source {{justfile_directory()}}/.env.local
    aws dynamodb scan \
        --region $DYNAMODB_REGION \
        --table-name $DYNAMODB_TABLE \
        --endpoint-url http://localhost:8000

