
# -*- coding: utf-8 -*-
"""
Created on Fri April 7 17:13:22 2023
@author: PhoenixWANG
"""

import time
import serial
import pandas as pd
import numpy as np

#根据Arduino代码设置串口（Serial）信息
ser = serial.Serial(
    port = 'COM3',
    baudrate = 9600,
    parity = serial.PARITY_ODD,
    stopbits = serial.STOPBITS_TWO,
    bytesize = serial.SEVENBITS,
    
    )

#设置生成数据集文件位置
outputpath = 'D:/PolyU/year3 sem02/ME31002/Lab MiniProject/Lab3/2DOF_TWOOverdamped.csv'


#定义数据收集函数
def datacollection(ser,list1,time1,t_initial,length,outputpath = False):
    
    for i in range(length):#length: 需要的数据集大小
        
        data = ser.readline()#读取串口信息
        time1.append(time.time()-t_initial)#计算当前时间差
        list1.append(data)#添加数据

    for i in range(length):
        
        list1[i] = float(list1[i].decode('utf-8'))#对串口读取数据根据utf-8解码表解码为字符串
    
    if outputpath != False:#如果制定了输出路径，则为要分析的运动数据集，而非检查初末位置
        
        diction = {
            'Time':time1,
            'Distance':list1,
            }
        
        result = pd.DataFrame(diction)#生成DataFrame为输出数据集做准备
        
        return result
    
    else:#检查初末位置
        
        position =  (1+np.std(list1)/np.mean(list1))*np.mean(list1)#减少噪音的影响，近似估计位置
        
        return position



data = ''#提前占上内存

list1,time1 = [],[]#初始化收集距离与时间数据的容器

count = 0#是否开始正式测量，而非检查初末位置的标志

t_initial = time.time()#获得实验开始时间

length = 300

#计算初位置
print("Check your initial position\n")

pos_initial = datacollection(ser,list1,time1,t_initial,length)


#计算整个运动过程中数据
count = input("Please input 1 for start\n")

if int(count) == 1:#开始记录实验
    
    list1,time1 = [],[]

    print("Release!!!!\n")
    
    time.sleep(1.5)#延时1.5s给人反应的时间
    
    t_initial = time.time()#获得实际实验开始的初始时间
    
    result = datacollection(ser, list1, time1, t_initial, length,outputpath)#获得整体数据集



#计算末位置
list1,time1 = [],[]
t_initial = time.time()

print("Check your Final position\n")

pos_final = datacollection(ser, list1, time1, t_initial, length,outputpath = False)



#进行平移，使得数据整体与坐标轴尽可能对齐

idx = 0;#初始化起点index

for i in range(len(result)):
    if abs(result['Distance'][i] - pos_initial) >=30:#如果和估算初位置差别过大，则index前一个数据可以视为起点
        idx = i-1
        break
    
result = result.iloc[idx:,:]#切除前面不必要的冗余数据

result['Distance'] = result['Distance'] - pos_final#将数据向下平移到坐标轴上，获得delta_x

result.to_csv(outputpath,sep = ',',index = False, header = True)#输出最终的数据集文件，用于MATLAB仿真

#关闭同Arduino的串口
ser.close()

