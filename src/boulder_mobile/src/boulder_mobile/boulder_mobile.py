PKG = 'boulder_mobile'
import roslib; roslib.load_manifest(PKG)

import math

class BoulderMobile(object):
    _L = 0.155                                # [m]
    _L_R = _L / 2.                            # [m]
    _L_F = _L / 2.                            # [m]
    _W = 0.158                                # [m]
    _WHEEL_RADIUS = 0.065                     # [m]
    _ENCODER_COUNT = 48                       # [1]
    _STEER_ANGLE_MIN = 70. * math.pi / 180.   # [rad]
    _STEER_ANGLE_MAX = 110. * math.pi / 180.  # [rad]
    _STEER_ANGLE_OFF = math.pi / 2.           # [rad]

    def __init__(self):
        pass

    def get_length(self):
        return BoulderMobile._L

    def get_rear_length(self):
        return BoulderMobile._L_R

    def get_front_length(self):
        return BoulderMobile._L_F

    def get_wheel_base(self):
        return BoulderMobile._W

    def get_wheel_radius(self):
        return BoulderMobile._WHEEL_RADIUS

    def get_encoder_count(self):
        return BoulderMobile._ENCODER_COUNT

    def encoder_count_to_rad(self, n):
        return float(n / BoulderMobile._ENCODER_COUNT) * 2. * math.pi

    def steering_limits(self):
        return [BoulderMobile._STEER_ANGLE_MIN, BoulderMobile._STEER_ANGLE_MAX]

    def steering_angle_offset(self):
        return BoulderMobile._STEER_ANGLE_OFF

    def twist_2_steering_and_wheels(self, angular, linear):
        dsteering = 0
        vl = linear
        vr = linear
        if angular != 0.:
            r = linear / angular
            if r == 0: # TODO check min r
                rospy.logerr("Curvature radius is less than minimum")
                return 0, 0, 0
            dsteering = math.atan(BoulderMobile._L / r)
            vr = linear * (1. + BoulderMobile._W / (2. * r))
            vl = linear * (1. - BoulderMobile._W / (2. * r))
        return dsteering, vl, vr

    def wheel_linear_speed_to_cmd(self, vel):
        cmd = vel * 100 + 50 # % of PWM (normalized in 255 ?)
        cmd = math.min(cmd, BoulderMobile._CMD_VEL_MAX)
        cmd = math.max(cmd, BoulderMobile._CMD_VEL_MIN)
        return cmd

    def steering_to_cmd(self, steering):
        cmd = steering * 0.5 + BoulderMobile._STEER_ANGLE_OFF
        cmd = math.min(cmd, BoulderMobile._STEER_ANGLE_MAX)
        cmd = math.max(cmd, BoulderMobile._STEER_ANGLE_MIN)
        return math.degrees(cmd)

    def wheel_speeds_to_twist(self, vl, vr):
        # Checks the trivial case where the mobile is moving forward.
        if vl == vr:
            return vl, 0
        # Converts vl and vr to V and w
        if vr == 0:
            raise Exception('vl cannot be 0.')
        # Rotation radius
        r = _W * (1. + vl / vr) / (2. * (1 - vl / vr))
        # Linear and angular speed
        v = vl / (1 - _W / (2. * r))
        w = v / r
        return v, w
