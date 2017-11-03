function Fig_8_blocking
close all;

addpath('common');

fsize = 10;
width = 8.89;
height = 6.68;
figure('Units','centimeters','Position',[1 10 width height],'Color','w');

leftmargin = 1.22 / width;
bottommargin = 0.68 / height;
topmargin = 0.1 / height;

mainpos = [leftmargin bottommargin 1-leftmargin 1-topmargin-bottommargin];
times = [0.05 0.28 0.78 1.32];

gap = 0.02;
sizer = (mainpos(4)-4*gap)/3;
ax1pos = [mainpos(1) mainpos(2)+gap*3+sizer*2 mainpos(3) sizer];
ax1 = axes('Position',ax1pos);

firstrow = @(x) x(1,:);
mfun = @(x,c) firstrow(reshape(x.data(:,c),x.params.n,size(x.data,1)/x.params.n));

analogTokPa = @(x) (x/1024.0 - 0.1)*100.0/0.8 * 6.89475729;

c1 = load('../data/blocking_resistance_pressure');
t1 = mfun(c1,7)/60-0.1;
p1 = analogTokPa(mfun(c1,2));
r1 = mfun(c1,1);
ind = ~isnan(r1);
t1 = t1(ind);
p1 = p1(ind);
r1 = r1(ind);
r1 = [r1(1) r1(1:(end-1))];

data1 = load('../data/blocking_curvature.mat');
data2 = load('../data/blocking_manual_curvature');
d = data1.results;
d(80:100,:) = data2.results(80:100,:); % switch to manually picked curvature data when the machine vision fails
curvature = d(:,5)  ./ d(:,4) / data1.scale * pi / 180 * 100;
tc = ((1:length(curvature))-7)/60-0.0819;

hold on;

plot(t1,p1,'b','LineWidth',1);
xlims = [-0.05 1.59];
xlim(xlims);
ylabel('{\itP} (kPa)','FontName','Arial','FontSize', fsize);
set(gca,'Color','none');
set(gca,'Visible','off');

ax2 = sideaxes(ax1,'south','units','normalized','gap',gap,'size',sizer,'orientation','north');

hold on;
plot(t1,r1,'b','LineWidth',1);
set(gca,'Color','none');
set(gca,'Visible','off');

ax3 = sideaxes(ax2,'south','units','normalized','gap',gap,'size',sizer,'orientation','north');

cc1 = interp1(tc,curvature,t1);
beta = [r1;p1;ones(size(r1))]' \ cc1';
curvature_est = beta(1) * r1 + beta(2) * p1 + beta(3);

h1 = plot(t1,curvature_est,'-','LineWidth',1,'Color',[1 0.4 0.4]);
hold on;

h2 = plot(tc,curvature,'b-','LineWidth',1);
hold off;

legend([h1 h2],{'Eq. (3)','Measurement'},'Position',[0.47 0.3 0.2 0.1],'FontSize',10,'FontName','Times New Roman');
legend boxoff;

set(gca,'Color','none');
set(gca,'Visible','off');

linkaxes([ax1 ax2],'x');
linkaxes([ax2 ax3],'x');

sideaxes(ax1,'north','gap',gap*height);
rangeline(xlims(1),xlims(2));
ticks(times,0.1);

yr1 = [0 max(p1)];
ylim(ax1,yr1);
sideaxes(ax1,'west');
ticks([0 40]);
labels(40,0.2,@(x) sprintf('%.0f',x),'FontSize',8);
labels(5,0.2,sprintf('%.0f',0),'FontSize',8);
rangeline(yr1(1),yr1(2));
labels(mean(yr1),0.75,'{\itp} (kPa)','orientation','vertical');

yr2 = [min(r1) max(r1)];
ylim(ax2,yr2);
sideaxes(ax2,'west');
rangeline(yr2(1),yr2(2));
tickx = 15.5:0.5:17;
ticks(tickx);
labels(tickx,[],[],'FontSize',8);
labels(mean(yr2),0.75,'{\itR} (\Omega)','orientation','vertical');

yr3 = [min([curvature' curvature_est]) max([curvature' curvature_est])];
ylim(ax3,yr3);

sideaxes(ax3,'west');
rangeline(yr3(1),yr3(2));
ticks(10:10:40);
labels(10:10:40,[],[],'FontSize',8);
labels(mean(yr3),0.75,'{\it\kappa} (m^{-1})','orientation','vertical');

sideaxes(ax3,'south','gap',gap*height);
rangeline(xlims(1),xlims(2));
ticks(0:0.5:1.5);
labels(0:0.5:1.5);
labels(0.76,0.2,'Time {\itt} (min)');

if ~exist('../output', 'dir')
    mkdir('../output');
end
addpath('export_fig');
export_fig('../output/Fig_8_blocking.pdf','-transparent');
rmpath('common');
rmpath('export_fig');