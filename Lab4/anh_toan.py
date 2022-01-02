#!/usr/bin/env python3
from ev3dev.ev3 import *
import time
import math

RAD_WHEEL = 0.025
DISTANCE_WHEELS = 0.15
PI = math.pi
DEG2RAD = PI / 180
ERROR = 0.05


leftMotor = LargeMotor('outA')
rightMotor = LargeMotor('outD')

prevLeftAngel, prevRightAngel = 0, 0
leftMotor.position = rightMotor.position = 0  # reset memory

K_STRAIGHT = 300
K_ROTATION = 300

#xGoal, yGoal = 2, 2

target = [[1, 1], [-1,1], [-1, -1], [1, -1]]
#target = [[-0.6,-1.1]]

#xGoal, yGoal = -xGoal, -yGoal

xCoord, yCoord = 0, 0
course = 0
startTime = time.time()
currentTime = startTime


# Function to write data with format "x y time":
def writeData(xCoord, yCoord, currentTime):
    sh.write(str(xCoord) + " " + str(yCoord) + " " + str(currentTime) + "\n")


sh = open("data.txt", "w")
writeData(xCoord, yCoord, currentTime)

for cor in target:
    xGoal = cor[1]*0.8
    yGoal = cor[0]*0.8

    while (1):
        # Time tick
        currentTime = time.time() - startTime

        # Get angle of 2 motors ψ
        curLeftAngle = leftMotor.position * DEG2RAD   
        curRightAngle = rightMotor.position * DEG2RAD
        
        #Tính độ thay đổi của góc motor hiện tại so với chu kỳ trước 
        dRightAngle = curRightAngle - prevRightAngel
        dLeftAngle = curLeftAngle - prevLeftAngel


        prevLeftAngel, prevRightAngel = curLeftAngle, curRightAngle
        
        # Update course (chỗ này lú, sao ko có 0prev?)
        course = (curRightAngle - curLeftAngle) * RAD_WHEEL / DISTANCE_WHEELS

        # Update coordinates (tính tọa độ hiện tại bằng công thức thôi) 
        xCoord += math.cos(course) * (dRightAngle + dLeftAngle) * RAD_WHEEL / 2
        yCoord += math.sin(course) * (dRightAngle + dLeftAngle) * RAD_WHEEL / 2


        deltaX, deltaY = xGoal - xCoord, yGoal - yCoord

        # calculating distance to goal coordinate (tính khoảng cách từ vị trí hiện tại đến vị trí đích)
        distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)

        # Update bearing (góc giữa Ox và vector chỉ từ vị trí hiện tại đến vị trí đích)
        bearing = math.atan2(deltaY, deltaX)

        # Update heading (góc alpha) 
        heading = bearing - course

        # shortest corner turn
        if abs(heading) > PI:
            heading -= math.copysign(1, heading) * 2 * PI


        # calculation of linear speed
        baseSpeed = K_STRAIGHT * distance
        if abs(baseSpeed) > 50:
            baseSpeed = math.copysign(1, baseSpeed) * 50

        # calculation of angular velocity
        control = K_ROTATION * heading
        if abs(control) > 30:
            control = math.copysign(1, control) * 30

        # control conversion from float to integer, PWM percentage
        pwmRight = baseSpeed + control
        pwmLeft = baseSpeed - control

        if (abs(pwmLeft) > 100):
            pwmLeft = math.copysign(1, pwmLeft) * 100
        if (abs(pwmRight) > 100):
            pwmRight = math.copysign(1, pwmRight) * 100

        leftMotor.run_direct(duty_cycle_sp=int(pwmLeft))
        rightMotor.run_direct(duty_cycle_sp=int(pwmRight))

        # Write data
        writeData(yCoord, xCoord, currentTime)

        # exit when reaching goal area
        if (distance < ERROR):
            leftMotor.stop(stop_action='brake')
            rightMotor.stop(stop_action='brake')
            #sh.close()
            sh.write("\n\n\n")
            break
            
sh.close()
