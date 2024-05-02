# stateful-aws-api

Test AWS lambda locally while developing!


## local dev

### `just start`: local development environment

- the below runs a [local instance of dynamodb](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html), the api and a test instance.
- the app and test instance will automatically (live load) run on changes to any `.ts` files.

```sh
app-dev   | LOCAL app listening on http://localhost:9000
test-dev  | PASS __tests__/hello.test.ts
test-dev  |   /hello
test-dev  |     ✓ is 200 (19 ms)
test-dev  | 
test-dev  | Test Suites: 1 passed, 1 total
test-dev  | Tests:       1 passed, 1 total
test-dev  | Snapshots:   0 total
test-dev  | Time:        2.248 s
test-dev  | Ran all test suites.
test-dev  | [nodemon] clean exit - waiting for changes before restart
test-dev  | [nodemon] restarting due to changes...
test-dev  | [nodemon] starting `npm test`
app-dev   | [nodemon] restarting due to changes...
app-dev   | [nodemon] starting `ts-node ./src/app.local.ts`
```

## ci

Test code completely ephemerally before environment deployment.

### ephemeral dynamodb in github action

```yaml
  test:
    runs-on: ubuntu-latest
    services:
      dynamodb-local:
        image: "amazon/dynamodb-local:latest"
        ports:
          - "8000:8000"
        options: --health-cmd="curl -s -o /dev/null -I -w "%{http_code}" http://localhost:8000 | grep -q 400 || exit 1" --health-interval=1s --health-timeout=2s --health-retries=10
```

### terraform

Deploy to AWS via terraform. Required access below (this repo uses [OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect))

```json
[
    "dynamodb:*", 
    "s3:*", 
    "lambda:*", 
    "apigateway:*", 
    "iam:*"
]
```