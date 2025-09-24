from flask import Flask
import boto3

app = Flask(__name__)


@app.route("/")
def hello_world():
    # Fetch value from SSM Parameter Store (optional, mock if not available)
    try:
        ssm = boto3.client("ssm", region_name="us-east-1")
        parameter = ssm.get_parameter(Name="hello-message", WithDecryption=True)
        message = parameter["Parameter"]["Value"]
    except Exception:
        message = "Hello, World! (default)"

    return {"message": message}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
