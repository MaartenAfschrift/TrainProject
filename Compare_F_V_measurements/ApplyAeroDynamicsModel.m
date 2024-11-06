%% compute external forces based on simple model of aerodynamics
%---------------------------------------------------------------


% load model aerodynamics
load('model_luchtwrijving.mat','Doorsnede1','Doorsnede2');

% path information
dPath_F = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507\filtered';
dPath_V1 = 'C:\Users\mat950\Documents\Data\TrainProject\Windsnelheden\Doorsnede1';
dPath_V2 = 'C:\Users\mat950\Documents\Data\TrainProject\Windsnelheden\Doorsnede2';
dStructuresFiles = 'C:\Users\mat950\Documents\Data\TrainProject\Train_20220507\StructuredFiles';

% datafiles
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

% loop over all datafiles
nfiles = length(DatFiles);
distances = {'250','305','360','415','470'};
nr = 3;
nc = 5;
figure();
DatEst = [];
for i = 1:nfiles
    % get combined data -- doorsnede 1
    filename_v_tdms = DatFiles{i,2};
    filename_F = DatFiles{i,1};
    [t1,data_F1,~,~,data_V1,headers1] = CombineData_F_V(fullfile(dPath_V1,filename_v_tdms),...
        fullfile(dPath_F,filename_F), true);
    % get combined data -- doorsnede 2
    filename_v_tdms = DatFiles{i,3};
    filename_F = DatFiles{i,1};
    [t2,data_F2,~,~,data_V2,headers2] = CombineData_F_V(fullfile(dPath_V2,filename_v_tdms),...
        fullfile(dPath_F,filename_F), true);

    % get train info
    load(fullfile(dStructuresFiles,DatFiles{i,4}),'Info');

    % compute forces based on aerodynamics model
    F_est = nan(length(t2), length(distances));
    for j =1:length(distances)
        % get cols a specific distance
        indices = find(contains(headers1, distances{j}));
        V = nanmean(data_V1(:,indices),2);
        % estimate_forces
        F = Doorsnede1.all.A(1) + Doorsnede1.all.A(2)*V.^2;
        % create output matrix
        F_est(:,j) = F;
        DatEst(i).distance(j).F_est =  F_est(:,j);
        DatEst(i).Train = Info;
        DatEst(i).distance(j).d = str2double(distances{j});
        DatEst(i).distance(j).t = t1;
    end
    subplot(nr,nc,i)
    F_measured = abs(data_F1);
    F_measured(F_measured>100) = nan;
    plot(t1,F_measured,'--k'); hold on;
    plot(t1, F_est);
    


end

% controle gedaan en fit is inderdaad identiek als bij Compare_F_V

% save the recorder air velocity
save('EstimatedForce.mat','DatEst','DatFiles','distances');



