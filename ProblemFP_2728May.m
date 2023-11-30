%% Explore problem with FP in experiment 27-28 may 2023
%-------------------------------------------------------


clear all; close all; clc;
for itr = 1:13
    FP = load(['C:\Users\mat950\Documents\Data\TrainProject\Train_20230527\StructuredFiles\Train' num2str(itr) '.mat']);
    Set.Filter.Cutoff = 6;
    Set.Filter.Order = 4;

    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);
    t = FP.t-FP.t(1);
    M0 = nanmean(M(1:10000,:));
    F0 = nanmean(F(1:10000,:));
    M = M-M0;
    F = F-F0;

    % The FP tilts sometimes when the train passes by. The only thing we
    % can do is assume that the first gust of wind changed the orientation
    % of the platform. so we zero level using the final values.
    i0 = find(t==30);
    F_end = nanmean(F(end-4000:end,:));
    M_end = nanmean(M(end-4000:end,:));
    F(i0:end,:) = F(i0:end,:) - F_end;
    M(i0:end,:) = M(i0:end,:) - M_end;


    figure();
    subplot(1,2,1)
    plot(t,F); legend('x','y','z'); ylabel('Force'); xlabel('time');
    subplot(1,2,2)
    plot(t,M); legend('x','y','z'); ylabel('Moment'); xlabel('time');
end

DF = nanmean(F(end-2000:end,:)) - nanmean(F(1:2000,:));
DM = nanmean(M(end-2000:end,:)) - nanmean(M(1:2000,:));
F_abs = 100*9.81;
fi = asin(DF(:,2)/F_abs);

