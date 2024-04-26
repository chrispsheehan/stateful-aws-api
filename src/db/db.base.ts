import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const dynamodb_table: string = process.env.DYNAMODB_TABLE;
const dynamodb_region: string = process.env.DYNAMODB_AWS_REGION;
const dynamodb_endpoint: string = process.env.DYNAMODB_ENDPOINT;

if (!dynamodb_table) {
  throw new Error("DYNAMODB_TABLE is missing or empty.");
}

if (!dynamodb_region) {
  throw new Error("DYNAMODB_AWS_REGION is missing or empty.");
}

if (!dynamodb_endpoint) {
  throw new Error("DYNAMODB_ENDPOINT is missing or empty.");
}

export class DBBase {
    public dbClient: DynamoDBClient;
    public docClient: DynamoDBDocumentClient;
    public dbTable: string;

    constructor() {
        this.dbTable = dynamodb_table;
    }

    public open() {
        this.dbClient = new DynamoDBClient({
            region: dynamodb_region,
            endpoint: dynamodb_endpoint 
        });

        this.docClient = DynamoDBDocumentClient.from(this.dbClient);
    }

    public close() {
        this.docClient.destroy();
        this.dbClient.destroy();
    }
}
