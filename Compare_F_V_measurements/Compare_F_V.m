
clear all; clc;
% path information
dPath_F = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507\filtered';
dPath_V = 'C:\Users\mat950\Documents\Data\TrainProject\Windsnelheden\Doorsnede1';
SetFigureDefaults
% filenames
% filename_F = 'Train_11.csv';
% filename_v_tdms = '20220706_011917.tdms';

filename_F = 'Train_13.csv';
filename_v_tdms = '20220706_014211.tdms';

% filename_F = 'Train_22.csv';
% filename_v_tdms = '20220706_032942.tdms';
% 
% filename_F = 'Train_21.csv';
% filename_v_tdms = '20220706_032410.tdms';

% get combined data
[t,data_F,data_V,headers] = CombineData_F_V(fullfile(dPath_V,filename_v_tdms),...
    fullfile(dPath_F,filename_F));

F = abs(data_F);
V = nanmean(data_V,2);

stats = regstats(F,V.^2,'linear');
Rsq = stats.rsquare; % Rsquared values for this measurement.
A = stats.beta(2);
F_recon = A.* V.^2;

%% plot figure
figure();
nr = 1;
nc = 3;
subplot(nr,nc,1)
plot(t,F); hold on;
plot(t,F_recon); hold on;
title(['Rsq ' num2str(Rsq)]);
legend('F','F-model');
xlabel('time [s]');
ylabel('Force [N]');
subplot(nr,nc,2)
plot(t,data_F);
xlabel('time [s]');
ylabel('Force [N]');
title(['Constant ' num2str(A)]);
subplot(nr,nc,3)
plot(t,data_V); hold on;
plot(t,nanmean(data_V,2),'k');
legend(headers,'interpreter','none');
xlabel('time [s]');
ylabel('velocity (m/s)');
% 
for i=1:nr*nc
    subplot(nr,nc,i);
    set(gca,'box','off');
end





