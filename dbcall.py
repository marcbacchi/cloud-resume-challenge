import boto3
# from boto3.dynamodb.conditions import Key
import os

# def lambda_handler(event, context):
    
#     TABLE_NAME = "counter"
#     db_client = boto3.client('dynamodb')
#     dynamodb = boto3.resource('dynamodb')
#     table = dynamodb.Table(TABLE_NAME)

#     update = db_client.update_item(
#         TableName=TABLE_NAME,
#         Key={"id": {"N": "0"}},
#         UpdateExpression="ADD visitcount :inc",
#         ExpressionAttributeValues={":inc": {"N": "1"}}
#     )

#     getItems = table.get_item(Key={"id": 0})
#     itemsObjectOnly = getItems["Item"]
#     visitcount = itemsObjectOnly["visitcount"]

#     response = {
#         "headers": {
#             "content-type" : "application/json"
#         },
#         "status_code": 200,
#         "body" : {
#             "count": visitcount
#         }
#     }

#     return response


    # Suggestions to improve performance and decrease complexity:
    # 1. Use only boto3.resource or boto3.client, not both, for consistency and simplicity.
    # 2. Use table.update_item instead of db_client.update_item to avoid mixing resource and client.
    # 3. Use ReturnValues="UPDATED_NEW" in update_item to get the updated count directly, removing the need for a second get_item call.
    # 4. Remove unused imports and variables.

    # Refactored code:
    def lambda_handler(event, context):
        TABLE_NAME = "counter"
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(TABLE_NAME)

        update = table.update_item(
            Key={"id": 0},
            UpdateExpression="ADD visitcount :inc",
            ExpressionAttributeValues={":inc": 1},
            ReturnValues="UPDATED_NEW"
        )

        visitcount = update["Attributes"]["visitcount"]

        response = {
            "headers": {
                "content-type": "application/json"
            },
            "status_code": 200,
            "body": {
                "count": visitcount
            }
        }

        return response