
clear all; clc; close all;
% path information
dPath_F = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507\filtered';
dPath_V1 = 'C:\Users\mat950\Documents\Data\TrainProject\Windsnelheden\Doorsnede1';
dPath_V2 = 'C:\Users\mat950\Documents\Data\TrainProject\Windsnelheden\Doorsnede2';
dStructuresFiles = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507\StructuredFiles';
SetFigureDefaults();

% Settings
Set.PlotSync = true;


% cell array with coupling between force files and measured air velocities
% at doorsnede 1 and 2

DatFiles = {'Train_6.csv','20220705_234628.tdms','20220705_234643.tdms','Train6.mat';...
    'Train_9.csv','20220706_002529.tdms','20220706_002545.tdms','Train9.mat';...
    'Train_11.csv','20220706_011917.tdms','20220706_011937.tdms','Train11.mat';...
    'Train_12.csv','20220706_012405.tdms','20220706_012419.tdms','Train12.mat';...
    'Train_13.csv','20220706_014211.tdms','20220706_014232.tdms','Train13.mat';...
    'Train_14.csv','20220706_014515.tdms','20220706_014530.tdms','Train14.mat';...
    'Train_15.csv','20220706_021034.tdms','20220706_021055.tdms','Train15.mat';...
    'Train_16.csv','20220706_021438.tdms','20220706_021455.tdms','Train16.mat';...
    'Train_17.csv','20220706_023426.tdms','20220706_023444.tdms','Train17.mat';...
    'Train_18.csv','20220706_023753.tdms','20220706_023808.tdms','Train18.mat';...
    'Train_19.csv','20220706_030345.tdms','20220706_030404.tdms','Train19.mat';...
    'Train_20.csv','20220706_030700.tdms','20220706_030719.tdms','Train20.mat';...
    'Train_21.csv','20220706_032410.tdms','20220706_032431.tdms','Train21.mat';...
    'Train_22.csv','20220706_032942.tdms','20220706_033002.tdms','Train22.mat'};
nTrains = length(DatFiles(:,1));

