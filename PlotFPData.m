%% Filter the data on the train

% load a specific train
Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
% Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20230527';
Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;

%% Detailed figure with force and COP position as a function of time
lw = 1.7;
CSlow = [0 0 1];
CFast = [1 0 0];

TrainType = {'ICD','ICNG','Other'};
figure('Name','Force and COP position');

for iTrain = 1:22

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

    % filter train data
    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);
    t = FP.t-FP.t(1);

    % subtract offset (drift during the night)
    M0 = nanmean(M(1:10000,:));
    F0 = nanmean(F(1:10000,:));
    M = M-M0;
    F = F-F0;

    % compute COPz position
    t = FP.t-FP.t(1);
    COPy = zeros(size(t)); % wooden plate is mounted at COPy = 0
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPz(abs(F(:,2))<20) = NaN; %  only compute COP when horizonal forces exceeds treshold

    if isfield(FP,'Info')
        if strcmp(FP.Info.type,TrainType{1})
            iPlot = 1;
            titsel = TrainType{1};
        elseif strcmp(FP.Info.type,TrainType{2})
            iPlot = 2;
            titsel = TrainType{2};
        else
            iPlot = 3;
            titsel = 'uknown';
        end
        if strcmp(FP.Info.richting,'Dron - Zl')
            Cs = [1 0 0];
        else
            Cs = [0 0 1];
        end
                % if FP.Info.snelheid<150
        %     Cs = CSlow;
        % else
        %     Cs = CFast;
        % end
        if iPlot<3
            subplot(2,2,iPlot)
            l = plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
            if FP.Info.snelheid<150 && iPlot == 1
                il(1) = l;
            elseif FP.Info.snelheid>150 && iPlot == 1
                il(2) = l;
            end
            subplot(2,2,iPlot+2)
            l = plot(t,-COPz,'LineWidth',lw,'Color',Cs); hold on;
            COPz_Mean = nanmean(-COPz);
            line([25 25+20],[COPz_Mean COPz_Mean],'LineWidth',lw/3,'Color',Cs);            
        end
    end
end

for i=1:4
    subplot(2,2,i)
    set(gca,'XLim',[25 25+20]);
    if i<3
        set(gca,'YLim',[-200 250]);
        ylabel('Force-y [N]');
    else
        set(gca,'YLim',[0 1.3]);
        set(gca,'YTick',0:0.2:1.2);
        ylabel('COPz [m]');
    end
    set(gca,'Box','off');    
    xlabel('Time [s]');
    set(gca,'FontSize',10);
    set(gca,'LineWidth',1.3);
end
% legend(il,{'140km/h', '160 km/h'});
legend(il,{'Dron - Zl', ' '});

%% Figure with typical raw signal and filtered output

lw = 1.5;
CSlow = [0 0 1];
CFast = [1 0 0];

figure('Name','Filtering procedure');
iTrain = 13;
dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

% filter datan
[a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
F = filtfilt(a,b,FP.F);
M = filtfilt(a,b,FP.M);
% subtract offset (drift during the night)
M0 = nanmean(M(1:10000,:));
F0 = nanmean(F(1:10000,:));
M = M-M0;
F = F-F0; 
F_raw = FP.F - F0;
M_raw = FP.M - M0;
t = FP.t-FP.t(1);
% plot data
subplot(2,1,1)
plot(t,F_raw(:,2),'Color',[0.6 0.6 0.6],'LineWidth',lw); hold on;
plot(t,F(:,2),'Color',CFast,'LineWidth',lw);
ylabel('Force-y [N]')
subplot(2,1,2)
plot(t,M_raw(:,1),'Color',[0.6 0.6 0.6],'LineWidth',lw); hold on;
plot(t,M(:,1),'Color',CFast,'LineWidth',lw);
ylabel('Moment-x [Nm]')

for i=1:2
    subplot(2,1,i)
    set(gca,'XLim',[29 40]);
    set(gca,'Box','off');
    xlabel('Time [s]');
    set(gca,'FontSize',10);
    set(gca,'LineWidth',1.3);
end
legend('Raw data','filtered data')