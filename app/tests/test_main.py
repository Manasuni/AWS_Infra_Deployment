import os
import pytest
from main import app


@pytest.fixture
def client():
    return app.test_client()


def test_hello_route_with_mock(monkeypatch):
    # Mock boto3 client
    class DummySSMClient:
        def get_parameter(self, Name, WithDecryption):
            return {"Parameter": {"Value": "Test from SSM"}}

    import boto3
    monkeypatch.setattr(boto3, "client", lambda *args, **kwargs: DummySSMClient())

    monkeypatch.setenv("SSM_PARAM_NAME", "/myapp/hello_msg")
    monkeypatch.setenv("AWS_REGION", "ap-south-1")

    client = app.test_client()
    resp = client.get("/")
    assert resp.status_code == 200
    assert resp.json["message"] == \
       "Test from SSM"
