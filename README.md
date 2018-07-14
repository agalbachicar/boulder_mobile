# boulder_mobile

## Dependencies

### Ubuntu + ROS

This project runs into a Ubuntu 16.04 box and uses
[ROS Kinetic](http://wiki.ros.org/kinetic). For a full
installation guide, visit the following
[link](http://wiki.ros.org/kinetic/Installation/Ubuntu).

And then, you should install also:

```
sudo apt-get install ros-kinetic-teleop-twist-keyboard
```

To control the robot with the keyboard.

### Docker

Docker allows to port environments in a very light way. It'll allow you to
execute programs as it they were inside a virtual machine but running directly
at the OS level as any other process.

This project provides a docker image to avoid installing everythin. See this
[link](https://docs.docker.com/install/linux/docker-ce/ubuntu/) to install
docker in your Ubuntu box.

To run the docker and avoid all the ROS installation, just do the following:

```
cd docker
make ros_kinetic # To build the docker image
./run_ros_kinetic.sh
```

This repository will be mounted into a volume so you can use it within the
docker.

### ROS Serial

Bring ROS Serial to your workspace (see this
[link](http://wiki.ros.org/rosserial_arduino/Tutorials/Arduino%20IDE%20Setup)
for more information):

```
git clone https://github.com/ros-drivers/rosserial.git src/rosserial
```

Try compiling it:

```
catkin_make
```

### Matlab and Octave

Inside `/matab` folder you'll find a ton of Matlab / Octave scripts. Both should
be able to run them. Most of them are used for verification purposes.

## To build

See `docker/README` to run the docker if you don't want to configure everything.

Assuming you have a full ROS Kinetic installation, run from the base project
path:


```
catkin_make
. devel/setup.bash
```

## To run

Connect the robot through a serial port, we assume that you'll get the serial
communication through `/dev/ttyACM0`. Then, run the following in different
consoles:

```
roslaunch rosserial_server serial.launch
roslaunch boulder_mobile boulder_mobile.launch
```

Use the keyboard to control the **boulder_mobile**!

