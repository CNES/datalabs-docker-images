import os
import subprocess
import shutil


def print_limit(title):
    print()
    print()
    print(f"----------------- {title} -----------------")
    print()
    print()

    return


def update():
    print_limit("Base layers")
    result = subprocess.run(
        ["git", "clone", "https://github.com/CNES/datalabs-docker-images.git"],
        capture_output=True,
        text=True,
    )
    os.makedirs(".base_layer")

    shutil.copyfile(
        "datalabs-docker-images/base-notebook/environment.yml",
        ".base_layer/base-notebook-environment.yml",
    )
    shutil.copyfile(
        "datalabs-docker-images/base-notebook/apt.txt",
        ".base_layer/base-notebook-apt.txt",
    )
    if True:
        shutil.copyfile(
            "datalabs-docker-images/pangeo-notebook/environment.yml",
            ".base_layer/pangeo-notebook-environment.yml",
        )
        shutil.copyfile(
            "datalabs-docker-images/pangeo-notebook/apt.txt",
            ".base_layer/pangeo-notebook-apt.txt",
        )
    if False:
        shutil.copyfile(
            "datalabs-docker-images/pytorch-notebook/environment.yml",
            ".base_layer/pytorch-notebook-environment.yml",
        )
        shutil.copyfile(
            "datalabs-docker-images/pytorch-notebook/apt.txt",
            ".base_layer/pytorch-notebook-apt.txt",
        )

    result = subprocess.run(
        ["rm", "-rf", "datalabs-docker-images"], capture_output=True, text=True
    )


if __name__ == '__main__':
    update()

    