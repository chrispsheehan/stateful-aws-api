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
    docker-compose down -v
    rm -f docker/dynamodb/shared-local-instance.db


start:
    #!/usr/bin/env bash
    npm i
    just clean
    docker-compose up app test
