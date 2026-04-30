# Makefile for convenience, (doesn't look for command outputs)
.PHONY: all
all: vregeodes

# Setting environment variables from .env file
# "-" == "if exists" , do not forget to copy .env.template to .env
-include .env

.PHONY: vregeodes
vregeodes : conda-lock apt docker

conda-lock:
	cd vregeodes ; \
	conda-lock lock -f environment.yml -f ../.base_layer/base-notebook-environment.yml  -f ../.base_layer/pangeo-notebook-environment.yml  -p linux-64  --no-mamba; \
	conda-lock render -k explicit -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt

apt:
	cd vregeodes ; \
	../merge-apt.sh ../.base_layer/base-notebook-apt.txt apt.txt ../.base_layer/pangeo-notebook-apt.txt  apt.txt

docker:
	cd vregeodes ; \
	docker build -t cnes/vregeodes:master . --progress=plain --platform linux/amd64; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) cnes/vregeodes:master ./run_tests.sh vregeodes


update:
	python update_base_layer.py