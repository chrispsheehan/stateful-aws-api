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
    rm -f docker/dynamodb/shared-local-instance.db


start:
    #!/usr/bin/env bash
    just clean
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.static.yml up --force-recreate app


test:
    #!/usr/bin/env bash
    just clean
    docker-compose build
    docker-compose -f docker-compose.dynamodb.yml -f docker-compose.static.yml run test


dev:
    #!/usr/bin/env bash
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


# curl -X PUT \
#   -H "Content-Type: application/json" \
#   -d '{"title": "Example Title", "description": "Example Description"}' \
#   https://pjkg1tdm9c.execute-api.eu-west-2.amazonaws.com/lambda/api/task

