#!/usr/bin/env python3

import os.path
import cv2
import numpy as np


if __name__ == "__main__":
    directory = os.path.dirname(os.path.abspath(__file__))
    pano_name = "DvP_net.jpg"

    pano_file = os.path.join(directory, pano_name)
    img = cv2.imread(pano_file)

    # Dimensions of the flying area in meters
    dims = (8, 6)
    small_side = 6/14
    long_side = 8/14

    # length and width of image
    width = img.shape[1]

    index = 0
    for i in range(4):
        # Starting with the long side
        if i % 2 == 0:
            increment = round(long_side*0.5*width)
            print(f"Long side is: {long_side}, width is: {width}, index is: {index}, endpoint is: {index+increment}. Percentage fill is:{index+increment/width} ")
        else:
            increment = round(small_side*0.5*width)
            print(f"Small side is: {small_side}, width is: {width}, index is: {index}, endpoint is: {index+increment}. Percentage fill is:{index+increment/width} ")

        print(f"Going from {index} to {index+increment} of possible {width}")
        new_img = img[:, index:index+increment]

        name = f"DvP_net{i}.jpg"
        cv2.imwrite(os.path.join(directory, name), new_img)
        index += increment
