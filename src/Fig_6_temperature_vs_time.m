function Fig_6_temperature_vs_time

addpath('common');

close all;

width = 8.89; % half page
height = width/1.333;
figure('Units','centimeters','Position',[1 10 width height],'Color','w');
sdata = load('../data/temperature_vs_time.mat');

bottommargin = 1.04;
leftmargin = 1.35;
ax = axes('Units','centimeters','Position',[leftmargin bottommargin width-leftmargin height-bottommargin],'Color', 'none','visible','off');


x = sdata.time/60;
y = sdata.temperature;
n = 12;
yf = medfilt1(y,n);
yf = yf((n+1):end);
x = x((n+1):end);

hold on;
plot(x,yf,'b-','LineWidth',1);
xlim([-1 21]);
ylim([25 26.05]);

maxx = max(x);
miny = min(yf);
maxy = max(yf);

sideaxes(ax,'south');
rangeline(0,maxx);
ticks(0:5:20);
labels(0:5:20)
labels(10,0.6,'Time {\itt} (min)');

sideaxes(ax,'west');
rangeline(miny,maxy);
ticks(25.2:0.2:25.8);
labels(25.2:0.2:25.8);
lfun = @(x) sprintf('%.1f',x);
labels(miny,[],lfun);
labels(maxy,[],lfun);
labels((miny+maxy)/2,1,'Temperature {\itT} (°C)','orientation','vertical');

if ~exist('../output', 'dir')
    mkdir('../output');
end
addpath('export_fig');
export_fig('../output/Fig_6_temperature_vs_time.png','-transparent','-r600');

rmpath('export_fig');
rmpath('common');