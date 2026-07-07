#!/bin/bash

# Usage: docker run -w /srv/test -v $PWD:/srv/test pangeodev/base-notebook:latest ./run_tests.sh base-notebook
echo "Testing docker image {$1}..."

# Install pytest on top of existing environment
/srv/pixi/pixi add --pypi pytest --manifest-path /srv/pixi/notebook --feature `cat /home/jovyan/vre_name`

/srv/pixi/pixi run --manifest-path /srv/pixi/notebook --environment `cat /home/jovyan/vre_name` pytest -v tests/test_all.py tests/test_$1.py

#EOF