RegDat1 = [];
RegDat2 = [];
InfoTrain = {};
for i=1:nTrains
    % get combined data -- doorsnede 1
    filename_v_tdms = DatFiles{i,2};
    filename_F = DatFiles{i,1};
    [t1,data_F1,data_V1,headers1] = CombineData_F_V(fullfile(dPath_V1,filename_v_tdms),...
        fullfile(dPath_F,filename_F));
    % get combined data -- doorsnede 2
    filename_v_tdms = DatFiles{i,3};
    filename_F = DatFiles{i,1};
    [t2,data_F2,data_V2,headers2] = CombineData_F_V(fullfile(dPath_V2,filename_v_tdms),...
        fullfile(dPath_F,filename_F));
    % plot figure with sync data
    if Set.PlotSync
        figure();
        nr = 1;
        nc = 3;
        subplot(nr,nc,1);
        plot(t1,abs(data_F1)); hold on;
        plot(t1,nanmean(data_V1,2).^2);
        subplot(nr,nc,2);
        plot(t2,abs(data_F2)); hold on;
        plot(t2,nanmean(data_V2,2).^2);
        for j=1:nr*nc
            subplot(nr,nc,j);
            set(gca,'box','off');
        end
    end
    % get train info
    load(fullfile(dStructuresFiles,DatFiles{i,4}),'Info');
    % store data in a large table
    F1 = abs(data_F1);
    F2 = abs(data_F2);
    V1 = nanmean(data_V1,2);
    V2 = nanmean(data_V2,2);
    % remove nans
    iDel = isnan(F1') | isnan(V1) | F1'>100;
    F1(iDel) = [];
    V1(iDel) = [];
    t1(iDel) = [];
    nfr1= length(F1);
    iDel = isnan(F2') | isnan(V2) | F2'>100;
    F2(iDel) = [];
    V2(iDel) = [];
    t2(iDel) = [];
    nfr2 = length(F2);
    % remove
    RegDat1 = [RegDat1;t1' F1' V1 ones(nfr1,1)*i];
    RegDat2 = [RegDat2;t2' F2' V2 ones(nfr2,1)*i];
    InfoTrain{i} = [Info.type ' : ' Info.richting ' : ' num2str(Info.snelheid) ' km/h'];
    InfoAll{i} = Info;
end

%% Regression model on all data

% doorsnede 1:
F = RegDat1(:,2);
V = RegDat1(:,3);
Doorsnede1.all = LinearRegression(F,V);
for i=1:nTrains
    iSel = RegDat1(:,4) == i;
    F = RegDat1(iSel,2);
    V = RegDat1(iSel,3);
    Doorsnede1.train(i) = LinearRegression(F,V);
end
% doorsnede 2:
F = RegDat2(:,2);
V = RegDat2(:,3);
Doorsnede2.all = LinearRegression(F,V);
for i=1:nTrains
    iSel = RegDat2(:,4) == i;
    F = RegDat2(iSel,2);
    V = RegDat2(iSel,3);
    Doorsnede2.train(i) = LinearRegression(F,V);
end


figure('Color',[1 1 1], 'Name','doorsnede 1');
nr = 3;
nc = 5;
for i=1:nTrains
    % doorsnede 1
    subplot(nr,nc,i)
    iSel = RegDat1(:,4) == i;
    F = RegDat1(iSel,2);
    V = RegDat1(iSel,3);
    t = RegDat1(iSel,1);
    plot(t,F,'k'); hold on;
    plot(t,Doorsnede1.all.F_recon(iSel),'b');
    plot(t,Doorsnede1.train(i).F_recon,'r');
    title({InfoTrain{i},['Rsq-all: ' num2str(round(Doorsnede1.all.Rsq,2)) ,...
        '  Rsq-train: ' num2str(round(Doorsnede1.train(i).Rsq,2))]});
end

for i=1:nr*nc
    subplot(nr,nc,i);
    if rem(i,nc) == 1
        ylabel('Force [N]');
    end
    if i >((nr-1)*nc)
        xlabel('time [s]');
    end
    set(gca,'box','off');
end

figure('Color',[1 1 1], 'Name','doorsnede 1');
nr = 3;
nc = 5;
for i=1:nTrains
    % doorsnede 2
    subplot(nr,nc,i)
    iSel = RegDat2(:,4) == i;
    F = RegDat2(iSel,2);
    V = RegDat2(iSel,3);
    t = RegDat2(iSel,1);
    plot(t,F,'k'); hold on;
    plot(t,Doorsnede2.all.F_recon(iSel),'b');
    plot(t,Doorsnede2.train(i).F_recon,'r');
    title({InfoTrain{i},['Rsq-all: ' num2str(round(Doorsnede2.all.Rsq,2)) ,...
        '  Rsq-train: ' num2str(round(Doorsnede2.train(i).Rsq,2))]});
end

for i=1:nr*nc
    subplot(nr,nc,i);
    if rem(i,nc) == 1
        ylabel('Force [N]');
    end
    if i >((nr-1)*nc)
        xlabel('time [s]');
    end
    set(gca,'box','off');
end

%% compute linear impulse of the external force

impulseF = nan(nTrains,3);
TrainType = {'ICD','ICNG','Other'};

for i=1:nTrains
    % get external force of this train
    isel = find(RegDat1(:,4) == i & RegDat1(:,1)>28 & RegDat1(:,1)<40);
    F = RegDat1(isel,2);
    t = RegDat1(isel,1);
    impulseF(i,1) = trapz(t,F);

    % get impulse based on model air velocity
    itrain = find(RegDat1(:,4) == i);
    ttrain = RegDat1(itrain,1);
    isel = ttrain>28 & ttrain<40;
    F2 = Doorsnede1.train(i).F_recon(isel);
    impulseF(i,2) = trapz(t,F2);

    % store info train and index for plotting
    Info = InfoAll{i};
    if strcmp(Info.type,TrainType{1}) & Info.snelheid<150
        icond = 1;
    elseif strcmp(Info.type,TrainType{1}) & Info.snelheid>150
        icond = 2;
    elseif strcmp(Info.type,TrainType{2}) & Info.snelheid<150
        icond = 3;
    elseif strcmp(Info.type,TrainType{2}) & Info.snelheid>150
        icond = 4;
    else
        icond = NaN;
    end
    if strcmp(Info.richting,'Dron - Zl')
        icond = icond + 4;
    end
    impulseF(i,3) = icond;
end

figure('Color',[1 1 1], 'Name','Impulse doorsnede 1');
speedticklabel = {'140 km/h', '160 km/h','140 km/h', '160 km/h'};
for i =1:2
    subplot(2,2,i*2-1)
    isel = impulseF(:,3) == 1;
    PlotBar(1,impulseF(isel,i));
    isel = impulseF(:,3) == 2;
    PlotBar(2,impulseF(isel,i));

    isel = impulseF(:,3) == 1+4;
    PlotBar(4,impulseF(isel,i));
    isel = impulseF(:,3) == 2+4;
    PlotBar(5,impulseF(isel,i));
    title(TrainType{1})
    set(gca,'box','off');
    ylabel('impulse (Ns)');
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
    set(gca,'YLim',[0  300])

    subplot(2,2,i*2)
    isel = impulseF(:,3) == 3;
    PlotBar(1,impulseF(isel,i));
    isel = impulseF(:,3) == 4;
    PlotBar(2,impulseF(isel,i));
    isel = impulseF(:,3) == 3+4;
    PlotBar(4,impulseF(isel,i));
    isel = impulseF(:,3) == 4+4;
    PlotBar(5,impulseF(isel,i));
    set(gca,'box','off');
    title(TrainType{2})
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
    set(gca,'YLim',[0  300])

end

%% compute max impulse in 0.5 s time window

impulseF_max = impulseF;
TrainType = {'ICD','ICNG','Other'};
time_window = 0.5;

for i=1:nTrains
    % get external force of this train
    isel = find(RegDat1(:,4) == i & RegDat1(:,1)>28 & RegDat1(:,1)<40);
    F = RegDat1(isel,2);
    t = RegDat1(isel,1);
    dt = nanmean(diff(t));
    x = cumsum(F)*dt;
    n = round(time_window/dt);
    % Loop through the vector with 50 indices apart
    max_diff = 0;
    for j = 1:length(x)-n
        difft = abs(x(j+n) - x(j));  % Calculate the absolute difference
        if difft > max_diff
            max_diff = difft;  % Update max_diff if a larger difference is found
        end
    end
    impulseF_max(i,1) = max_diff;

    % get impulse based on model air velocity
    itrain = find(RegDat1(:,4) == i);
    ttrain = RegDat1(itrain,1);
    isel = ttrain>28 & ttrain<40;
    F2 = Doorsnede1.train(i).F_recon(isel);
    x = cumsum(F2)*dt;
    max_diff = 0;
    for j = 1:length(x)-n
        difft = abs(x(j+n) - x(j));  % Calculate the absolute difference
        if difft > max_diff
            max_diff = difft;  % Update max_diff if a larger difference is found
        end
    end
    impulseF_max(i,2) = max_diff;

end

figure('Color',[1 1 1], 'Name','Impulse doorsnede 1');
speedticklabel = {'140 km/h', '160 km/h','140 km/h', '160 km/h'};
for i =1:2
    subplot(2,2,i*2-1)
    isel = impulseF_max(:,3) == 1;
    PlotBar(1,impulseF_max(isel,i));
    isel = impulseF_max(:,3) == 2;
    PlotBar(2,impulseF_max(isel,i));

    isel = impulseF_max(:,3) == 1+4;
    PlotBar(4,impulseF_max(isel,i));
    isel = impulseF_max(:,3) == 2+4;
    PlotBar(5,impulseF_max(isel,i));
    title(TrainType{1})
    set(gca,'box','off');
    ylabel('impulse (Ns)');
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
    set(gca,'YLim',[0  40])

    subplot(2,2,i*2)
    isel = impulseF_max(:,3) == 3;
    PlotBar(1,impulseF_max(isel,i));
    isel = impulseF_max(:,3) == 4;
    PlotBar(2,impulseF_max(isel,i));
    isel = impulseF_max(:,3) == 3+4;
    PlotBar(4,impulseF_max(isel,i));
    isel = impulseF_max(:,3) == 4+4;
    PlotBar(5,impulseF_max(isel,i));
    set(gca,'box','off');
    title(TrainType{2})
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
    set(gca,'YLim',[0  40])

end

%% save information as a matfile
save(fullfile(pwd,'model_luchtwrijving.mat'),'Doorsnede1','Doorsnede2')

% Doorsnede1.stats = regstats(F,V.^2,'linear');
% Doorsnede1.Rsq = stats.rsquare; % Rsquared values for this measurement.
% Doorsnede1.A = stats.beta(2);
% Doorsnede1.F_recon = A.* V.^2;


% doorsnede 2:







% F = abs(data_F);
% V = nanmean(data_V,2);
%
% stats = regstats(F,V.^2,'linear');
% Rsq = stats.rsquare; % Rsquared values for this measurement.
% A = stats.beta(2);
% F_recon = A.* V.^2;

%% plot figure
% figure();
% nr = 1;
% nc = 3;
% subplot(nr,nc,1)
% plot(t,F); hold on;
% plot(t,F_recon); hold on;
% title(['Rsq ' num2str(Rsq)]);
% legend('F','F-model');
% xlabel('time [s]');
% ylabel('Force [N]');
% subplot(nr,nc,2)
% plot(t,data_F);
% xlabel('time [s]');
% ylabel('Force [N]');
% title(['Constant ' num2str(A)]);
% subplot(nr,nc,3)
% plot(t,data_V); hold on;
% plot(t,nanmean(data_V,2),'k');
% legend(headers,'interpreter','none');
% xlabel('time [s]');
% ylabel('velocity (m/s)');
% %
% for i=1:nr*nc
%     subplot(nr,nc,i);
%     set(gca,'box','off');
% end
%




