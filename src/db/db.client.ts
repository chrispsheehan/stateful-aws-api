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
      const params: PutCommandInput = {
          TableName: this.dbTable,
          Item: item
      };

      await this.docClient.send(new PutCommand(params))

      console.log("New item added:", params.Item);

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