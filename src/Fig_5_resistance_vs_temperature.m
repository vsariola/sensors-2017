function Fig_5_resistance_vs_temperature

addpath('common');

close all;
fsize = 10;

width = 8.89; % half page
height = width/1.333;
figure('Units','centimeters','Position',[1 10 width height],'Color','w');
d = dir('../data/silver_resistance_vs_temperature_*.xlsx');

data = [];
for i = 1:length(d)
   data = [data;xlsread(['../data/' d(i).name],1,'A2:C16')];
end

[y,s,x] = grpstats(data(:,3),data(:,1),{'mean','sem','gname'});
x = cellfun(@str2num,x);

lm = fitlm(data(:,1),data(:,3),'quadratic');
disp(lm);

bottommargin = 1.04;
leftmargin = 1;

ax = axes('Units','centimeters','Position',[leftmargin bottommargin width-leftmargin height-bottommargin],'Color', 'none','visible','off');
p = polyfit(x,y,2);
k = polyder(p);
slope = polyval(k,20);
relslope = slope / polyval(p,20);
fprintf('Relative slope: %f\n',relslope);
xx = linspace(24.5,95.5);
yy = polyval(p,xx);

teksti = sprintf('{\\ity} = %.3g {\\itx^2} + %.3g {\\itx} + %.3g',p(1),p(2),p(3));
text(44.6,15.0,teksti,'FontName','Times New Roman','FontSize',fsize,'VerticalAlign','middle');
line([36;44],[polyval(p,36);15],'Color','k','LineWidth',0.5);

hold on;
plot(xx,yy,'-','LineWidth',1,'Color',[1 0.4 0.4]); 
line([x x]',[y+s y-s]','LineWidth',0.5,'Color','b');
plot(x,y,'b.','MarkerSize',9,'MarkerEdgeColor','w')
plot(x,y,'b.','MarkerSize',7)

minx = min(x);
maxx = max(x);
miny = min(y-s);
maxy = max(y+s);

xlim([minx-2 maxx+2]);
ylim([miny-0.15 maxy+0.15]);

sideaxes(ax,'west');
rangeline(miny,maxy);
yticks = 14:18;
ticks(yticks);
labels(yticks,0.2,@(x) sprintf('%.0f',x));
labels([miny maxy],0.2,@(x) sprintf('%.1f',x));
labels((miny+maxy)/2,0.6,'Resistance {\itR} (\Omega)','side','west','orientation','vertical');

sideaxes(ax,'south');
rangeline(minx,maxx);
ticks(40:20:80);
labels(40:20:80);
labels([minx maxx]);
labels((minx+maxx)/2,0.6,'Temperature {\itT} (°C)');

%%
if ~exist('../output', 'dir')
    mkdir('../output');
end
addpath('export_fig');
export_fig('../output/Fig_5_resistance_vs_temperature.png','-transparent','-r600');
rmpath('export_fig');
rmpath('common');