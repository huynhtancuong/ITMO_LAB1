#!/usr/bin/env python3

# Import the necessary libraries
import time
import math
from ev3dev2.motor import *
from ev3dev2.sensor import *
from ev3dev2.sensor.lego import *

# Here is where your code starts

class Car: 

    # Parameters for car
    RADIUS_OF_WHEEL = 0.025
    DISTANCE_BETWEEN_WHEELS = 0.15
    PI = math.pi
    DEG2RAD = PI / 180
    ERROR = 0.05

    # Coefficients for P controller 
    K_STRAIGHT = 500
    K_ROTATION = 200

    def __init__(self, leftMotor, rightMotor, US1, US2, US3):
       self.leftMotor = leftMotor
       self.rightMotor = rightMotor 
       self.US1 = US1 
       self.US2 = US2
       self.US3 = US3
       self.leftMotor.position = 0
       self.rightMotor.position = 0
       self.prevLeftAngel = 0
       self.prevRightAngel = 0
       self.xGoal = 0
       self.yGoal = 0

       # Define some innitial value of robot
       self.xCoord, self.yCoord = 0, 0 # This is initial coordinate of robot 
       self.course = 0 # This is initial course angle of robot (theta). The angle between vector linear velocity and Ox axis.
       self.startTime = time.time() # This is initial time 

    def run(self, pwmLeft, pwmRight):
       self.leftMotor.on(pwmLeft)
       self.rightMotor.on(pwmRight)
    
    def update_goal(self, xGoal, yGoal):
        self.xGoal = xGoal
        self.yGoal = yGoal


    def update_coordinate(self):
        # Update currentTime base on system time tick
        self.currentTime = time.time() - self.startTime

        # Get angle of 2 motors (ψ) and convert them to RAD (for easier calculation)
        self.curLeftAngle = self.leftMotor.position * self.DEG2RAD   
        self.curRightAngle = self.rightMotor.position * self.DEG2RAD
        
        # Calculate the change of motors's angle after a cycle 
        self.dRightAngle = self.curRightAngle - self.prevRightAngel
        self.dLeftAngle = self.curLeftAngle - self.prevLeftAngel

        # Assign previous motor's angle to current motor's angle
        self.prevLeftAngel, self.prevRightAngel = self.curLeftAngle, self.curRightAngle
        
        # Update the course angle (theta). (V; Ox). But acorrding to the formula, we need a previous course angle which need to be added.
        self.course = (self.curRightAngle - self.curLeftAngle) * self.RADIUS_OF_WHEEL / self.DISTANCE_BETWEEN_WHEELS

        # Update coordinates. 
        self.xCoord += math.cos(self.course) * (self.dRightAngle + self.dLeftAngle) * self.RADIUS_OF_WHEEL / 2
        self.yCoord += math.sin(self.course) * (self.dRightAngle + self.dLeftAngle) * self.RADIUS_OF_WHEEL / 2

        # Calculate the distance between current's x, y and goal's x, y
        self.deltaX, self.deltaY = self.xGoal - self.xCoord, self.yGoal - self.yCoord

        # Calculating distance to goal coordinate (tính khoảng cách từ vị trí hiện tại đến vị trí đích)
        self.distance = math.sqrt(self.deltaX * self.deltaX + self.deltaY * self.deltaY)

        # Update bearing (góc giữa Ox và vector chỉ từ vị trí hiện tại đến vị trí đích)
        self.bearing = math.atan2(self.deltaY, self.deltaX)

        # Update heading (angle alpha) 
        self.heading = self.bearing - self.course
        
        # shortest corner turn
        if abs(self.heading) > self.PI:
            self.heading -= math.copysign(1, self.heading) * 2 * self.PI
    
    def get_linearSpeed(self):
        # calculation of linear speed
        self.linearSpeed = self.K_STRAIGHT * self.distance
        if abs(self.linearSpeed) > 50:
            self.linearSpeed = math.copysign(1, self.linearSpeed) * 50
        return self.linearSpeed
    
    def get_angularSpeed(self):
        # calculation of angular velocity
        self.angularSpeed = self.K_ROTATION * self.heading
        if abs(self.angularSpeed) > 30:
            self.angularSpeed = math.copysign(1, self.angularSpeed) * 30
        return self.angularSpeed
    
    def nearGoal(self, error):
        self.update_coordinate
        if self.distance <= error:
            return True
        else:
            return False

    def move_to(self, x, y):
        self.update_goal(x, y)
        while(not(self.nearGoal(0.05))):
            self.update_coordinate()
            self.update_pwmLeft()
            self.update_pwmRight()
            self.run(pwmLeft, pwmRight)
        
        
    def update_pwmRight(self):
        # control conversion from float to integer, PWM percentage
        self.pwmRight = self.linearSpeed + self.angularSpeed
        if (abs(self.pwmRight) > 100):
            self.pwmRight = math.copysign(1, self.pwmRight) * 100
    
    def update_pwmLeft(self):
        self.pwmLeft = self.linearSpeed - self.angularSpeed
        if (abs(self.pwmLeft) > 100):
            self.pwmLeft = math.copysign(1, self.pwmLeft) * 100

if __name__ == "__main__":
    # Create the sensors and motors objects
    motorA = LargeMotor(OUTPUT_A)
    motorB = LargeMotor(OUTPUT_B)

    US1 = UltrasonicSensor(INPUT_1)
    US2 = UltrasonicSensor(INPUT_5)
    US3 = UltrasonicSensor(INPUT_6)
    
    #gps_sensor = GPSSensor(INPUT_3)
    #pen = Pen(INPUT_4)

    robot = Car(motorA, motorB, US1, US2, US3)

    robot.run(55,55)


for target in targets: # This is a loop, which go through every target in array targets.
    
    # Assign xGoal and yGoal
    xGoal = target[0] 
    yGoal = target[1]

    while (1):

        # Update currentTime base on system time tick
        currentTime = time.time() - startTime

        # Get angle of 2 motors (ψ) and convert them to RAD (for easier calculation)
        curLeftAngle = leftMotor.position * DEG2RAD   
        curRightAngle = rightMotor.position * DEG2RAD
        
        # Calculate the change of motors's angle after a cycle 
        dRightAngle = curRightAngle - prevRightAngel
        dLeftAngle = curLeftAngle - prevLeftAngel

        # Assign previous motor's angle to current motor's angle
        prevLeftAngel, prevRightAngel = curLeftAngle, curRightAngle
        
        # Update the course angle (theta). (V; Ox). But acorrding to the formula, we need a previous course angle which need to be added.
        course = (curRightAngle - curLeftAngle) * RADIUS_OF_WHEEL / DISTANCE_BETWEEN_WHEELS

        # Update coordinates. 
        xCoord += math.cos(course) * (dRightAngle + dLeftAngle) * RADIUS_OF_WHEEL / 2
        yCoord += math.sin(course) * (dRightAngle + dLeftAngle) * RADIUS_OF_WHEEL / 2

        # Calculate the distance between current's x, y and goal's x, y
        deltaX, deltaY = xGoal - xCoord, yGoal - yCoord

        # Calculating distance to goal coordinate (tính khoảng cách từ vị trí hiện tại đến vị trí đích)
        distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)

        # Update bearing (góc giữa Ox và vector chỉ từ vị trí hiện tại đến vị trí đích)
        bearing = math.atan2(deltaY, deltaX)

        # Update heading (angle alpha) 
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


        # exit when reaching goal area