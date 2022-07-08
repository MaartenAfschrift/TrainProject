%% Pilot measurement

dPath = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
filename = 'test2.txt';

d = importdata(fullfile(dPath,filename));

t = d(:,1);
F = d(:,2:4);
M = d(:,5:7);
fs  = 1./nanmean(diff(t));

%%
figure()
[data_ft,frequency_out,magnitude_out] = make_freq_spect( F,fs,true);
figure()
[data_ft,frequency_out,magnitude_out] = make_freq_spect( M,fs,true);



%% plot results filter
[a,b] = butter(2,40/(fs*0.5),'low');
F_filt = filtfilt(a,b,F);
M_filt = filtfilt(a,b,M);


%%
figure();
for i = 1:3
    axs(i) = subplot(3,1,i);
    plot(t,F(:,i)); hold on;
    plot(t,F_filt(:,i),'--k');
end
linkaxes(axs,'x');


%%
figure();
for i = 1:3
    axs(i) = subplot(3,1,i);
    plot(t,M(:,i)); hold on;
    plot(t,M_filt(:,i),'--k');
end
linkaxes(axs,'x');