

import pandas as pd
import matplotlib.pyplot as plt


# path information
input_dir_v = 'C:/Users/mat950/Documents/Data/TrainProject/Windsnelheden/Doorsnede1/'
input_dir_F = 'C:/Users/mat950/Documents/Data/TrainProject/Train_20220507/StructuredFiles/'

# read the velocity measurements
filename_v = '20220706_011917.csv'
df_v = pd.read_csv(input_dir_v + filename_v, low_memory=False)

# read the force measurement
filename_F = 'Train11.mat'
