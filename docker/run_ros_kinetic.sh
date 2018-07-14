#!/bin/bash

CONTAINER=ros_kinetic
IMAGE_NAME=ros_kinetic
ADDITIONAL_DOCKER_ARGS=$1

SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REPO_DIR=`readlink -f ${SCRIPTS_DIR}/../`


DOCKER_MOUNT_ARGS="\
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v /dev:/dev \
    -v ${REPO_DIR}:/catkin_ws/"

xhost +
docker run --name ${IMAGE_NAME} --privileged --rm \
    ${DOCKER_MOUNT_ARGS} \
    -e DISPLAY=${DISPLAY} ${ADDITIONAL_DOCKER_ARGS} \
    --net=host \
    --device /dev/dri \
    --device /dev/ttyACM0 \
    -it ${CONTAINER}
xhost -
