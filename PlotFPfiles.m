%% Filter the data on the train

% load a specific train
Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;

%% Figure 1
lw = 1;
Cs = [0.2 0.2 1];

figure();
for iTrain = 1:22

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

    % filter train data
    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);

    % compute COP position
    t = FP.t-FP.t(1);
    COPy = 0;
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPx= (M(:,2)+COPz.*F(:,1))./F(:,3);

    % plot the force and moment
    subplot(1,2,1)
    plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;

    subplot(1,2,2)
    plot(t,M(:,1),'LineWidth',lw,'Color',Cs); hold on;


end

subplot(1,2,1)
set(gca,'XLim',[25 25+20]);
set(gca,'YLim',[-200 200]);
xlabel('Time [s]')
ylabel('Force [N]')

subplot(1,2,2)
set(gca,'XLim',[25 25+20]);
set(gca,'YLim',[-200 200]);
xlabel('Time [s]')
ylabel('Moment [Nm]')


%% Figure 2
lw = 1;
Cs = [0.2 0.2 1];

figure('Name','Force');
for iTrain = 1:22

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

    % filter train data
    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);


    % compute COP position
    t = FP.t-FP.t(1);
    COPy = 0;
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPx= (M(:,2)+COPz.*F(:,1))./F(:,3);

    % plot the force and moment
    subplot(3,8,iTrain)
    plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
    set(gca,'XLim',[20 25+30]);
    set(gca,'YLim',[-200 200]);
    set(gca,'Box','off');

    % get the title for this train
    if isfield(FP,'Info');
        titleSel = [FP.Info.type '; ' num2str(FP.Info.snelheid) 'km/h' ];
    else
        titleSel = 'TrainUnknown';
    end
    title(titleSel);
end

%% Figure 2 - moment
lw = 1;
Cs = [0.2 0.2 1];

figure('Name','Moment');
for iTrain = 1:22

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

    % filter train data
    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);


    % compute COP position
    t = FP.t-FP.t(1);
    COPy = 0;
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPx= (M(:,2)+COPz.*F(:,1))./F(:,3);

    COPz(abs(F(:,2))<30) = NaN;

    % plot the force and moment
    subplot(3,8,iTrain)
    plot(t,COPz,'LineWidth',lw,'Color',Cs); hold on;
    set(gca,'XLim',[20 25+30]);
%     
    set(gca,'Box','off')

    % get the title for this train
    if isfield(FP,'Info');
        titleSel = [FP.Info.type '; ' num2str(FP.Info.snelheid) 'km/h' ];
    else
        titleSel = 'TrainUnknown';
    end
    title(titleSel);
end
% subplot(1,2,1)
% set(gca,'XLim',[25 25+20]);
% set(gca,'YLim',[-100 100]);
% % xlabel('Time [s]')
% % ylabel('Force [N]')

%% plot overview figure for each train

CSlow = [0 0 1];
CFast = [1 0 0];

TrainType = {'ICD','ICNG','Other'};
figure('Name','Force Type');

for iTrain = 1:22

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

    % filter train data
    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);
    t = FP.t-FP.t(1);


    if isfield(FP,'Info')
        if strcmp(FP.Info.type,TrainType{1});
            iPlot = 1;
            titsel = TrainType{1};
        elseif strcmp(FP.Info.type,TrainType{2});
            iPlot = 2;
            titsel = TrainType{2};
        else
            iPlot = 3;
            titsel = 'uknown';
        end
        if FP.Info.snelheid<150
            Cs = CSlow;
        else
            Cs = CFast;
        end
        subplot(3,3,iPlot)
        plot(t,F(:,1),'LineWidth',lw,'Color',Cs); hold on;
        title(titsel);
        subplot(3,3,iPlot+3)
        plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
        subplot(3,3,iPlot+6)
        plot(t,F(:,3),'LineWidth',lw,'Color',Cs); hold on;
    end
end

for i=1:9
    subplot(3,3,i)
    set(gca,'XLim',[20 25+30]);
    set(gca,'YLim',[-200 250]);
    set(gca,'Box','off');
    if i<4
        ylabel('Force X [N]');
    elseif i<7
        ylabel('Force Y [N]');
    else
        ylabel('Force Z [N]');
    end
    xlabel('Time [s]');
end

%% Detailed figure for presentation


lw = 1.7;
CSlow = [0 0 1];
CFast = [1 0 0];

TrainType = {'ICD','ICNG','Other'};
figure('Name','Force Type');

for iTrain = 1:22

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

    % filter train data
    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);
    t = FP.t-FP.t(1);


    if isfield(FP,'Info')
        if strcmp(FP.Info.type,TrainType{1});
            iPlot = 1;
            titsel = TrainType{1};
        elseif strcmp(FP.Info.type,TrainType{2});
            iPlot = 2;
            titsel = TrainType{2};
        else
            iPlot = 3;
            titsel = 'uknown';
        end
        if FP.Info.snelheid<150
            Cs = CSlow;
        else
            Cs = CFast;
        end
        if iPlot<3
            subplot(1,2,iPlot)
            l = plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
            if FP.Info.snelheid<150 && iPlot == 1
                il(1) = l;
            elseif FP.Info.snelheid>150 && iPlot == 1
                il(2) = l;
            end
        end
    end
end

for i=1:2
    subplot(1,2,i)
    set(gca,'XLim',[25 25+20]);
    set(gca,'YLim',[-200 250]);
    set(gca,'Box','off');
    ylabel('Force - y [N]');
    xlabel('Time [s]');
    set(gca,'FontSize',10);
    set(gca,'LineWidth',1.3);
end
legend(il,{'140km/h', '160 km/h'});

%% aangrijpingspunt kracht



