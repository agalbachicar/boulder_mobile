#!/usr/bin/env python

import math
import rospy
from geometry_msgs.msg import Twist
from std_msgs.msg import UInt8

from boulder_mobile import BoulderMobile

class TwistToBicycleCar(object):

    def __init__(self):
        rospy.init_node('twist_to_bicyclecar', anonymous=True)
        self.bm = BoulderMobile()
        # Publishers to control the car
        self.steering_pub = rospy.Publisher('command/steering', UInt8, queue_size=10)
        self.left_wheel_pub = rospy.Publisher('command/left_wheel_speed', UInt8, queue_size=10)
        self.right_wheel_pub = rospy.Publisher('command/right_wheel_speed', UInt8, queue_size=10)
        # Subscriber to receive the twist command
        rospy.Subscriber("cmd_vel", Twist, self.cmd_vel_callback)
        rospy.spin()

    def cmd_vel_callback(self, data):
        angular = data.angular.z
        linear = data.linear.x
        steering_cmd, left_wheel_cmd, right_wheel_cmd = \
                self.bm.twist_2_steering_and_wheels(angular, linear)
        # Sends the commands
        steering_msg = UInt8()
        steering_msg.data = self.bm.steering_to_cmd(steering_cmd)
        self.steering_pub.publish(steering_msg)
        left_wheel_msg = UInt8()
        left_wheel_msg.data = self.bm.wheel_linear_speed_to_cmd(left_wheel_cmd)
        self.left_wheel_pub.publish(left_wheel_msg)
        right_wheel_msg = UInt8()
        right_wheel_msg.data = self.bm.wheel_linear_speed_to_cmd(right_wheel_cmd)
        self.right_wheel_pub.publish(right_wheel_msg)


if __name__ == '__main__':
    TwistToBicycleCar()
