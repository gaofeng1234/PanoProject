# -*-conding:utf-8 -*-
import json



videoid=1
duration=1
row=0
col=0
qp=22


for i in range(0,row+1):
    print i
    for j in range(0,col+1):
        print j
        for qp in range(22,27,5):
            path = 'F:/1_1_json/'
            filepath = path + '1-2-Front_2880_1440_'+ str(i)+ '_'+str(j)+ '_'+ str(qp)+ '.json'
            outputpath = 'F:/1_1_txt/'
            f =open(filepath)
            test = json.load(f)
            startFrame = 0
            endFrame = duration
            sumSize = 0
            bitrate = []
            for t in test['frames']:
                if t['media_type'] == 'video':
                    pts = float(t['pkt_pts_time'])
                    size = float(t['pkt_size'])/ 1024

                    if pts <= endFrame and pts >= startFrame:
                        sumSize = sumSize + size
                    else:
                        sumSize = sumSize / 1
                        bitrate.append(sumSize)
                        sumSize = 0
                        startFrame = startFrame + duration
                        endFrame = endFrame + duration

            for idx in range(0, len(bitrate)):
                fobj = open(outputpath + 'duration=' + str(duration) + '_idx='+str(idx)+ '_qp='+str(qp)+ '.txt','a')
                fobj.write(str(bitrate[idx]) + '\r\n')
            fobj.close()

