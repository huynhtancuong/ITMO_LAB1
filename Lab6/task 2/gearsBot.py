#!/usr/bin/env python3

# Import the necessary libraries
import time
import math
from ev3dev2.motor import *
from ev3dev2.sound import Sound
from ev3dev2.button import Button
from ev3dev2.sensor import *
from ev3dev2.sensor.lego import *
from ev3dev2.sensor.virtual import *

# Define constants
PI = 3.14159
DtoR = PI/180
CMtoM = 1/100

# Class for Degree of Freedom 

class DoF:
    reverse = False
    def __init__(self, motor):
        self.motor = motor
    def on_to_position(self, speed, angle_in_rad):
        if (self.reverse == False):
            angle_to_drive = angle_in_rad
        else:
            angle_to_drive = -angle_in_rad
        
        self.motor.on_to_position(speed, angle_to_drive*180/PI, block=False)
    def set_reverse(self, state=True):
        self.reverse = state
    def get_position(self):
        if (self.reverse):
            return -self.motor.position*DtoR
        else:
            return self.motor.position*DtoR
            


# Class for Robot Arm 

class Arm:
    def __init__(self, dof1, dof2, dof3, gps):
        self.dof1 = dof1
        self.dof2 = dof2
        self.dof3 = dof3
        self.gps = gps
        self.start_time = time.time()
    def print_log(self):
        # time, theta1, theta2, theta3, gripper_x, gripper_y, gripper_z
        template = "{:.5f}, {:.5f}, {:.5f}, {:.5f}, {:.5f}, {:.5f}, {:.5f}"
        
        cur_time = time.time() - self.start_time
        print(template.format(  cur_time, 
                                self.dof1.get_position(), self.dof2.get_position(), self.dof3.get_position(), 
                                self.gps.x*CMtoM, self.gps.y*CMtoM, self.gps.altitude*CMtoM))
    
    def on_to_angle(self, theta1, theta2, theta3, speed = 2):
        print("Time, Target theta1 = %r, target theta2 = %r, target theta3 = %r, gripper_x, gripper_y, gripper_z"%(theta1, theta2, theta3))
        dof1.on_to_position(speed, theta1)
        dof2.on_to_position(speed, theta2)
        dof3.on_to_position(speed, theta3)
        while(time.time() - self.start_time <6):
            self.print_log()
            time.sleep(0.03)

# Create the sensors and motors objects

spkr = Sound()
btn = Button()
radio = Radio()

pen_in1 = Pen(INPUT_1)
gps = GPSSensor(INPUT_2)

motorA = LargeMotor(OUTPUT_A) # Swivel
motorB = LargeMotor(OUTPUT_B) # Swivel
motorC = LargeMotor(OUTPUT_C) # Swivel
motorD = LargeMotor(OUTPUT_D) # Swivel

# Here is where your code starts

pen_in1.down()

dof1 = DoF(motorA)
dof2 = DoF(motorB)
dof2.set_reverse()
dof3 = DoF(motorC)
dof3.set_reverse()

arm = Arm(dof1, dof2, dof3, gps)

arm.on_to_angle(PI/2, PI/4, -PI/4)
    























