# How to create a new VRE Project from `datalabs-pangeo-images`

You have two options for creating a new VRE project based on `datalabs-pangeo-images`: you can either fork this project or use a **FROM** instruction in your `Dockerfile`

## Option 1 : Fork the VRE

### Benefits of Forking

Forking allows you to take full advantage of the `ONBUILD` instructions defined in the `base-image`, enabling seamless customization.

### Steps to Fork the Project

 1. **Fork the Project** 
Click on the "Fork" button on GitHub and follow the prompts to create your forked project.

 2. **Make Specific Modifications**
Depending on your needs, you can modify several components:
    * **To add Python packages**: Update the `environment.yml` file.
    * **To add apt packages**: Edit the `apt.txt` file.
    * **To install additional applications**: Create an `install.sh` script and place it under `resources/<application-name>/`.
    * **To add startup scripts for the VRE**: Create a shell script named `start-notebook-<name>.sh`, and move it to `/usr/local/bin/` within your `install.sh` script:
```bash
#Example
cp resources/folder/start-notebook-example.sh /usr/local/bin/
chmod +x /usr/local/bin/start-notebook-example.sh
```

 3. **Build the Project** Use the `make` command to build the image

```bash
#Example with base-notebook
make base-notebook
```

### Syncing Your Fork with Upstream
To keep your fork updated with the original project:
 1. Add the upstream remote: 
```bash
git remote add upstream git@github.com:CNES/datalabs-docker-images.git
```
 2. Fetch the latest branches from the upstream repository:
```bash
git fetch upstream
```
 3. Switch to your main branch:
```bash
git checkout master
```
 4. Merge changes from upstream into your main branch:
```bash
git merge upstream/master
```
 5. Resolve any conflicts (if necessary), then complete the merge:
```bash
git merge --continue
```

## Option 2: Create a Dockerfile with `FROM`

If you prefer not to fork, you can create a custom Dockerfile by extending an existing image using the `FROM` instruction.
#### Example Dockerfile
```docker
FROM datalabs/base-notebook:<image-tag>
```

You can then add any specific packages, configurations, or scripts by modifying the Dockerfile as needed.
#### Build

Build your Dockerfile with the following command:

```bash
docker build -t <name-of-the-image>:<tag> .
```