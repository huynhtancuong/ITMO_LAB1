#!/usr/bin/env python3
from ev3dev.ev3 import *
import time

mA = LargeMotor('outA')
timeStart = time.time()
mA.position = current_time = start_time = 0

fh = open('data.txt', 'w')
fh.write('0' + '0' + '0' + '\n')

start_time = time.time()

voltages = [-100, -90, -80, -70, -60, -50, -40, -30, -20, -10, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

try:
    for i in voltages:
        while True:
            current_time = time.time() - start_time
            if current_time > 1:
                break
            else:
                mA.run_direct(duty_cycle_sp=i)
                #fh.write(str(current_time) + ' ' + str(mA.position) + ' ' + str(mA.speed) + '\n')
        mA.run_direct(duty_cycle_sp=0)
        time.sleep(2)
        start_time = current_time
finally:
    mA.stop(stop_action = 'brake')
    fh.close