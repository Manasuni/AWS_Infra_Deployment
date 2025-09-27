import logging
import os

from flask import Flask, jsonify
import boto3
import watchtower

app = Flask(__name__)

# Configure logging to CloudWatch
logger = logging.getLogger("myapp")
logger.setLevel(logging.INFO)

region = os.getenv("AWS_REGION", "ap-south-1")

# Stream logs to CloudWatch (requires IAM permissions)
cw_handler = watchtower.CloudWatchLogHandler(
    boto3_client=boto3.client("logs", region_name=region),
    log_group="myapp-logs",  # Terraform/Helm should ensure this log group exists
    stream_name="app-stream"
)
logger.addHandler(cw_handler)


def get_parameter(name, with_decryption=False):
    """Fetch parameter from SSM Parameter Store."""
    ssm = boto3.client("ssm", region_name=region)
    response = ssm.get_parameter(Name=name, WithDecryption=with_decryption)
    return response["Parameter"]["Value"]


@app.route("/")
def hello():
    param_name = os.getenv("SSM_PARAM_NAME", "/myapp/hello_msg")
    default_msg = "Hello, World!"

    try:
        message = get_parameter(param_name)
        logger.info(
            f"Fetched SSM param {param_name} = {message}"
        )
    except Exception as e:
        logger.error(
            f"Failed to fetch parameter {param_name}: {e}"
        )
        message = default_msg

    return jsonify({"message": message})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
