import werkzeug

# Patch missing __version__ for Flask test client compatibility
if not hasattr(werkzeug, "__version__"):
    werkzeug.__version__ = "3.0.0"
