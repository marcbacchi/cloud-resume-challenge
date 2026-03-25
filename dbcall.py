import json
import logging
import os
import boto3
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Visitor counter Lambda function with improved error handling, logging, and response consistency.
    
    Returns a properly formatted Lambda proxy integration response with status code, headers, and JSON body.
    """
    try:
        # Get table name from environment variable with fallback
        table_name = os.environ.get('DYNAMODB_TABLE_NAME', 'counter')
        logger.info(f"Using DynamoDB table: {table_name}")
        
        # Initialize DynamoDB resource (use high-level API only)
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(table_name)
        
        # Update the visit counter
        try:
            logger.info("Attempting to increment visit counter")
            update_response = table.update_item(
                Key={'id': 0},
                UpdateExpression='ADD visitcount :inc',
                ExpressionAttributeValues={':inc': 1},
                ReturnValues='ALL_NEW'
            )
            logger.info(f"Successfully updated visit counter: {update_response}")
        except ClientError as e:
            logger.error(f"DynamoDB update_item failed: {e}")
            return format_error_response(500, "Failed to update visitor count")
        
        # Get the current visit count
        try:
            logger.info("Fetching current visit count")
            response = table.get_item(Key={'id': 0})
            
            if 'Item' not in response:
                logger.error("Item not found in DynamoDB table")
                return format_error_response(500, "Visitor count item not found")
            
            visit_count = response['Item'].get('visitcount')
            
            if visit_count is None:
                logger.error("visitcount attribute missing from DynamoDB item")
                return format_error_response(500, "Visit count attribute missing")
            
            logger.info(f"Current visit count: {visit_count}")
            
        except ClientError as e:
            logger.error(f"DynamoDB get_item failed: {e}")
            return format_error_response(500, "Failed to retrieve visitor count")
        
        # Return successful response in Lambda proxy integration format
        return format_success_response(visit_count)
        
    except Exception as e:
        logger.error(f"Unexpected error in lambda_handler: {str(e)}", exc_info=True)
        return format_error_response(500, "Internal server error")


def format_success_response(count):
    """Format a successful response in Lambda proxy integration format."""
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'count': count
        })
    }


def format_error_response(status_code, message):
    """Format an error response in Lambda proxy integration format."""
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'error': message
        })
    }
