import boto3
from boto3.dynamodb.conditions import Key
import os

def lambda_handler(event, context):
    
    TABLE_NAME = "counter"
    # create the db client variable
    db_client = boto3.client('dynamodb')
    
    #create table resources
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(TABLE_NAME)
    
    #add 1 to the value
    response = db_client.update_item(
        TableName=TABLE_NAME,
        Key={"id": {"N": "0"}},
        UpdateExpression="ADD visitcount :inc",
        ExpressionAttributeValues={":inc": {"N": "1"}}
    )

    items = table.get_item(Key={"id": 0})

    return items

