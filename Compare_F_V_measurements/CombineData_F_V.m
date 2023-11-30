function [t_new,dselF,dselV,headers] = CombineData_F_V(filepathV1,filepathF)
%CombineData_F_V Combines the measured forces and velocties of a trial
%   Detailed explanation goes here



% read the tdms file
data_V = tdmsread(filepathV1);
TabV = data_V{1};
sfV = 2000;
% tV = linspace(0,length(TabV.Ds1_060_250_wind_v)-1,length(TabV.Ds1_060_250_wind_v))./sfV;

% create matrix with only velocity info
datV = [];
headers = {};
for i =1:length(TabV.Properties.VariableNames)
    name = TabV.Properties.VariableNames{i};
    %if strcmp(name(end-1:end),'_v') && ~isempty(regexp(name,'_250'))
    if strcmp(name(end-1:end),'_v');
        datV = [datV, TabV.(name)];
        headers = [headers name];
    end
end
nfr = length(datV);
tV = linspace(0,nfr-1,nfr)./sfV;

% read the force file
data_F = readtable(filepathF);

% use a strong lowpass filter to interpolate
[a,b] = butter(2,4./(2000*0.5),'low');
datV_filt = filtfilt(a,b,datV);
[a,b] = butter(2,4./(2000*0.5),'low');
data_F.Fy_filt = filtfilt(a,b,data_F.Fy);

% subtract start wind velocity
nfr = length(datV_filt);
datV_filt = datV_filt - nanmean(datV_filt(1:round(nfr/20),:));


% autocorrelate
Vtemp = nanmean(datV_filt,2);
dsel = find(data_F.t>20 & data_F.t<55);
[r, lags] = xcorr(abs(data_F.Fy_filt(dsel)),Vtemp.^2);
[rmax,imax]= max(r);
isel = lags(imax);
dt = data_F.t(dsel(1)) + round(isel./2000);
tV = tV+dt;


% downsample signal (relevant because we filter everything at 5Hz
t_new = 20:0.01:55;
iDel = diff(data_F.t) == 0;
data_F(iDel,:) = [];
dselF = interp1(data_F.t,data_F.Fy_filt,t_new);
dselV = interp1(tV,datV_filt,t_new);




end