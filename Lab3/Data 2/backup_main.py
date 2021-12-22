#!/usr/bin/env python3
from ev3dev.ev3 import *
from math import sqrt
import time

leftM = MediumMotor('outA')
rightM = MediumMotor('outB')

us1 = UltrasonicSensor('in1')
us1.mode='US-DIST-CM'

fh = open('data.txt', 'w')
fh.write('0' + ' ' + '0' + '\n')


target_d = 30


kp = 3
ki = 0
kd = 0
 


start_time = time.time()
previous_time = start_time
integral = 0
previous_error = 0
current_time = time.time() - start_time


def getUS1():
	return us1.value()/10


while (True):
	
	#fh.write(str(current_time) + ' ' + str(getUS1()) + ' ' + str(getUS2()) + ' ' + str(cald(h, getUS1(), getUS2())) + '\n')
	
	current_time = time.time() - start_time
	dt = current_time - previous_time

	d_now = getUS1()
	error = target_d - d_now

	proportional = error
	integral = integral + (error*dt)
	derivative = (error - previous_error)/dt
	
	Ur = kp*proportional + ki*integral + kd*derivative
	U_left = Ur 
	U_right = Ur
	
	if (U_left > 100):
		U_left = 100
	if (U_left < -100):
		U_left = -100
	if (U_right > 100):
		U_right = 100
	if (U_right < -100):
		U_right = -100

	#fh.write(str(current_time) + ' ' + str(U_left) + ' ' + str(U_right) + ' ' + str(d_now) + '\n')	

	leftM.run_direct(duty_cycle_sp=U_left)
	rightM.run_direct(duty_cycle_sp=U_right)

	#mA.run_direct(duty_cycle_sp=U)
	#fh.write(str(current_time) + ' ' + str(mA.position) + '\n')
	previous_time = current_time
	previous_error = error

