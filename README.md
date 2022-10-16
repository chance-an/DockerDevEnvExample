# Jiayuan Dental FlaskService (The backend)

## Run development environment

On Windows, login **Git Bash** (NOT PowerShell), then simply run
```shell
.dev.sh
```

It will automatically pull down the docker image from DockerHub then run it. From this point, you should have logged into a shell environment especially prepared for the development of this project which contains all the tools needed.

## Update the `devenv` (aka development environment) docker image

Make changes necessary to `Dockerfile`, then log into the devenv container (**make sure you can use the shell inside the container. This should not be run from Git Bash**), run 
```shell
make build_devenv
```
to update the local docker image. 

Run
```shell
make release_devenv
```
to push the image to the Docker hub. The credentials need to be set in `.dev.env` by setting the `JY_DEVENV_DOCKER_HUB_USERNAME` and `JY_DEVENV_DOCKER_HUB_PASSWORD` environment variables beforehand. Then the credentials will be used by the release(push) script automatically.

