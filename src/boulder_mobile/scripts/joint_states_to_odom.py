#!/usr/bin/env python

import math
from threading import Lock

import rospy
import tf

from geometry_msgs.msg import Point, Pose, Quaternion, Twist, Vector3
from nav_msgs.msg import Odometry
from std_msgs.msg import UInt8, UInt16

from boulder_mobile import BoulderMobile

class Pose2D(object):
    def __init__(self, x=0, y=0, theta=0):
        self._x = x
        self._y = y
        self._theta = theta

    def get_x(self):
        return self._x

    def get_y(self):
        return self._y

    def get_theta(self):
        return self._theta

    def __add__(self, other):
        self._x += other.get_x()
        self._y += other.get_y()
        self._theta += other.get_theta()
        return self

class BicycleTwist(object):
    def __init__(self, vx=0, vy=0, w=0):
        self._vx = vx
        self._vy = vy
        self._w = w

    def get_vx(self):
        return self._vx

    def get_vy(self):
        return self._vy

    def get_w(self):
        return self._w


class BicycleCarOdom(object):
    def __init__(self, pose=Pose2D(), twist=BicycleTwist()):
        rospy.init_node('bicyclecar_odom', anonymous=True)

        self._bm = BoulderMobile()

        self._last_t = rospy.Time.now()
        self._last_left_encoder = 0
        self._last_right_encoder = 0
        self._last_pose = pose
        self._last_twist = BicycleTwist()

        # Encoder counts
        self._steering = 90
        self._left_encoder = 0
        self._right_encoder = 0

        self._lock = Lock()

        # Publishers
        self._odom_publisher = rospy.Publisher('odom', Odometry, queue_size=5)
        self._odom_broadcaster = tf.TransformBroadcaster()
        # Subscribers
        rospy.Subscriber("joint_states/steering", UInt8, self._joint_steering_callback)
        rospy.Subscriber("joint_states/left_wheel", UInt16, self._joint_left_wheel_callback)
        rospy.Subscriber("joint_states/right_wheel", UInt16, self._joint_right_wheel_callback)

    def _joint_steering_callback(self, data):
        self._lock.acquire()
        self._steering = data.data
        self._lock.release()

    def _joint_left_wheel_callback(self, data):
        self._lock.acquire()
        self._left_encoder = data.data
        self._lock.release()

    def _joint_right_wheel_callback(self, data):
        self._lock.acquire()
        self._right_encoder = data.data
        self._lock.release()

    def _odometry_step(self, left_n, right_n, steering_angle, t):
        d_t = (t - self._last_t).to_sec()
        steering_rad = math.radians(steering_angle)

        d_theta_l = self._bm.encoder_count_to_rad(left_n - self._last_left_encoder)
        d_theta_r = self._bm.encoder_count_to_rad(right_n - self._last_right_encoder)

        wl = d_theta_l / d_t
        wr = d_theta_r / d_t

        vl = wl * self._bm.get_wheel_radius()
        vr = wr * self._bm.get_wheel_radius()

        v, w = self._bm.wheel_speeds_to_twist(vl, vr)
        vx = v * math.cos(steering_rad + self._last_pose.get_theta())
        vy = v * math.sin(steering_rad + self._last_pose.get_theta())

        d_x = vx * d_t
        d_y = vy * d_t
        d_theta = v / self._bm.get_rear_length() * math.sin(steering_rad)

        # Updates the pose
        self._last_pose = self._last_pose + Pose2D(x=d_x, y=d_y, theta=d_theta)
        # Updates the time
        self._last_t = t
        # Updates the encoders
        self._last_left_encoder = left_n
        self._last_right_encoder = right_n
        # Updates the last twist
        self._last_twist = BicycleTwist(vx=vx, vy=vy , w=w)

    def _pub_odom(self, t):
        odom_msg = Odometry()
        odom_msg.header.stamp = t
        odom_msg.header.frame_id = 'odom'

        odom_quat = tf.transformations.quaternion_from_euler( \
            0, 0, self._last_pose.get_theta())

        self._odom_broadcaster.sendTransform( \
                (self._last_pose.get_x(), self._last_pose.get_y(), 0.), \
                odom_quat, \
                t, \
                "base_link", \
                "odom")
        odom_msg.pose.pose = Pose(Point(self._last_pose.get_x(), \
                                        self._last_pose.get_y(), \
                                        0.), \
                                  Quaternion(*odom_quat))
        odom_msg.child_frame_id = "base_link"
        odom_msg.twist.twist = Twist(Vector3(self._last_twist.get_vx(), \
                                             self._last_twist.get_vy(), \
                                             0), \
                                     Vector3(0, 0, self._last_twist.get_w()))
        # publish the message
        self._odom_publisher.publish(odom_msg)

    def _pub_map_to_odom(self, t):
        self._odom_broadcaster.sendTransform( \
                (0., 0., 0.), (0., 0., 0., 1.), t, "map", "odom")

    def run(self, frequency):
        rate = rospy.Rate(frequency)
        while not rospy.is_shutdown():
            # Goes to sleep
            rate.sleep()
            # Acquires the lock to get the joint states
            self._lock.acquire()
            t = rospy.Time.now()
            left_n = self._left_encoder
            right_n = self._left_encoder
            steering_angle = math.radians(self._steering)
            self._lock.release()
            # Computes the odometry step
            self._odometry_step(left_n, right_n, steering_angle, t)
            # Publishes the odometry
            self._pub_odom(t)
            self._pub_map_to_odom(t)


if __name__ == '__main__':
    BicycleCarOdom().run(1)
