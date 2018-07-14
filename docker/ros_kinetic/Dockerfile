FROM osrf/ros:kinetic-desktop-full-xenial

# setup environment
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV \
  LANG=en_US.UTF-8 \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm \
  ROS_DISTRO=kinetic

# setup keys
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# Setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list


# Install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    wget \
    tmux

RUN apt-get install --no-install-recommends -y \
    python-pip \
    git \
    build-essential \
    software-properties-common \
    bash-completion \
    debian-keyring \
    debian-archive-keyring \
    ssh \
    openssh-server \
    mesa-utils \
    pkg-config \
    libprotobuf-dev \
    protobuf-compiler \
    libprotoc-dev \
    ros-kinetic-teleop-twist-keyboard \
    && \
    apt-get clean && \
    apt-get autoremove && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc

RUN pip install matplotlib

# Install the Intel binary drivers
RUN apt-get update && \
    apt-get install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    xserver-xorg-video-intel

RUN mkdir -p /catkin_ws
WORKDIR /catkin_ws

CMD tmux
