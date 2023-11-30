function [] = PlotBar(x,y,varargin)
%PlotBar Adds a bar to the current figure and show individual datapoints
%
%	INPUT:
%		(1) x: x-coordinate for bar (double)
%		(2) y: vector with y-values for bar
%		(3) varargin: variable input arguments:
%			(3.1) Cs: RGB code for color
%			(3.2) mk: size Markers
%			(3.3) h: figure handle

% test number of input arguments x
[nr, nc] =  size(x);

% default properties
Cols = [0.6 0.6 0.6]; % default color
Cols = repmat(Cols,1,nc);
mk = 3; % default marker size

% Input color
if ~isempty(varargin)
    Cols = varargin{1};
end
if length(varargin)>1
    mk = varargin{2};
end

if length(varargin)>2
    h = varargin{3};
    figure(h);
end

% pre allocatie vector plot xlocation values
dx_mat = nan(size(y));

% loop over columns with datapoints
for i=1:nc
    %% Plot bar with average of individual datapoints
    Cs = Cols(i,:);
    b = bar(x(:,i),nanmean(y(:,i))); hold on;
    b.FaceColor = Cs; b.EdgeColor = Cs;

    % plot individual datapoints on top
    n = length(y);
    xrange = 0.2;
    dx = (1:n)./n.*xrange - 0.5*xrange + x(:,i);
    plot(dx,y(:,i),'o','MarkerFaceColor',Cs,'Color',[0.2 0.2 0.2],'MarkerSize',mk);
    dx_mat(:,i) = dx;
end

% plot line
% line(dx_mat', y','Color',[0.5 0.5 0.5]);




end

