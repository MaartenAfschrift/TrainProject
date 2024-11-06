%% compute external forces based on simple model of aerodynamics
%---------------------------------------------------------------


% load model aerodynamics
load('model_luchtwrijving.mat','Doorsnede1','Doorsnede2');

% extreme cases with train
%       1M13 is ook hoog 05-06/07/2024: 3u24 ICD
%       5M7 is hoog 17/06/2023: 02:12 ICD
%       5M20 is hoog 17/06/2023:4:58 (laatste, ICD)
%-      -> datum van 5 = 17 Juni 2023

% path to datafiles
dPathV = ['C:\Users\mat950\OneDrive - Vrije Universiteit Amsterdam\'... 
    'Onderzoek\TreinProject\Windsnelheden\Doorsnede 1+2'];
filenames = {'20220706_032410.tdms',...
    '20230618_021017.tdms',...
    '20230618_045643.tdms'};
fileinfo = {'1M13','5M7','5M20'};

% loop over all datafiles
nfiles = length(filenames);
distances = {'250','305','360','415','470'};
nr = 3;
nc = 5;
figure();
DatEst = [];
for ifile = 1:nfiles
    % read the tdms file
    data_V = tdmsread(fullfile(dPathV,filenames{ifile}));
    TabV = data_V{1};
    sfV = 2000;
    % create matrix with only velocity info
    datV = [];
    headers = {};
    for i =1:length(TabV.Properties.VariableNames)
        name = TabV.Properties.VariableNames{i};
        if strcmp(name(end-1:end),'_v')
            datV = [datV, TabV.(name)];
            headers = [headers name];
        end
    end
    nfr = length(datV);
    tV = linspace(0,nfr-1,nfr)./sfV;

    % detect onset train passage
    v_abs = abs(sum(datV,2));
    istart = find(v_abs-mean(v_abs)>0,1,'first');
    tV = tV-tV(istart)+30;

    % compute forces based on aerodynamics model
    F_est = nan(length(tV), length(distances));
    for j =1:length(distances)
        % get cols a specific distance
        indices = find(contains(headers, distances{j}));
        V = nanmean(datV(:,indices),2);
        % estimate_forces
        F = Doorsnede1.all.A(1) + Doorsnede1.all.A(2)*V.^2;
        % create output matrix
        F_est(:,j) = F;
        DatEst(ifile).distance(j).F_est =  F_est(:,j);
        DatEst(ifile).distance(j).d = str2double(distances{j});
        DatEst(ifile).distance(j).t = tV;
    end
end
% save the recorder air velocity
save('EstimatedForce_extreme.mat','DatEst','filenames',...
    'distances','fileinfo');



