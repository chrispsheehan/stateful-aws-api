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
    API_PORT=$API_PORT \
    DYNAMODB_REGION=$DYNAMODB_REGION \
    DYNAMODB_TABLE=$DYNAMODB_TABLE \
    DYNAMODB_ENDPOINT=$DYNAMODB_ENDPOINT \
    node dist/app.local.js


start:
    #!/usr/bin/env bash
    just stop
    docker-compose up -d


stop:
    #!/usr/bin/env bash
    docker-compose down -v
    rm -f docker/dynamodb/shared-local-instance.db


create:
    #!/usr/bin/env bash
    source {{justfile_directory()}}/.env.local
    aws dynamodb create-table \
        --endpoint-url $LOCAL_DYNAMODB_ENDPOINT \
        --region $DYNAMODB_REGION \
        --table-name $DYNAMODB_TABLE \
        --billing-mode PAY_PER_REQUEST \
        --key-schema AttributeName=id,KeyType=HASH \
        --attribute-definitions \
            AttributeName=id,AttributeType=S \
            AttributeName=title,AttributeType=S \
        --global-secondary-indexes \
            "IndexName=IpIndex,KeySchema=[{AttributeName=title,KeyType=HASH}],Projection={ProjectionType=ALL}"


read:
    #!/usr/bin/env bash
    source {{justfile_directory()}}/.env.local
    aws dynamodb scan \
        --region $DYNAMODB_REGION \
        --table-name $DYNAMODB_TABLE \
        --endpoint-url $LOCAL_DYNAMODB_ENDPOINT



# aws dynamodb put-item \
#     --endpoint-url http://localhost:8000 \
#     --region local \
#     --table-name stateful_aws_api_tasks \
#     --item '{
#         "id": {"S": "1"},
#         "title": {"S": "Example Task"},
#         "description": {"S": "This is an example task description."},
#         "completed": {"BOOL": false}
#     }'