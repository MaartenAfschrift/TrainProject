%% analyse stepping
%------------------

tab = readtable("Analyse_stap proefpersonen.xlsx");
%%
istep = find(strcmp(tab.Wel_geenStap,'Wel'));
inostep = find(strcmp(tab.Wel_geenStap,'Geen'));

trains = {'ICD','ICNG'};
direction = {'Zl - Dron', 'Dron - Zl'};
speed = [140, 160];

figure();
speedticklabel = {'140 km/h', '160 km/h','140 km/h', '160 km/h'};

for i = 1 :length(trains)
    subplot(1,2,i)
    for j = 1:length(direction)
        for k = 1:length(speed)
            istep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                strcmp(tab.Wel_geenStap,'Wel');
            inostep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                strcmp(tab.Wel_geenStap,'Geen');

            ix = (j-1)*3+k;
            b = bar(ix,sum(istep)./(sum(istep + inostep))*100); hold on;
            b.FaceColor = [0.6 0.6 0.6];
        end
    end
    set(gca,'box','off');
    set(gca,'YLim',[0 20])
    if i == 1
        ylabel('% stepping');
    end
    title(trains{i})
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
end



figure();
speedticklabel = {'140 km/h', '160 km/h','140 km/h', '160 km/h'};

for i = 1 :length(trains)
    subplot(1,2,i)
    for j = 1:length(direction)
        for k = 1:length(speed)
            istep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                tab.AfstandPerron_m_ < 1.6 & ...
                strcmp(tab.StapositiePPN_Loodrecht_ParallelAanSpoor,'loodrecht') &...
                strcmp(tab.Wel_geenStap,'Wel');
            inostep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                strcmp(tab.StapositiePPN_Loodrecht_ParallelAanSpoor,'loodrecht') &...
                tab.AfstandPerron_m_ < 1.6 & ...
                strcmp(tab.Wel_geenStap,'Geen');

            ix = (j-1)*3+k;
            b = bar(ix,sum(istep)./(sum(istep + inostep))*100); hold on;
            b.FaceColor = [0.6 0.6 0.6];
        end
    end
    set(gca,'box','off');
    set(gca,'YLim',[0 20])
    if i == 1
        ylabel('% stepping');
    end
    title(trains{i})
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
end



%% +50 years old invividuals

figure();
speedticklabel = {'140 km/h', '160 km/h','140 km/h', '160 km/h'};

for i = 1 :length(trains)
    subplot(1,2,i)
    for j = 1:length(direction)
        for k = 1:length(speed)
            istep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                tab.Leeftijd >50 & ...
                strcmp(tab.Wel_geenStap,'Wel');
            inostep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                tab.Leeftijd >50 & ...
                strcmp(tab.Wel_geenStap,'Geen');

            ix = (j-1)*3+k;
            b = bar(ix,sum(istep)./(sum(istep + inostep))*100); hold on;
            b.FaceColor = [0.6 0.6 0.6];
        end
    end
    set(gca,'box','off');
    set(gca,'YLim',[0 15])
    if i == 1
        ylabel('% stepping');
    end
    title(trains{i})
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
end

%% below 60 kg individuals

figure();
speedticklabel = {'140 km/h', '160 km/h','140 km/h', '160 km/h'};

for i = 1 :length(trains)
    subplot(1,2,i)
    for j = 1:length(direction)
        for k = 1:length(speed)
            istep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                tab.Gewicht < 70 & ...
                strcmp(tab.Wel_geenStap,'Wel');
            inostep = strcmp(tab.Materieel,trains{i}) & ...
                strcmp(tab.Rijrichting,direction{j}) & ...
                tab.Snelheidsklasse == speed(k) & ...
                tab.Gewicht < 70 & ...
                strcmp(tab.Wel_geenStap,'Geen');

            ix = (j-1)*3+k;
            b = bar(ix,sum(istep)./(sum(istep + inostep))*100); hold on;
            b.FaceColor = [0.6 0.6 0.6];
        end
    end
    set(gca,'box','off');
    set(gca,'YLim',[0 20])
    if i == 1
        ylabel('% stepping');
    end
    title(trains{i})
    set(gca,'XTick', [1 2 4 5]);
    set(gca,'XTickLabel',speedticklabel)
end


