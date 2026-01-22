"""Mock gempy_viewer module for testing."""

def __getattr__(_name):
    """Return a mock for any attribute access."""
    from unittest.mock import MagicMock
    return MagicMock()
