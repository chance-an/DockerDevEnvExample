container_name=jiayuan_devenv
source_path=/source/jiayuan_dental

export MSYS_NO_PATHCONV=1

echo_and_run() { echo "\$ $*" ; "$@" ; }

if ! [ -f ".dev.env" ]; then
  echo "\".dev.env\" is not found. Please copy \".template.env\" as \".dev.env\"."
  exit 1
fi

source .dev.env

if ! docker info > /dev/null 2>&1; then
  echo "This script uses docker, and it isn't running - please start docker and try again!"
  exit 1
fi

if ! [ "$( docker container inspect -f '{{.State.Status}}' $container_name )" == "running" ]; then
  echo_and_run docker run \
   -it --privileged --name $container_name -d \
   --volume=$(pwd):$source_path \
   -v /var/run/docker.sock:/var/run/docker.sock \
   -p 3306:3306 \
   # The MYSQL_* environment variable only work the first time a container is started.
   # If a volume was pre-mounted, the data will stay untouched. If
   # you want to have the following MYSQL_* env vars take effect, delete the container
   # then start a new one.
   --env MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
   --env MYSQL_DATABASE=$MYSQL_DATABASE \
   $JY_DEVENV_DOCKER_HUB_REPO:latest
fi

if [ -z "$MSYSTEM_CARCH" ]; then
  winpty_prefix=""
else
  winpty_prefix="winpty "
fi

# launch devenv in a new shell
echo_and_run ${winpty_prefix}docker exec -it -w /${source_path} $container_name //usr/bin/zsh
