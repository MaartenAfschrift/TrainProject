%% Plot files by train type
%---------------------------
clear all; clc;

% % load a specific train
% Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507';
% % excel file with trains
% Set.InfoFile = fullfile(Set.DatFolder,'OverzichtPassages_edit.xlsx');
% % number of trains
% nTrains = 22;


% load a specific train
Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20230527';
% excel file with trains
Set.InfoFile = fullfile(Set.DatFolder,'OverzichtPassages_edit2.xlsx');
% % number of trains
nTrains = 13;

% start en einde dag
Set.Dag1 = datetime('27-May-2023 00:00:00');
Set.Dag2 = datetime('28-May-2023 00:00:00');

% settings lowpass filter
Set.Filter.Cutoff = 6;
Set.Filter.Order = 4;



%% Read excel sheet with train information
TrainInfo = readtable(Set.InfoFile);

%% Read all force information
for iTrain = 1:nTrains
    % load the datafile
    dfile = ['Train' num2str(iTrain) '.mat']; % Train20 06-Jul-2022 03:07:44
    FP{iTrain} = load(fullfile(Set.DatFolder,'StructuredFiles',dfile));
    FP{iTrain}.filename = fullfile(Set.DatFolder,'StructuredFiles',dfile);
    TimeFPfiles(iTrain) = FP{iTrain}.dateTrain;
end
% TimeFPfiles = [FP().dateTrain];

%% get FP information for each train

nTrains = length(TrainInfo.id1);

for i=1:nTrains
    % get date of this train
    t = TrainInfo.tijdstip(i);
    if t>0.5
        ts = Set.Dag1 + hours(t*24);
    else
        ts = Set.Dag2 + hours(t*24);
    end
    dtFiles = TimeFPfiles-ts;

    % get the files that matches the passage
    [MinDur,iMin] = min(abs(dtFiles));
    
    if abs(MinDur) < minutes(3)
        % get train Info
        Info.id1 = TrainInfo.id1(i);
        Info.id2 = TrainInfo.id2(i);
        Info.tijdstip = ts;
        Info.type = TrainInfo.type{i};
        Info.richting = TrainInfo.richting{i};
        Info.snelheid = TrainInfo.snelheid(i);
        % Info.afstandPP = TrainInfo.afstand(i);

        % get the FP file
        F = FP{iMin}.F;
        M = FP{iMin}.M;
        dateTrain = FP{iMin}.dateTrain;
        t = FP{iMin}.t;
        filename =  FP{iMin}.filename;

        % store the data
        save(filename,'F','M','t','dateTrain','Info');

    else
        disp(['No recodering of train at ', datestr(ts)]);
    end
end




