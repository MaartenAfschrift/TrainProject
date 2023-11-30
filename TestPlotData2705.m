%% Temporary script to plot date experiments on 27-28 may
%----------------------------------------------------------
clear all; close all; clc;

datapath = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20230527';
data=load(fullfile(datapath,"Measement04.txt"));

Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;

% unpack the data matrix
D.t = data(:,1);
D.F = data(:,2:4);
D.M = data(:,5:7);

% get sampling frequency
sf = 1/nanmean(diff(D.t));

% filter train data
[a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(sf*0.5),'low');
F = filtfilt(a,b,D.F);
M = filtfilt(a,b,D.M);
t = D.t-D.t(1);
%%
iSel = 1:50:length(t);
figure();
subplot(2,1,1)
plot(t(iSel),F(iSel,:))
subplot(2,1,2)
plot(t(iSel),M(iSel,:))