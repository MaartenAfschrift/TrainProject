%% Structure files Exp 5 June
%-----------------------------

clear all; clc;
% settings
Set.DatFolder = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20230527';
Set.M_treshold = 20;
Set.MinGap = 60; % minimal gap between trains is 60 seconds
Set.StartExp = datetime('27-May-2023 23:00:00');

% Find all .txt files in the datafolder
DatFiles = dir(fullfile(Set.DatFolder,'*.txt'));
LogTrains = cell(0);
Trainct = 1;
% log of file structure
diaryFile = fullfile(Set.DatFolder,'StructuredFiles','TrainLog.txt');
if exist(diaryFile,'file')
    delete(diaryFile);
end
diary(diaryFile);

% matrix with information on subject position
% loop over all files
for i = 1:length(DatFiles)
    % load the file
    data=load(fullfile(DatFiles(i).folder,DatFiles(i).name));
    t0File = DatFiles(i).date; % date in seconds

    % unpack the data matrix
    D.t = data(:,1);
    D.F = data(:,2:4);
    D.M = data(:,5:7);

    % get sampling frequency
    sf = 1/nanmean(diff(D.t));

    % filter moment data for train detection
    [a,b] = butter(4,2/(sf*0.5),'low');
    M_filt = filtfilt(a,b,D.M );

    % Bandpass filter
    order = 2;
    cutoff = [0.001 2];
    [b, a] = butter(order/2, cutoff/(0.5*sf),'bandpass');
    M_filt2 = filtfilt(b, a, D.M );

    % detect trains in this file
    iPert = abs(M_filt2(:,1))>Set.M_treshold; % find frames above treshold
    t_above = D.t(iPert);
    t_above = [-Set.MinGap; t_above];
    % minimal gap between frames that exceed treshold should be longer then Set.MinGap
    iTrain = find(diff(t_above) > Set.MinGap); 
    tTrain = t_above(iTrain+1); 

    % duration of file
    dtFile = seconds(D.t(end));
     
    for it = 1:length(tTrain)
        % get the start time of this train  
        tPassage = (DatFiles(i).date - Set.StartExp) -dtFile + seconds(tTrain(it));
        dateTrain = Set.StartExp + tPassage;
        NameTrain = ['Train' num2str(Trainct)];
        LogTrains{Trainct} = [NameTrain ' ' datestr(dateTrain)];
        
        % save matfile with time window 30 seconds before train and 60
        % seconds after train
        iSel = D.t>tTrain(it)-30 & D.t<tTrain(it)+60;
        F = D.F(iSel,:);
        M = D.M(iSel,:);
        t = D.t(iSel);
        save(fullfile(Set.DatFolder,'StructuredFiles',[NameTrain '.mat']),'F','M','t','dateTrain');

        % print to screen
        disp(LogTrains{Trainct});

        % index next train
        Trainct = Trainct+1;
    end
end
diary off;
% 
% data=load('sessie2.txt');
% t=data(:,1);
% FM=data(:,2:7);
% 
% [b,a]=butter(4,4/1000);
% FMf=filtfilt(b,a,FM);
% % plot(t,FM(:,[4]),t,FMf(:,[4]))
% plot(t,FMf(:,[2 4]))
