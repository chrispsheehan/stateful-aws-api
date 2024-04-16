import { PutCommand, PutCommandInput } from "@aws-sdk/lib-dynamodb";
import { DBBase } from "./db.base";
import { APIResponse } from "../types/api.response";

export class DBClient extends DBBase {
  constructor() {
    super();
    this.open();
  };

  public async put(item: Record<string, any>): Promise<APIResponse> {
    try {
      console.log('putting...' + this.dbTable + JSON.stringify(item));

      const params: PutCommandInput = {
          TableName: this.dbTable,
          Item: item
      };

      console.log('HERE' + JSON.stringify(params))

      const putResponse = await this.docClient.send(new PutCommand(params))

      console.log("New item added:", params.Item);
      console.log("Response:", putResponse);

      const resp = {
        code: 200,
        body: item
      }

      return resp
    }
    catch(error) {
      console.error("Error:", error);

      return {
        code: 500,
        body: {
          msg: error
        }
      }
    }
  }
}