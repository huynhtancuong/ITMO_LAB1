#!/usr/bin/env python3
from ev3dev.ev3 import *
import time

mA = LargeMotor('outA')
timeStart = time.time()
mA.position = current_time = start_time = 0



start_time = time.time()

try:
    for i in range(-100, 101, 10):
        fh = open('data_'+str(i)+'.txt', 'w')
        fh.write('0' + ' ' + '0' + ' ' + '0' + '\n')
        start_time = time.time()
        #current_time = time.time() - start_time
        #start_time = current_time
        while True:
            current_time = time.time() - start_time
            if current_time > 3:
                break
            else:
                mA.run_direct(duty_cycle_sp=i)
                fh.write(str(current_time) + ' ' + str(mA.position) + ' ' + str(mA.speed) + '\n')
        mA.run_direct(duty_cycle_sp=0)
        time.sleep(2)
        #start_time = current_time
finally:
    mA.stop(stop_action = 'brake')
    fh.close