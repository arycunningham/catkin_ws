# Source: Udacity Flying Cars Nanodegree.
# First import the utm and numpy packages
import utm
import numpy

# To convert a GPS position (longitude, latitude, altitude) to a local position (north, east, down)
# you need to define a global home position as the origin of your NED coordinate frame. In general
# this might be the position your vehicle is in when the motors are armed, or some other home base position.
# You first task is to define a function to convert from global position to a local position using the utm.


def global_to_local(global_position, global_home):
    """[summary]

    Args:
        global_position ([type]): [description]
        global_home ([type]): [description]

    Returns:
        [type]: [description]
    """
    (east_home, north_home, _, _) = utm.from_latlon(
        global_home[0], global_home[1])

    (east, north, _, _) = utm.from_latlon(
        global_position[0], global_position[1])

    local_position = numpy.array(
        [north - north_home, east - east_home, -(global_position[2] - global_home[2])])

    return local_position
# Now try converting a local position (north, east, down) relative to the home position to a global
# position (lat, long, up).


def local_to_global(local_position, global_home):
    """[summary]

    Args:
        local_position ([type]): [description]
        global_home ([type]): [description]

    Returns:
        [type]: [description]
    """
    (east_home, north_home, zone_number, zone_letter) = utm.from_latlon(
        global_home[0], global_home[1])

    (lat, lon) = utm.to_latlon(east_home + local_position[0],
                               north_home + local_position[1], zone_number,
                               zone_letter)

    global_position = numpy.array(
        [lat, lon, -(local_position[2]-global_home[2])])

    return global_position
