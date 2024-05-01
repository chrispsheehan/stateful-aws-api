build:
    #!/usr/bin/env bash
    npm i --omit=dev
    npx tsc
    cp -r node_modules dist/node_modules
    cd dist
    rm -f api.zip
    zip -r api.zip *


clean:
    #!/usr/bin/env bash
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.static.yml  -f docker-compose.yml -v down --remove-orphans
    rm -f docker/dynamodb/shared-local-instance.db


test:
    #!/usr/bin/env bash
    just clean
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.static.yml build --no-cache
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.static.yml up --exit-code-from static-test dynamodb-check static-app static-test
    just clean


dev:
    #!/usr/bin/env bash
    npm i
    just clean
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.yml up dynamodb-check dev-app dev-test


tf-apply:
    #!/usr/bin/env bash
    cd tf
    terraform init
    terraform apply -auto-approve \
        -var lambda_zip_path={{justfile_directory()}}/dist/api.zip \


deploy:
  just build
  just tf-apply


destroy:
    #!/usr/bin/env bash
    cd tf
    terraform init
    touch {{justfile_directory()}}/empty.zip
    terraform destroy -auto-approve \
        -var lambda_zip_path={{justfile_directory()}}/empty.zip \


# docker run -p 9000:9000 --env-file=.env.local local:debug

# do the below in ci - probs due to env files

# aws dynamodb create-table --table-name stateful_aws_api_tasks --region local --endpoint-url http://localhost:8000 --billing-mode PAY_PER_REQUEST --key-schema AttributeName=id,KeyType=HASH --attribute-definitions AttributeName=id,AttributeType=S AttributeName=title,AttributeType=S --global-secondary-indexes "IndexName=IpIndex,KeySchema=[{AttributeName=title,KeyType=HASH}],Projection={ProjectionType=ALL}"
# aws dynamodb scan --table-name stateful_aws_api_tasks --region local --endpoint-url http://localhost:8000
# aws dynamodb describe-table --table-name stateful_aws_api_tasks --region local --endpoint-url http://localhost:8000

# aws dynamodb put-item \
#   --table-name stateful_aws_api_tasks \
#   --item '{
#     "id": {"S": "1"},
#     "title": {"S": "Example Title"},
#     "description": {"S": "Example Description"}
#   }' \
#   --endpoint-url http://localhost:8000 \
#   --region local


# curl -X PUT \
#   -H "Content-Type: application/json" \
#   -d '{"title": "Example Title", "description": "Example Description"}' \
#   http://localhost:9000/api/task
