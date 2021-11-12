#!/usr/bin/env python3
from ev3dev.ev3 import *
import time

mA = LargeMotor('outA')
timeStart = time.time()
mA.position = current_time = start_time = 0

fh = open('data.txt', 'w')
fh.write('0' + '0' + '\n')

start_time = time.time()





target_theta = 580
kp = 7

while True:
	current_time = time.time() - start_time
	error = target_theta - mA.position
	U = kp*error
	if (U > 100):
		U = 100
	if (U < -100):
		U = -100
	mA.run_direct(duty_cycle_sp=U)
	fh.write(str(current_time) + ' ' + str(mA.position) + '\n')
	if (current_time - start_time >= 10):
		mA.stop(stop_action = 'brake')
		fh.close