
clear all; close all; clc;
% path information
dPath_F = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507\filtered';
dPath_V = 'C:\Users\mat950\Documents\Data\TrainProject\Windsnelheden\Doorsnede1';
SetFigureDefaults
% filenames
% filename_F = 'Train_11.csv';
% filename_v_tdms = '20220706_011917.tdms';

filename_F = 'Train_13.csv';
filename_v_tdms = '20220706_014211.tdms';

% read the tdms file
data_V = tdmsread(fullfile(dPath_V,filename_v_tdms));
TabV = data_V{1};
sfV = 2000;
tV = linspace(0,length(TabV.Ds1_060_250_wind_v)-1,length(TabV.Ds1_060_250_wind_v))./sfV;

% read the force file
data_F = readtable(fullfile(dPath_F,filename_F));

% we have to process the raw data of the velocity sensor. Data seems to be
% the same every 200 ms (so samples at 5Hz)
% ifr = 1:400:length(tV);
% Ds1_060_250_wind_v=nan(length(ifr)-1,1);
% ts =nan(length(ifr)-1,1);
% for i=1:length(ifr)-1
%     isel = ifr(i):ifr(i+1)-1;
%     Ds1_060_250_wind_v(i) = nanmean(TabV.Ds1_060_250_wind_v(isel));
%     ts(i) = nanmean(tV(isel));
% end
% use a strong lowpass filter to interpolate everything to a proper
% frequency
[a,b] = butter(2,4./(2000*0.5),'low');
Ds1_060_250_wind_v = filtfilt(a,b,TabV.Ds1_060_250_wind_v);
[a,b] = butter(2,4./(2000*0.5),'low');
data_F.Fy_filt = filtfilt(a,b,data_F.Fy);

figure();
nr = 2;
nc = 3;
subplot(nr,nc,1);
plot(tV,TabV.Ds1_060_250_wind_v); hold on;
plot(tV,Ds1_060_250_wind_v); hold on;
subplot(nr,nc,2);
plot(data_F.t,data_F.Fy); hold on;
plot(data_F.t,data_F.Fy_filt); hold on;


% autocorrelate
dsel = find(data_F.t>25 & data_F.t<35);
[r, lags] = xcorr(abs(data_F.Fy(dsel)),Ds1_060_250_wind_v.^2);
[rmax,imax]= max(r);
isel = lags(imax);
dt = data_F.t(dsel(1)) + round(isel./2000);
tV = tV+dt;
% subtract start wind velocity
nfr = length(Ds1_060_250_wind_v);
Ds1_060_250_wind_v = Ds1_060_250_wind_v - nanmean(Ds1_060_250_wind_v(1:round(nfr/20)));

% plot figure
subplot(nr,nc,3);
plot(data_F.t,data_F.Fy) ; hold on;
plot(tV ,Ds1_060_250_wind_v);
legend('F','V');

% fit model
% we assume a very simple model for aerodynamics
%   F = C v^2 (C combines density, frontal area and a drag coefficient )

%       - data with some information

% downsample signal (relevant because we filter everything at 5Hz
t_new = 25:0.01:55;
iDel = diff(data_F.t) == 0;
data_F(iDel,:) = [];


dselF = interp1(data_F.t,data_F.Fy_filt,t_new);
dselV = interp1(tV,Ds1_060_250_wind_v,t_new);

mk = 3;
subplot(nr,nc,4);
Cs = [0.2 0.2 0.8];
plot(abs(dselF),dselV,'o','MarkerFaceColor',Cs,...
    'Color',Cs,'MarkerSize',mk);
stats = regstats(abs(dselF),dselV.^2,'linear');
Rsq = stats.rsquare; % Rsquared values for this measurement.
title(['Rsq ' num2str(Rsq)]);
xlabel('F');
ylabel('v2');

A = stats.beta(2);
F_recon = A.* dselV.^2;

subplot(nr,nc,5);
plot(t_new,abs(dselF)); hold on;
plot(t_new,F_recon); hold on;
legend('F','F-model');
xlabel('time [s]');
ylabel('Force [N]');

for i=1:nr*nc
    subplot(nr,nc,i);
    set(gca,'box','off');
end





