# stateful-aws-api

Test AWS lambda locally while developing!


## local dev

### `just start`: local development environment

- the below runs a [local instance of dynamodb](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html), the api and a test instance.
- the app and test instance will automatically (live load) run on changes to any `.ts` files.

```sh
app   | [nodemon] 3.1.0
app   | [nodemon] to restart at any time, enter `rs`
app   | [nodemon] watching path(s): *.*
app   | [nodemon] watching extensions: ts,json
app   | [nodemon] starting `ts-node ./src/app.local.ts`
app   | LOCAL app listening on http://localhost:9000
test  | [nodemon] 3.1.0
test  | [nodemon] to restart at any time, enter `rs`
test  | [nodemon] watching path(s): *.*
test  | [nodemon] watching extensions: ts
test  | [nodemon] starting `npm test`
test  | 
test  | > test
test  | > jest --runInBand
test  | 
app   | New item added: {
app   |   id: 'f32c0860-c806-4b5b-a9bd-54f23750e47a',
app   |   title: 'testtxtx',
app   |   description: 'Example Description',
app   |   completed: false
app   | }
test  | PASS __tests__/putTasks.test.ts
test  | PASS __tests__/hello.test.ts
test  | PASS __tests__/getTasks.test.ts
test  | 
test  | Test Suites: 3 passed, 3 total
test  | Tests:       4 passed, 4 total
test  | Snapshots:   0 total
test  | Time:        2.665 s
test  | Ran all test suites.
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