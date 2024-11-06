%% Kinematic analysis data
%--------------------------


% datapath 
datapath = 'C:\Users\mat950\Documents\Data\TrainProject\Xsens\train20220705\export2';

% path to a specific datafile
stepdatafile = 'TestSession-014.mvnx';
swaydatafile = 'TestSession-017.mvnx';
% stepdatafile = 'TestSession2-005.mvnx';

% load data
stepdat = load_mvnx(fullfile(datapath,stepdatafile));

% postural sway
swaydat = load_mvnx(fullfile(datapath,swaydatafile));


%% plot some data stepping response

segnames = {stepdat.segmentData().label};
FootL = stepdat.segmentData(strcmp(segnames,'LeftLowerLeg'));
FootR = stepdat.segmentData(strcmp(segnames,'RightLowerLeg'));
Pelvis = stepdat.segmentData(strcmp(segnames,'Pelvis')); 
sf = str2double(stepdat.metaData.subject_frameRate);
t = (1:length(FootL.position))./sf;

SetFigureDefaults();
figure();
for i =1:3
    subplot(1,3,i)
    plot(t,FootL.position(:,i)); hold on;
    plot(t,FootR.position(:,i)); hold on;
    plot(t,Pelvis.position(:,i));
    % set(gca,'XLim',[4 14]);
end
legend('FootL','FootR','Pelvis');

figure();
plot(t,FootL.position(:,2)); hold on;
plot(t,FootR.position(:,2)+0.05); hold on; % offset
plot(t,Pelvis.position(:,2));
set(gca,'XLim',[4 14]);
legend('FootL','FootR','Pelvis');
xlabel('time [s]');
ylabel('position parallel to track [m]');
set(gca,'box','off');

%% Plot postural sway data


segnames = {swaydat.segmentData().label};
FootL = swaydat.segmentData(strcmp(segnames,'LeftLowerLeg'));
FootR = swaydat.segmentData(strcmp(segnames,'RightLowerLeg'));
Pelvis = swaydat.segmentData(strcmp(segnames,'Pelvis')); 

% compute angle between between pelvis and foot around x axis
dr = Pelvis.position- FootR.position;
fi = atan2(dr(:,3),dr(:,2));


sf = str2double(swaydat.metaData.subject_frameRate);
t = (1:length(FootL.position))./sf;


figure();
plot(t,(fi-pi/2)*180/pi+5);
xlabel('time [s]');
ylabel('sway angle [deg]');
set(gca,'box','off');
