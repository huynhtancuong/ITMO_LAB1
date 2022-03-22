#!/usr/bin/env python3

# Import the necessary libraries
import time
import math
from ev3dev2.motor import *
from ev3dev2.sensor import *
from ev3dev2.sensor.lego import *
# from ev3dev2.sensor.virtual import *

# Here is where your code starts

def rotatePoint(x, y, angle):
        newx = x*math.cos(angle) - y*math.sin(angle)
        newy = x*math.sin(angle) + y*math.cos(angle)
        return newx, newy

def xyToXY(x, y, a, b):
    # a is diffence from original coordinate system's Oy to new coordinate system's Oy
    # b is diffence from original coordinate system's Ox to new coordinate system's Ox
    X = x - a 
    Y = y - b
    return X, Y
    
def XYToxy(X, Y, a, b):
    # a is diffence from original coordinate system's Oy to new coordinate system's Oy
    # b is diffence from original coordinate system's Ox to new coordinate system's Ox
    x = X + a 
    y = Y + b
    return x, y
        
def myGetSign(n):
    if n == 0:
        return -1
    return math.copysign(1, n)
    
def get_distance(x1,y1,x2,y2):
    distance = math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))
    return distance

class Car: 

    # Parameters for car
    RADIUS_OF_WHEEL = 0.025
    DISTANCE_BETWEEN_WHEELS = 0.15
    PI = math.pi
    DEG2RAD = PI / 180
    ERROR = 0.5
    DISTANCE_TO_OBSTACLE = 0.8

    # Coefficients for P controller 
    K_STRAIGHT = 200
    K_ROTATION = 200

    def __init__(self, leftMotor, rightMotor, distanceList, gyro_sensor):
       self.leftMotor = leftMotor
       self.rightMotor = rightMotor 
       self.distanceList = distanceList
       self.gyro_sensor = gyro_sensor
       self.leftMotor.position = 0
       self.rightMotor.position = 0
       self.prevLeftAngel = 0
       self.prevRightAngel = 0
       self.xGoal = 0
       self.yGoal = 0
       self.distance = 0
       self.fileWriter = open("Data/data.txt", "w")

       # Define some innitial value of robot
       self.xCoord, self.yCoord = 0, 0 # This is initial coordinate of robot 
       self.course = 0 # This is initial course angle of robot (theta). The angle between vector linear velocity and Ox axis.
       self.startTime = time.time() # This is initial time 
       
    def writeToFile(self, currentTime):
        self.fileWriter.write(str(currentTime)+ ", "+ str(self.xCoord) + ", " + str(self.yCoord) + ", " + str(self.xGoal) + ", " + str(self.yGoal) + ", " + str(self.xGoal_real) + ", " + str(self.yGoal_real) + ", " + str(self.heading) + ", " + str(self.distance) + ", ")
        for angle, US in self.distanceList.items():
            Distance = US.distance_centimeters/100 #convert cm to m
            obstacleAngle = -angle
            self.fileWriter.write(str(obstacleAngle)+ ", " + str(Distance)+ ", ")
        self.fileWriter.write("\n\n")

    def run(self, pwmLeft, pwmRight):
       self.leftMotor.on(pwmLeft)
       self.rightMotor.on(pwmRight)

    
    def update_realGoal(self, xGoal, yGoal):
        self.xGoal_real = xGoal
        self.yGoal_real = yGoal
        
    def update_fakeGoal(self, angle):
        X_target, Y_target = xyToXY(self.xGoal_real, self.yGoal_real, self.xCoord, self.yCoord)
        X_target_rotated, Y_target_rotated = rotatePoint(X_target, Y_target, angle)
        x_target, y_target = XYToxy(X_target_rotated, Y_target_rotated, self.xCoord, self.yCoord)
        self.xGoal, self.yGoal = x_target, y_target
        
    def get_obstacleAngle(self):
        obstacleAngle = 180 #if no obstacle found
        minDistance = self.DISTANCE_TO_OBSTACLE
        minAngle = obstacleAngle
        for angle, US in self.distanceList.items():
            if (US.distance_centimeters/100 < minDistance):
                # if (abs(obstacleAngle-angle)<minAngle):
                minDistance = US.distance_centimeters/100 #convert cm to m
                obstacleAngle = -angle
        return obstacleAngle*self.DEG2RAD #beta angle
        
    def get_angleAlpha(self, headingAngle):
        return -headingAngle
        
    def get_rotationAngle(self, obstacleAngle):
        angleAlpha = self.get_angleAlpha(self.get_headingToRealGoal()) #for angle_alpha > 0 when obstacle on the right side
        
        # if (math.copysign(1,angleAlpha) != math.copysign(1, obstacleAngle)):
            # return 0
        
        rotationAngle = myGetSign(obstacleAngle)*(math.pi/2) - (obstacleAngle - angleAlpha)
        return rotationAngle
        
    def get_course_angle(self):
        course = (self.curRightAngle - self.curLeftAngle) * self.RADIUS_OF_WHEEL / self.DISTANCE_BETWEEN_WHEELS
        # course = -self.gyro_sensor.angle*self.DEG2RAD
        return course


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
        self.course = self.get_course_angle()

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
        # self.linearSpeed = self.K_STRAIGHT * self.distance
        self.linearSpeed = self.K_STRAIGHT * self.distance * math.cos(self.heading)
        if abs(self.linearSpeed) > 50:
            self.linearSpeed = math.copysign(1, self.linearSpeed) * 50
        return self.linearSpeed
    
    def get_angularSpeed(self):
        # calculation of angular velocity
        # self.angularSpeed = self.K_ROTATION*self.heading
        self.angularSpeed = self.K_STRAIGHT * math.sin(self.heading) * math.cos(self.heading) + self.K_ROTATION*self.heading
        if abs(self.angularSpeed) > 30:
            self.angularSpeed = math.copysign(1, self.angularSpeed) * 30
        return self.angularSpeed
    
    def isNearGoal(self, error):
        self.update_coordinate()
        if self.distance <= error:
            return True
        else:
            return False

    def get_headingToRealGoal(self):
        # Calculate the distance between current's x, y and goal's x, y
        deltaX, deltaY = self.xGoal_real - self.xCoord, self.yGoal_real - self.yCoord
        # Update bearing (góc giữa Ox và vector chỉ từ vị trí hiện tại đến vị trí đích)
        bearing = math.atan2(deltaY, deltaX)
        # Update heading (angle alpha) 
        headingToRealGoal = bearing - (self.course)
        #print(headingToRealGoal)
        simplified_headingToRealGoal = headingToRealGoal%(math.pi*2)
        if (simplified_headingToRealGoal>-math.pi) and (simplified_headingToRealGoal<math.pi):
            return simplified_headingToRealGoal
        else:
            simplified_headingToRealGoal =  simplified_headingToRealGoal - 2*math.pi
            return simplified_headingToRealGoal

    def move_to(self, x, y):
        currentTime = time.time()-self.startTime
        lastPrintTime = currentTime
        
        print("Start!")
        self.update_realGoal(x, y)
        print("Real: ", self.xGoal_real, self.yGoal_real)
        self.update_fakeGoal(0)
        print("Fake: ", self.xGoal, self.yGoal)
        self.update_coordinate()
        
        while(not(self.isNearGoal(self.ERROR))):
            currentTime = time.time()-self.startTime
            obstacleAngle = self.get_obstacleAngle()
            
            rotationAngle = 0
            if obstacleAngle != 180*self.DEG2RAD:
                if ((math.copysign(1, self.get_angleAlpha(self.get_headingToRealGoal()))) == (math.copysign(1, obstacleAngle))):
                    rotationAngle = self.get_rotationAngle(obstacleAngle)
                    
            self.update_fakeGoal(rotationAngle)
            
            if (currentTime-lastPrintTime>=3 and False):
                print("Angle beta: ", obstacleAngle)
                print("Angle alpha: ", self.get_angleAlpha(self.get_headingToRealGoal()))
                print("Angle phi: ", rotationAngle)
                print("Real: ", self.xGoal_real, self.yGoal_real)
                print("Fake: ", self.xGoal, self.yGoal)
                # print("xy coordinate system: ", self.xCoord, self.yCoord)
                # print("XY coordinate system: ", xyToXY(self.xGoal_real, self.yGoal_real, self.xCoord, self.yCoord))
                print()
                # print("Heading to fake goal: ", self.heading, math.degrees(self.heading))
            
            self.update_coordinate()
            self.get_linearSpeed()
            self.get_angularSpeed()
            self.update_pwmLeft()
            self.update_pwmRight()
            self.run(self.pwmLeft, self.pwmRight)
            self.writeToFile(currentTime)
            
        self.run(0, 0)
        self.fileWriter.close()
        print("Goal!")
        
        
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

    # US4 = UltrasonicSensor(INPUT_4)
    # US5 = UltrasonicSensor(INPUT_5)
    # US6 = UltrasonicSensor(INPUT_6)
    # US7 = UltrasonicSensor(INPUT_7)
    # US8 = UltrasonicSensor(INPUT_8)
    # US9 = UltrasonicSensor(INPUT_9)
    # US10 = UltrasonicSensor(INPUT_10)
    # US11 = UltrasonicSensor(INPUT_11)
    # US12 = UltrasonicSensor(INPUT_12)
    # US13 = UltrasonicSensor(INPUT_13)
    # US14 = UltrasonicSensor(INPUT_14)
    # US15 = UltrasonicSensor(INPUT_15)
    # US16 = UltrasonicSensor(INPUT_16)
    # US17 = UltrasonicSensor(INPUT_17)
    # US18 = UltrasonicSensor(INPUT_18)
    # US19 = UltrasonicSensor(INPUT_19)
    # US20 = UltrasonicSensor(INPUT_20)

    US1 = UltrasonicSensor(INPUT_1)
    US2 = UltrasonicSensor(INPUT_2)
    US3 = UltrasonicSensor(INPUT_3)
    US4 = UltrasonicSensor(INPUT_4)
    
    
    # gps_sensor = GPSSensor(INPUT_2)
    # pen = Pen(INPUT_3)
    # pen.down()
    
    # gyro_sensor = GyroSensor(INPUT_1)
    
    distanceList = {
        # 90:US4,
        # 78.75:US5,
        # 67.5:US6,
        # 56.25:US7,
        # 45.0:US8,
        # 33.75:US9,
        # 22.5:US10,
        # 11.25:US11,
        # 0.0:US12,
        # -10:US13,
        # -21.25:US14,
        # -32.5:US15,
        # -43.75:US16,
        # -55.0:US17,
        # -66.25:US18,
        # -77.5:US19,
        # -88.75:US20
        90:US1,
        45:US2,
        -45:US3,
        -90:US4

    }

    
    
    robot = Car(motorA, motorB, distanceList, None)
    
    robot.move_to(3, 0)
    #robot.move_to(0, 0)
    
    
    
    
    
    
    