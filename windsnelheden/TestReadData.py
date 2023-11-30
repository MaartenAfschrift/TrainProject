# Test reading data
from nptdms import TdmsFile
import pandas as pd
import matplotlib.pyplot as plt


from nptdms import TdmsFile
import glob
import re

# Update paths below to directory with tdms files (input_dir) and directory for csv outputs (output_dir)
input_dir = 'C:/Users/mat950/Documents/Data/TrainProject/Windsnelheden/Doorsnede1/'

for filename in glob.iglob(input_dir+'*.tdms'): #update filepath to location with .tdms files from LabView
    tdms_file = TdmsFile(filename)
    temp = tdms_file.as_dataframe(time_index=False, absolute_time=False)
    temp.to_csv(path_or_buf=(filename[0:-5]+".csv"), encoding='utf-8')


#datapath = 'C:/Users/mat950/Documents/Data/TrainProject/Windsnelheden'
#datafile = datapath + '/Doorsnede1/' + '20220705_234628.tdms'
#tdms_file = TdmsFile("20220705_234628.tdms")

# export to csv files
#dat = tdms_file.group_channels('Data')
#ndat = len(dat)
#headers = []
#data = []
#for i in dat:
#    headers.append(i.channel)
#    data.append(i.data)
#df = pd.DataFrame(data)

#plt.figure()
#plt.plot(d.data)



print('test')