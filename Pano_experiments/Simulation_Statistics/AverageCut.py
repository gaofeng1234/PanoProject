# -*- coding: utf-8 -*-
import os
import sys
from numpy import *
import numpy as np
import copy

# 状态码为 0代表正常， 5代表不从0开始， 2代表 快进， 3代表卡顿，4代表回放,1，6代表异常

# 以用户为单位进行，对观看次数比较高的用户对他们进行切片
def listdir(path, list_name):  # 传入存储的list
    for file in os.listdir(path):
        list_name.append(file)

def RotationAngle(userID,videoID,timestamp,threshold):
    path2="C:/Aiqiyi/new_iqiyi_all/1_1s/"
    file=open(path2+userID+"_"+videoID+"_"+timestamp+"_1s.txt","r")
    sum=0
    total=0
    lines=file.readlines()
    time = float((lines[0].split(" "))[0])
    if(len(lines)<=5 or time>1):
        return -1
    for line in lines:
        temp=line.split(" ")
        sum=sum+float(temp[2])
    if sum<=20:
        return -1
    file.close()
    return 1



path1="C:/Aiqiyi/Final/dataresult/PerUserWatching/"
usernameFilename="PerUserWatchingTimes.txt"
usernameFile=open(path1+usernameFilename,"r")
userNameLines=usernameFile.readlines()
rank=[2,4,5]
userName=[]
for i in range(0,len(rank)):
    line=userNameLines[rank[i]]
    temp=line.split(",")
    userName.append(temp[1][0:len(temp[1])-1])


path = "C:/Aiqiyi/new_iqiyi_all/iqiyi_xyz_raw_final/"
outputpath="C:/Aiqiyi/Final/dataresult/Cut_User_Average/"

#filename_list = ["VR_569229100_357755071703969_1506003388286_.txt"]
filename_list=[]
listdir(path, filename_list)
filename_list=sorted(filename_list) # 进行排序

for userN in userName:
    userId = userN
    kk = 0
    outputfile = open(outputpath + "cut_user_" + str(userId) + "_average_.txt", 'w')
    for filename in filename_list:
        temp = filename.split("_")
        uID = temp[2]
        kk = kk + 1
        print filename
        print str(kk) + " " + str(len(filename_list))
        if uID != userId:
            continue
        file = open(path + filename, "r")
        temp = filename.split("_")
        videoid = temp[1]
        deviceid = temp[2]
        lines = file.readlines()
        #if len(lines) < 30 and RotationAngle(deviceid, videoid, temp[3], 30) == -1:
            #file.close()
            #continue
        data = []
        for line in lines:
            temp = line.split(",")
            x = float(temp[1])
            y = float(temp[2])
            z = float(temp[3])
            time = float(temp[0])
            data.append([x, y, z, time])
        vP = []
        start = 0
        stop = len(data)
        gap = 20
        cutPosition=[]
        for s in range(0,stop,gap):
            if s==0 or s==stop-1:
                continue
            cutPosition.append(s)
        outputfile.write("0")
        for tempCp in sorted(cutPosition):
            outputfile.write("," + str(data[tempCp][3]))
        outputfile.write("," + str(data[len(data) - 1][3]) + "," + filename + "\n")
        file.close()






