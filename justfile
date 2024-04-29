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
    npm i
    just clean
    docker-compose  -f docker-compose.dynamodb.yml -f docker-compose.static.yml build --no-cache
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.static.yml up --force-recreate --exit-code-from test app test


dev:
    #!/usr/bin/env bash
    npm i
    just clean
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.yml up app test


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
    terraform destroy -auto-approve \
        -var lambda_zip_path={{justfile_directory()}}/dist/api.zip \


# aws dynamodb scan --table-name stateful_aws_api_tasks --region local --endpoint-url http://localhost:8000


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
