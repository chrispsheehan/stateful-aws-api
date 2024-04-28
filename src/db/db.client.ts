import { PutCommand, PutCommandInput } from "@aws-sdk/lib-dynamodb";
import { DBBase } from "./db.base";
import { APIResponse } from "../types/api.response";
import { ScanCommand, ScanCommandInput } from "@aws-sdk/client-dynamodb";

export class DBClient extends DBBase {
  constructor() {
    super();
    this.open();
  };

  public async get(item: Record<string, any>): Promise<APIResponse> {
    try {
      const params: ScanCommandInput = {
          TableName: this.dbTable
      };

      const data = await this.docClient.send(new ScanCommand(params))

      const resp = {
        code: 200,
        body: data.Items ? data.Items : []
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

  public async put(item: Record<string, any>): Promise<APIResponse> {
    try {
      const params: PutCommandInput = {
          TableName: this.dbTable,
          Item: item
      };

      await this.docClient.send(new PutCommand(params))

      console.log("New item added:", params.Item);

      const resp = {
        code: 204,
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