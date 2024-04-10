import { DynamoDBClient, GetItemCommand, ScanCommand } from "@aws-sdk/client-dynamodb";
import { Request, Response } from 'express';
import { GitStats } from './types/github.stats';

const dynamodb_table: string = process.env.DYNAMODB_TABLE;
const dynamodb_region: string = process.env.DYNAMODB_REGION;

if (!dynamodb_table) {
  throw new Error("DYNAMODB_TABLE is missing or empty.");
}

if (!dynamodb_region) {
  throw new Error("DYNAMODB_REGION is missing or empty.");
}

const client = new DynamoDBClient({ region: dynamodb_region });

async function getGitStats(req: Request, res: Response): Promise<Response> {

  let stats: GitStats = {
    totalStars: 0,
    totalForks: 0,
    totalClones: 0,
    mostStarred: null,
    mostForked: null,
    mostCloned: null
  };

  try {
    const params = {
      TableName: dynamodb_table,
      ProjectionExpression: "#id, #timestamp",
      ExpressionAttributeNames: {
        "#id": "id",
        "#timestamp": "timestamp"
      },
      Limit: 1, // Limit to retrieve only one item
      ScanIndexForward: false // Scan in descending order
    };

    // Create a QueryCommand
    const command = new ScanCommand(params);

    // Send the command to DynamoDB
    const data = await client.send(command);

    if (data.Items.length !== 1) {
      throw new Error("Expected exactly one item, but found " + data.Items.length);
    }

    console.log("Success:", data.Items[0]);

    const latestId = data.Items[0]?.id.S;
    const latestTimestamp = data.Items[0]?.timestamp.S;

    const getItemParams = {
      TableName: dynamodb_table,
      Key: {
        "id": { S: latestId },
        "timestamp": { S: latestTimestamp }
      }
    };

    // Create a GetItemCommand to retrieve the entire data row
    const getItemCommand = new GetItemCommand(getItemParams);

    const itemData = await client.send(getItemCommand);
    console.log(itemData.Item);
    
    stats.mostForked = itemData.Item?.most_forked.S;
    stats.mostStarred = itemData.Item?.most_starred.S;
    stats.mostCloned = itemData.Item?.most_cloned.S;
    stats.totalForks = Number.parseInt(itemData.Item?.total_forks.N);
    stats.totalStars = Number.parseInt(itemData.Item?.total_stars.N);
    stats.totalClones = Number.parseInt(itemData.Item?.total_clones.N);

    return res.status(200).json(stats);

  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
}

export default {
  getGitStats
};