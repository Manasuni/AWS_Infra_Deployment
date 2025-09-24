# tests/test_main.py

import pytest
import sys
import os

# Add project root to sys.path so we can import main.py
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))  # noqa: E402

from main import app  # noqa: E402


@pytest.fixture
def client():
    with app.test_client() as client:
        yield client


def test_root(client):
    """Test the '/' endpoint returns status code 200"""
    response = client.get("/")
    assert response.status_code == 200
