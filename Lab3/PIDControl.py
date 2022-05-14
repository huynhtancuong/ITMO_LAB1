#!/usr/bin/env python3
from ev3dev.ev3 import *
from math import sqrt
import time
mA = LargeMotor('outA')
fh = open('data.txt', 'w')
fh.write('0' + ' ' + '0' + '\n')
target_angle = 580
kp = 3
ki = 0
kd = 0
start_time = time.time()
previous_time = start_time
integral = 0
previous_error = 0
current_time = time.time() - start_time
while (True):
	current_time = time.time() - start_time
	dt = current_time - previous_time
	d_now = mA.position
	error = target_angle - d_now
	proportional = error
	integral = integral + (error*dt)
	derivative = (error - previous_error)/dt
	U = kp*proportional + ki*integral + kd*derivative
	if (U > 100):
		U = 100
	if (U < -100):
		U = -100
	mA.run_direct(duty_cycle_sp=U)
	fh.write(str(current_time) + ' ' + str(mA.position) + '\n')
	previous_time = current_time
	previous_error = error


