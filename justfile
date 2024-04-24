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


read:
    #!/usr/bin/env bash
    source {{justfile_directory()}}/.env.local
    aws dynamodb scan \
        --region $DYNAMODB_REGION \
        --table-name $DYNAMODB_TABLE \
        --endpoint-url $LOCAL_DYNAMODB_ENDPOINT


start-static:
    #!/usr/bin/env bash
    just stop
    docker-compose up --force-recreate app


start:
    #!/usr/bin/env bash
    just stop
    docker-compose up app-dev


dev:
    #!/usr/bin/env bash
    just stop
    docker-compose up app-dev test-dev


# curl -X PUT \
#   -H "Content-Type: application/json" \
#   -d '{"title": "Example Title", "description": "Example Description"}' \
#   http://localhost:9000/api/task
