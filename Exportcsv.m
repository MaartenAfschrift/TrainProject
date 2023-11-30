%% Export.csv files with all information
clear all; close all; clc;
% load a specific train
Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
OutPathData = fullfile(Set.DatFolder, 'AllData');
mkdir(OutPathData);
Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;
nTrains = 22;
titleVect = cell(0);
for iTrain = 1:nTrains

    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));

    % filter train data
    [a,b] = butter(Set.Filter.Order,Set.Filter.Cutoff/(2000*0.5),'low');
    F = filtfilt(a,b,FP.F);
    M = filtfilt(a,b,FP.M);
    F_raw = FP.F;
    M_raw = FP.M;

    M0 = nanmean(M(1:10000,:));
    F0 = nanmean(F(1:10000,:));

    M = M-M0;
    F = F-F0;

    % compute COP position
    iSel = abs(F(:,2))>50;

    t = FP.t-FP.t(1);
    COPy = zeros(size(t)); % wooden plate is mounted at COPy = 0
    COPz = (COPy.*F(:,3)-M(:,1))./F(:,2);
    COPz(abs(F(:,2))<20) = NaN; %  only compute COP when horizonal forces exceeds treshold
    % COPx= (-M(:,2)+COPz.*F(:,1))./F(:,3);
    % COPx(abs(F(:,2))<40) = NaN; %  only compute COP when horizonal forces exceeds treshold
    COPx = zeros(size(t)); % wooden plate is mounted at COPy = 0
    COP = [COPx COPy COPz];


    % get the title for this train
    if isfield(FP,'Info')
        titleSel = ['Train ', num2str(iTrain) '; ' FP.Info.type '; ' num2str(FP.Info.snelheid),...
            'km/h; richting ' FP.Info.richting '; tijdstip ', datestr(FP.Info.tijdstip),...
            ' ;  id1 ' FP.Info.id1{1} ' ;  id2 ' num2str(FP.Info.id2)  ];
    else
        titleSel = 'TrainUnknown';
    end
    titleVect{iTrain} = titleSel;

    %% export train info
    % export to csv file
    DatCSV = [t F_raw M_raw F COP];
    HeaderCSV  = {'t', 'Fx', 'Fy', 'Fz', 'Mx', 'My','Mz',...
        'Fx_filt', 'Fy_filt', 'Fz_filt', 'COPx', 'COPy','COPz'};

    T = array2table(DatCSV,'VariableNames',HeaderCSV);
    OutPathCSV = fullfile(OutPathData,['Train_' num2str(iTrain) '.csv']);
    writetable(T,OutPathCSV);
end


DatCSV = titleVect';
HeaderCSV  = {'InfoTrain'};
T = array2table(DatCSV,'VariableNames',HeaderCSV);
OutPathCSV = fullfile(OutPathData,'InfoTrain.csv');
writetable(T,OutPathCSV);