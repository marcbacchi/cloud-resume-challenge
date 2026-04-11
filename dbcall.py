import json
import logging
import os
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    table_name = os.environ.get('DYNAMODB_TABLE_NAME', 'counter')
    table = boto3.resource('dynamodb').Table(table_name)

    try:
        response = table.update_item(
            Key={'id': 0},
            UpdateExpression='ADD visitcount :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues='ALL_NEW'
        )
        visit_count = int(response['Attributes']['visitcount'])
        logger.info(f"Visit count updated to: {visit_count}")
        return _response(200, {'count': visit_count})
    except ClientError as e:
        logger.error(f"DynamoDB error: {e}")
        return _response(500, {'error': 'Failed to update visitor count'})
    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
        return _response(500, {'error': 'Internal server error'})


def _response(status_code, body):
    return {
        'statusCode': status_code,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(body)
    }