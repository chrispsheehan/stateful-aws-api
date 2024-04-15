import { PutCommand, PutCommandInput } from "@aws-sdk/lib-dynamodb";
import { DBBase } from "./db.base";

export class DBClient extends DBBase {
  constructor() {
    super();
  };

  public async put(item: Record<string, any>) {
    try {
      const params: PutCommandInput = {
          TableName: this.dbTable,
          Item: item
      };

      const putResponse = await this.docClient.send(new PutCommand(params))

      console.log("New item added:", params.Item);
      console.log("Response:", putResponse);

      return {
        statusCode: 200,
        body: item
      };
    }
    catch(error) {
      console.error("Error:", error);

      return {
        statusCode: 500,
        body: {
          msg: error
        }
      }
    }
  }
}