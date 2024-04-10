import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient, PutCommandInput } from "@aws-sdk/lib-dynamodb";
import { v4 as uuidv4 } from 'uuid';

const dynamodb_table: string = process.env.DYNAMODB_TABLE;
const dynamodb_region: string = process.env.DYNAMODB_REGION;

if (!dynamodb_table) {
  throw new Error("DYNAMODB_TABLE is missing or empty.");
}

if (!dynamodb_region) {
  throw new Error("DYNAMODB_REGION is missing or empty.");
}

const client = new DynamoDBClient({
    region: dynamodb_region,
    endpoint: "http://localhost:8000" 
});
const docClient = DynamoDBDocumentClient.from(client);

export async function record(ip: string) {
  try {
    const newUuid = uuidv4();

    // Create the new item with the provided statistics
    const newItemParams: PutCommandInput = {
      TableName: dynamodb_table,
      Item: {
        id: newUuid,
        timestamp: new Date().toISOString(),
        ip: ip
      }
    };

    const putResponse = await docClient.send(new PutCommand(newItemParams));
    
    console.log("New item added:", newItemParams.Item);
    console.log("Response:", putResponse);
  } catch (error) {
    console.error("Error:", error);
    throw error;
  }
}