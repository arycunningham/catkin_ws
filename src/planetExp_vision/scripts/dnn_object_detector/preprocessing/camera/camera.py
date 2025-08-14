""" # GenericCamera Class

## Description:
    Basic camera class that handles FOV and target location estimations.
"""

from math import atan
from math import pi
from math import cos
from math import sin
from math import tan


class GenericCamera:
    def __init__(self, focalLength, sensorWidth, sensorHeight, resX, resY, offsetX, offsetY, offsetZ, gimbalAngle=0.0):
        """GenericCamera Constructor

        Arguments:
            focalLength {double} -- Camera's Focal Length in mm.
            sensorWidth {[type]} -- [description]
            sensorHeight {[type]} -- [description]
            resX {[type]} -- [description]
            resY {[type]} -- [description]
            offsetX {[type]} -- [description]
            offsetY {[type]} -- [description]
            offsetZ {[type]} -- [description]

        Keyword Arguments:
            gimbalAngle {float} -- [description] (default: {0.0})

        Returns:
            [type] -- [description]
        """
        self.gimbalAngle = gimbalAngle
        self.focalLength = focalLength
        self.sensorWidth = sensorWidth
        self.sensorHeight = sensorHeight
        self.resX = resX
        self.resY = resY
        self.alpha = self.gimbalAngle * pi / 180
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.offsetZ = offsetZ

        @classmethod
        def fromROSTopic(cls, cameraInfo, sensorWidth, offsetX, offsetY, offsetZ, gimbalAngle=0):
            resX = cameraInfo.width
            resY = cameraInfo.height
            focalLength = cameraInfo.K[0]
            # sensorWidth = 2 * focalLength * tan((FOV * pi / 180) / float(2))
            sensorHeight = sensorWidth * (resY/float(resX))
            alpha = gimbalAngle * pi / 180
            return cls(gimbalAngle, focalLength, sensorWidth, sensorHeight, resX, resY, alpha, offsetX, offsetY, offsetZ)

    def fov(self):
        return 2 * atan(self.sensorWidth / float(2 * self.focalLength))

    def calculategsd(self, altitude, imgPointY=0):
        beta = self.alpha - 0.5 * self.fov()
        gamma = self.alpha + 0.5 * self.fov()
        delta = (beta - gamma)/(self.resY - 1) * imgPointY + gamma

        if(self.gimbalAngle < 10):
            return (self.sensorWidth * altitude) / (self.focalLength * self.resX)
        elif imgPointY >= (0.5*pi - gamma)*(self.resY - 1)/(beta - gamma) and imgPointY <= (self.resY - 1):
            return (self.sensorWidth * altitude) / (self.focalLength * self.resX * cos(delta))
        else:
            return 0

    def calculateobjectdistance(self, altitude, imgPointX, imgPointY=0):
        beta = self.alpha - 0.5 * self.fov()
        gamma = self.alpha + 0.5 * self.fov()
        delta = (beta - gamma)/(self.resY - 1) * imgPointY + gamma

        if imgPointY >= (pi/2 - gamma)*(self.resY - 1)/(beta - gamma) and imgPointY <= (self.resY - 1):
            distanceX = (altitude / cos(delta)) - self.offsetX
        else:
            distanceX = 0
        if(self.gimbalAngle < 10):
            distanceX = self.calculategsd(
                altitude, imgPointX) * (self.resX / 2 - imgPointX + 1) - self.offsetX

        distanceY = self.calculategsd(
            altitude, imgPointY) * (self.resY / 2 - imgPointY + 1) - self.offsetY
        return [distanceX, distanceY]

    def calculateObjCoords(self, targetDistance, uavHeading, uavPose):
        # distX = targetDistance[0] * sin(self.alpha)
        # distY = targetDistance[1]
        targetX = targetDistance[0] * cos(uavHeading) - \
            targetDistance[1] * sin(uavHeading) + uavPose[0]
        targetY = targetDistance[0] * sin(uavHeading) + \
            targetDistance[1] * cos(uavHeading) + uavPose[1]
        targetZ = 0.15 + self.offsetZ

        if(self.gimbalAngle < 10):
            return [targetY, targetX, targetZ]
        else:
            return [targetX, targetY, targetZ]

    def calculateFOVLimits(self, robotHead, uavPose, altitude):
        """Calculate corner coordinates of Field of View

        Arguments:
            robotHead {double} -- UAV heading in radians.
            uavPose {vector} -- Position Vector of UAV.
            altitude {double} -- UAV height in metres.

        Returns:
            [type] -- [description]
        """
        horFOV = 2 * atan(self.sensorWidth / (2 * self.focalLength))
        verFOV = 2 * atan(self.sensorHeight / (2 * self.focalLength))

        # Calculate FOV limits with center (0, 0)
        limitTop = altitude * tan(self.gimbalAngle + (0.5 * horFOV))
        limitBottom = altitude * tan(self.gimbalAngle - (0.5 * horFOV))
        limitLeft = altitude * tan(self.gimbalAngle + (0.5 * verFOV))
        limitRight = altitude * tan(self.gimbalAngle - (0.5 * verFOV))

        # Construct corner points
        _FOVLimits = {}
        # Top left point
        _FOVLimits[0] = Point(limitTop, limitLeft)
        # Top right point
        _FOVLimits[1] = Point(limitTop, limitRight)
        # Bottom right point
        _FOVLimits[2] = Point(limitBottom, limitRight)
        # Bottom left point
        _FOVLimits[3] = Point(limitBottom, limitLeft)

        for point in _FOVLimits:
            # Rotate points
            rotX = _FOVLimits[point].x * \
                cos(robotHead) - _FOVLimits[point].y * sin(robotHead)
            rotY = _FOVLimits[point].x * \
                sin(robotHead) + _FOVLimits[point].y * cos(robotHead)

            # Apply offsets
            _FOVLimits[point].x = rotX + uavPose[0]
            _FOVLimits[point].y = rotY + uavPose[1]

        return _FOVLimits

    def set_res_x(self, res_x):
        self.resX = res_x

    def set_res_y(self, res_y):
        self.resY = res_y


class Point:
    def __init__(self, px=0.0, py=0.0):
        self.x = px
        self.y = py
