#!/bin/bash

# Usage: docker run -w /srv/test -v $PWD:/srv/test pangeodev/base-notebook:latest ./run_tests.sh base-notebook
echo "Testing docker image {$1}..."

# Install pytest on top of existing environment
/srv/pixi/pixi add --pypi pytest --manifest-path /srv/pixi/notebook --environement /home/jovyian/vre_name
/srv/pixi/pixi shell --manifest-path /srv/pixi/notebook --environement /home/jovyian/vre_name
#python -m pip install pytest

pytest -v tests/test_all.py tests/test_$1.py

#EOF
