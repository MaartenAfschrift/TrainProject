%% Combine measurements with dummy for ICD train
%-----------------------------------------------
clear all;
close all;
clc;
Set.DatFolder1 = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
Set.DatFolder2 = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20230527';
Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;
ntrains1 = 13;
ntrains2 = 13;


h = figure('Color' , [1 1 1]);
lw = 1.7;
CSlow = [0 0 1];
CFast = [1 0 0];

TrainType = {'ICD','ICNG','Other'};
figure('Name','Force and COP position');

for iTrain = 1:ntrains1

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder1,'StructuredFiles',dfile));

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
        else
            iPlot = NaN;
            titsel = 'uknown';
        end
        if FP.Info.snelheid<150
            Cs = CSlow;
        else
            Cs = CFast;
        end
        if ~isnan(iPlot)
            subplot(2,3,iPlot)
            l = plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
            if FP.Info.snelheid<150 && iPlot == 1
                il(1) = l;
            elseif FP.Info.snelheid>150 && iPlot == 1
                il(2) = l;
            end
            subplot(2,3,iPlot+3)
            l = plot(t,-COPz,'LineWidth',lw,'Color',Cs); hold on;
            COPz_Mean = nanmean(-COPz);
            line([25 25+20],[COPz_Mean COPz_Mean],'LineWidth',lw/3,'Color',Cs);
        end
    end
end

for iTrain = [1:7 9:13]

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder2,'StructuredFiles',dfile));

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

    % The FP tilts sometimes when the train passes by. The only thing we
    % can do is assume that the first gust of wind changed the orientation
    % of the platform. so we zero level using the final values.
    i0 = find(t==30);
    F_end = nanmean(F(end-4000:end,:));
    M_end = nanmean(M(end-4000:end,:));
    F(i0:end,:) = F(i0:end,:) - F_end;
    M(i0:end,:) = M(i0:end,:) - M_end;

    % compute COPz position
    t = FP.t-FP.t(1);
    COPy = zeros(size(t)); % wooden plate is mounted at COPy = 0
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPz(abs(F(:,2))<35) = NaN; %  only compute COP when horizonal forces exceeds treshold

    if isfield(FP,'Info')
        if strcmp(FP.Info.type,TrainType{1}) && FP.Info.Dummy == 1
            iPlot = 1;
            titsel = 'Large dummy';
        elseif strcmp(FP.Info.type,TrainType{1}) && FP.Info.Dummy == 2
            iPlot = 2;
            titsel = TrainType{2};
        else
            iPlot = 3;
            titsel = 'Small dummy';
        end
        if FP.Info.snelheid<150
            Cs = CSlow;
        else
            Cs = CFast;
        end
        if iPlot<3
            subplot(2,3,iPlot+1)
            l = plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
            if FP.Info.snelheid<150 && iPlot == 1
                il(1) = l;
            elseif FP.Info.snelheid>150 && iPlot == 1
                il(2) = l;
            end
            subplot(2,3,iPlot+4)
            l = plot(t,-COPz,'LineWidth',lw,'Color',Cs); hold on;
            COPz_Mean = nanmean(-COPz);
            line([25 25+20],[COPz_Mean COPz_Mean],'LineWidth',lw/3,'Color',Cs);
        end
    end
end
for i=1:6
    subplot(2,3,i)
    set(gca,'XLim',[25 25+20]);
    if any(i == [1 2 3])
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

%% Plot only small dummy on day 2

Set.DatFolder1 = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
Set.DatFolder2 = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20230527';
Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;
ntrains1 = 13;
ntrains2 = 13;


h = figure('Color' , [1 1 1]);
lw = 1.7;
CSlow = [0 0 1];
CFast = [1 0 0];

TrainType = {'ICD','ICNG','Other'};


for iTrain = [1:7 9:13]

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder2,'StructuredFiles',dfile));

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

    % The FP tilts sometimes when the train passes by. The only thing we
    % can do is assume that the first gust of wind changed the orientation
    % of the platform. so we zero level using the final values.
    i0 = find(t==30);
    F_end = nanmean(F(end-4000:end,:));
    M_end = nanmean(M(end-4000:end,:));
    F(i0:end,:) = F(i0:end,:) - F_end;
    M(i0:end,:) = M(i0:end,:) - M_end;

    % compute COPz position
    t = FP.t-FP.t(1);
    COPy = zeros(size(t)); % wooden plate is mounted at COPy = 0
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPz(abs(F(:,2))<35) = NaN; %  only compute COP when horizonal forces exceeds treshold

    if isfield(FP,'Info')
        if strcmp(FP.Info.type,TrainType{1}) && FP.Info.Dummy == 2
            iPlot = 1;
            titsel = 'small dummy';
        else
            iPlot = 3;
            titsel = 'Small dummy';
        end
        if FP.Info.snelheid<150
            Cs = CSlow;
        else
            Cs = CFast;
        end
        if iPlot<3
            subplot(1,2,1)
            l = plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
            if FP.Info.snelheid<150 && iPlot == 1
                il(1) = l;
            elseif FP.Info.snelheid>150 && iPlot == 1
                il(2) = l;
            end
            subplot(1,2,2)
            l = plot(t,-COPz,'LineWidth',lw,'Color',Cs); hold on;
            COPz_Mean = nanmean(-COPz);
            line([25 25+20],[COPz_Mean COPz_Mean],'LineWidth',lw/3,'Color',Cs);
        end
    end
