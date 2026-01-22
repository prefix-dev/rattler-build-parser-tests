"""Mock matplotlib module for testing."""

def __register_mock_module(name, mock):
    import sys
    sys.modules['matplotlib.pyplot'] = mock

def __make_mock():
    from unittest.mock import MagicMock
    return MagicMock()

def __getattr__(_name):
    """Return a mock for any attribute access."""
    return __make_mock()


pyplot = __make_mock()
__register_mock_module('matplotlib.pyplot', pyplot)

__all__ = ['pyplot']
