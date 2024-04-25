build:
    #!/usr/bin/env bash
    npx tsc
    cp -r node_modules dist/node_modules
    cd dist
    rm -f api.zip
    zip -r api.zip *


stop:
    #!/usr/bin/env bash
    docker-compose down -v


clean:
    #!/usr/bin/env bash
    just stop
    rm -f docker/dynamodb/shared-local-instance.db


start:
    #!/usr/bin/env bash
    just stop
    just clean
    docker-compose up --force-recreate app


dev:
    #!/usr/bin/env bash
    just stop
    docker-compose up app-dev test-dev


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
    terraform destroy \
        -var lambda_zip_path={{justfile_directory()}}/dist/api.zip \


# curl -X PUT \
#   -H "Content-Type: application/json" \
#   -d '{"title": "Example Title", "description": "Example Description"}' \
#   https://pjkg1tdm9c.execute-api.eu-west-2.amazonaws.com/lambda/api/task

