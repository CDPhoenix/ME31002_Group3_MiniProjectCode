
# -*- coding: utf-8 -*-
"""
Created on Mon May 30 17:13:22 2022
@author: PhoenixWANG
"""

import time
import serial
import pandas as pd
ser = serial.Serial(
    port = 'COM3',
    baudrate = 9600,
    parity = serial.PARITY_ODD,
    stopbits = serial.STOPBITS_TWO,
    bytesize = serial.SEVENBITS
    
    )

data = ''
list1,time1 = [],[]
count = 0
t_initial = time.time()

while count<50:
    data = ser.readline()
    list1.append(data)
    time1.append(time.time()-t_initial)
    print(data)
    count += 1
    
length = len(list1)

for i in range(length):
    list1[i] = float(list1[i].decode('utf-8'))
    
diction = {
    'Time':time1,
    'Distance':list1,
    }
outputpath = 'D:/PolyU/year3 sem02/ME31002/Lab MiniProject/Lab3/data/oneLight_oneTight.csv'
result = pd.DataFrame(diction)
result.to_csv(outputpath,sep = ',',index = False, header = True)
