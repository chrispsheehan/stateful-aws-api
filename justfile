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


# curl -X PUT \
#   -H "Content-Type: application/json" \
#   -d '{"title": "Example Title", "description": "Example Description"}' \
#   http://localhost:9000/api/task
