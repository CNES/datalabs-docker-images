# Makefile for convenience, (doesn't look for command outputs)
.PHONY: all
all: base-image base-notebook pangeo-notebook pytorch-notebook
TESTDIR=/srv/test


pixi:
	rm -rf notebook ; \
	pixi init notebook ; \
	cd notebook ; \
	pixi import ../base-notebook/environment.yml --format conda-env; \
	pixi import ../pangeo-notebook/environment.yml --format conda-env; \
	pixi import ../pytorch-notebook/environment.yml --format conda-env; \
	pixi workspace environment add base-notebook --feature base-notebook --force; \
	pixi workspace environment add pangeo-notebook --feature base-notebook --feature pangeo-notebook --force; \
	pixi workspace environment add pytorch-notebook --feature base-notebook --feature pangeo-notebook --feature pytorch-notebook --force; \
	pixi lock


.PHONY: base-image
base-image :
	cd base-image ; \
	docker build -t cnes/base-image:master --progress=plain --platform linux/amd64 .

.PHONY: base-notebook
base-notebook : base-image
	cd base-notebook ; \
	../generate-packages-list.py ../notebook/pixi.lock --environment='base-notebook' > packages.txt; \
	docker build -t cnes/base-notebook:master . --no-cache --progress=plain --platform linux/amd64; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) cnes/base-notebook:master ./run_tests.sh base-notebook

.PHONY: pangeo-notebook
pangeo-notebook : base-image
	cd pangeo-notebook ; \
	cp -r ../base-notebook/resources . ; \
	../generate-packages-list.py ../notebook/pixi.lock --environment='pangeo-notebook' > packages.txt; \
	../merge-apt.sh ../base-notebook/apt.txt apt.txt; \
	docker build -t cnes/pangeo-notebook:master . --progress=plain --platform linux/amd64; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) cnes/pangeo-notebook:master ./run_tests.sh pangeo-notebook


.PHONY: pytorch-notebook
pytorch-notebook : base-image
	cd pytorch-notebook ; \
	cp -r ../pangeo-notebook/resources ../base-notebook/resources . ; \
	../generate-packages-list.py ../notebook/pixi.lock --environment='pytorch-notebook' > packages.txt; \
	../merge-apt.sh ../pangeo-notebook/apt.txt ../base-notebook/apt.txt apt.txt; \
	docker build -t cnes/pytorch-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) cnes/pytorch-notebook:master ./run_tests.sh pytorch-notebook
