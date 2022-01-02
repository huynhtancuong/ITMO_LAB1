#!/usr/bin/env python3
# -*- coding: utf8 -*-
from ev3dev.ev3 import *

import time
import math

ks=10
kr=6
Ur = 0
Us = 0
mA = LargeMotor('outA') #A - right, D - left
mD = LargeMotor('outD')
a = "lab4.txt"
start_time = time.time()
fh = open(a, 'w')
mA.position = 0
mD.position = 0
r = 2.75
B = 17
x0 = 0 
y0 = 0
ang = 0 
x = 3000
y = 3000
mApos_prev = mDpos_prev = 0;

while (((x - x0)**2 + (y - y0)**2)**0.5 > 100):
	posiA_cur = mA.position - mApos_prev
	posiD_cur = mD.position - mDpos_prev
	mApos_prev = mA.position
	mDpos_prev = mD.position
	Us = ks*(((x - x0)**2 + (y - y0)**2)**0.5)
	Ur = kr*(math.atan2(y-y0, x-x0)*180/math.pi - ang)

	if Ur > 40:
		Ur = 40
	elif Ur < -40:
		Ur = -40
	if Us > 60:
		Us = 60
	elif Us < -60:
		Us = -60

	UD = Us - Ur
	UA = Ur + Us

	x0 = x0 + math.cos(ang*math.pi/180)*(posiA_cur+posiD_cur)*r/2
	y0 = y0 + math.sin(ang*math.pi/180)*(posiA_cur+posiD_cur)*r/2

	mA.run_direct(duty_cycle_sp = UA)
	mD.run_direct(duty_cycle_sp = UD)
	ang = ang + (posiA_cur - posiD_cur)*r/B 
	fh.write(str(x0) + ' ' + str(y0) + '\n')
mA.run_direct(duty_cycle_sp = 0)
mD.run_direct(duty_cycle_sp = 0)
fh.close