%% Filter the data on the train

% load a specific train
Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
Set.Filter.Cutoff = 4;
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
set(gca,'YLim',[-100 100]);
xlabel('Time [s]')
ylabel('Force [N]')

subplot(1,2,2)
set(gca,'XLim',[25 25+20]);
set(gca,'YLim',[-100 100]);
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
    subplot(5,5,iTrain)
    plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
    set(gca,'XLim',[20 25+30]);
    set(gca,'YLim',[-100 100]);
    set(gca,'Box','off')
    title(datestr(FP.dateTrain))
end

%% Figure 2
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

    % plot the force and moment
    subplot(5,5,iTrain)
    plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
    set(gca,'XLim',[20 25+30]);
    set(gca,'YLim',[-100 100]);
    set(gca,'Box','off')
    title(datestr(FP.dateTrain))
end
% subplot(1,2,1)
% set(gca,'XLim',[25 25+20]);
% set(gca,'YLim',[-100 100]);
% % xlabel('Time [s]')
% % ylabel('Force [N]')


