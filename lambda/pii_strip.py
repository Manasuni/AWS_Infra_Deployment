import json
import re

def lambda_handler(event, context):
    """
    Example Lambda to strip PII (emails, phone numbers) from CloudWatch logs
    """

    # Logs come in as event, here we just simulate processing
    # Convert event to JSON string
    log_str = json.dumps(event)

    # Simple regex patterns for PII
    email_pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
    phone_pattern = r'\b\d{10}\b'

    # Remove PII
    log_str = re.sub(email_pattern, "[REDACTED_EMAIL]", log_str)
    log_str = re.sub(phone_pattern, "[REDACTED_PHONE]", log_str)

    # Print or store cleaned log
    print("Cleaned log:", log_str)

    return {
        "statusCode": 200,
        "body": json.dumps("PII stripped successfully")
    }