end
for i=1:2
    subplot(1,2,i)
    set(gca,'XLim',[25 25+20]);
    if i == 1
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


%% Plot only small dummy on day 2 only forces

Set.DatFolder1 = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
Set.DatFolder2 = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20230527';
Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;
ntrains1 = 13;
ntrains2 = 13;


h = figure('Color' , [1 1 1]);
lw = 1.7;
CSlow = [0 0 1];
CFast = [1 0 0];

TrainType = {'ICD','ICNG','Other'};


for iTrain = [1:7 9:13]

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder2,'StructuredFiles',dfile));

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

    % The FP tilts sometimes when the train passes by. The only thing we
    % can do is assume that the first gust of wind changed the orientation
    % of the platform. so we zero level using the final values.
    i0 = find(t==30);
    F_end = nanmean(F(end-4000:end,:));
    M_end = nanmean(M(end-4000:end,:));
    F(i0:end,:) = F(i0:end,:) - F_end;
    M(i0:end,:) = M(i0:end,:) - M_end;

    % compute COPz position
    t = FP.t-FP.t(1);
    COPy = zeros(size(t)); % wooden plate is mounted at COPy = 0
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPz(abs(F(:,2))<35) = NaN; %  only compute COP when horizonal forces exceeds treshold

    if isfield(FP,'Info')
        if strcmp(FP.Info.type,TrainType{1}) && FP.Info.Dummy == 2
            iPlot = 1;
            titsel = 'small dummy';
        else
            iPlot = 3;
            titsel = 'Small dummy';
        end
        if strcmp(FP.Info.richting,'Zwolle')
            Cs = [1 0 0];
        else
            Cs = [0 0 1];
        end
        if iPlot<3
            % subplot(1,2,1)
            l = plot(t,F(:,2),'LineWidth',lw,'Color',Cs); hold on;
            if FP.Info.snelheid<150 && iPlot == 1
                il(1) = l;
            elseif FP.Info.snelheid>150 && iPlot == 1
                il(2) = l;
            end
            % subplot(1,2,2)
            % l = plot(t,-COPz,'LineWidth',lw,'Color',Cs); hold on;
            % COPz_Mean = nanmean(-COPz);
            % line([25 25+20],[COPz_Mean COPz_Mean],'LineWidth',lw/3,'Color',Cs);
        end
    end
end
for i=1:2
    % subplot(1,2,i)
    set(gca,'XLim',[25 25+20]);
    % if i == 1
    set(gca,'YLim',[-200 250]);
    ylabel('Force-y [N]');
    % else
    %     set(gca,'YLim',[0 1.3]);
    %     set(gca,'YTick',0:0.2:1.2);
    %     ylabel('COPz [m]');
    % end
    set(gca,'Box','off');
    xlabel('Time [s]');
    set(gca,'FontSize',10);
    set(gca,'LineWidth',1.3);
end
% legend(il,{'140km/h', '160 km/h'});

%% compare linear impulse on large and small dummy for ICD train

Fint_small = [];
for iTrain = [1:7 9:13]

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder2,'StructuredFiles',dfile));

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

    % compute linear impulse
    isel = t>25 & t<45;
    Fint = trapz(t(isel), F(isel,2));
    if strcmp(FP.Info.type,TrainType{1}) && FP.Info.Dummy == 2
        % plot(1,Fint,'ok'); hold on;
        Fint_small = [Fint_small , Fint];
    end
end

Fint_large = [];
for iTrain = 1:22

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder1,'StructuredFiles',dfile));

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

    % compute linear impulse
    isel = t>25 & t<45;
    Fint = trapz(t(isel), F(isel,2));
    if isfield(FP,'Info')
        if strcmp(FP.Info.type,TrainType{1}) && FP.Info.snelheid>150
            % plot(1,Fint,'ok'); hold on;
            Fint_large = [Fint_large , Fint];
        end
    end
end

figure('Color',[1 1 1]);
PlotBar(1,Fint_large(Fint_large>0)'); hold on;
PlotBar(1,Fint_large(Fint_large<0)'); hold on;
PlotBar(2,Fint_small(Fint_small>0)'); hold on;
PlotBar(2,Fint_small(Fint_small<0)'); hold on;
