import pytest
import os
import sys

def test_default_pixi_environment():
    assert sys.prefix == '/srv/pixi/notebook/.pixi/envs/base-notebook'
    
def test_start():
    print(os.environ)
    if os.environ.get('PANGEO_ENV') is not None:
        assert os.environ['PANGEO_ENV'] == 'base-notebook'
