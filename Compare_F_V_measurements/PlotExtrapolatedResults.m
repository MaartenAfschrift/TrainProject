%% Plot estimated force as a function of the distance
%-----------------------------------------------------


load('EstimatedForce.mat','DatEst','DatFiles','distances');
SetFigureDefaults();

nr = 1;
nc = 4;

itrain = 12;
figure();
subplot(nr,nc,1:2)
Fimpulse = nan(1, length(distances));
distance_leg = {'2.50 m', '3.05 m', '3.60 m', '4.15 m','4.70 m'};
for i = 1:length(distances)
    plot(DatEst(itrain).distance(i).t, DatEst(itrain).distance(i).F_est);
    hold on;
    % compute impulse
    t = DatEst(itrain).distance(i).t;
    F = DatEst(itrain).distance(i).F_est;
    isel = t>28 & t<40;
    Fimpulse(i) = trapz(t(isel),F(isel));
end
set(gca,'box','off');
xlabel('time [s]');
ylabel('estimated Force [N]');
legend(distance_leg)
subplot(nr,nc,3)
for i = 1:length(distances) 
    bar(i, Fimpulse(i)); hold on;
end
set(gca,'box','off');
ylabel('estimated impulse [Ns]');
set(gca,'XTick', []);

subplot(nr,nc,4)
distance =  [2.5, 3.05, 3.6, 4.15, 4.7];
for itrain = 1:length(DatEst)
    Fimpulse = nan(1, length(distances));
    for i = 1:length(distances)
        % compute impulse
        t = DatEst(itrain).distance(i).t;
        F = DatEst(itrain).distance(i).F_est;
        isel = t>28 & t<40;
        Fimpulse(i) = trapz(t(isel),F(isel));
    end
    plot(distance, Fimpulse,'-k'); hold on;
end
xlabel('distance [m]');
ylabel('estimated impulse [Ns]');
set(gca,'box','off');