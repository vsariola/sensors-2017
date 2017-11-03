function Fig_10_demo

addpath('common');


width = 11.5;
height = 4.5;

analogTokPa = @(x) (x/1024.0 - 0.1)*100.0/0.8 * 6.89475729;
findavg = @(r,t,t1,t2) mean(r(t > t1 & t < t2));
makerelative = @(x,yz,yo) (x - yz) / (yo - yz);
neutralize = @(r,t,tz1,tz2,to1,to2) makerelative(r,findavg(r,t,tz1,tz2),findavg(r,t,to1,to2));

datas = load('../data/demo_resistance_pressure.mat');

mfun = @(c) median(reshape(datas.data(:,c),datas.params.n,size(datas.data,1)/datas.params.n));

tp = mfun(6)/60-0.25;
p1 = analogTokPa(mfun(1));
p2 = analogTokPa(mfun(2));
p3 = analogTokPa(mfun(3));

rcomp = 120;
tores = @(x) rcomp * 1./(1./(0.5 - x) - 1); 
processres = @(x,rs) tores(x) - rs;

tr = datas.straindata(:,1)/60-0.2382;
r1 = processres(datas.straindata(:,2),102);
r2 = processres(datas.straindata(:,3),100);
r3 = processres(datas.straindata(:,4),102);

r1 = neutralize(r1,tr,-0.1,0.2,0.3,0.7);
r2 = neutralize(r2,tr,-0.1,1.2,1.3,1.7);
r3 = neutralize(r3,tr,-0.1,2.2,2.3,2.7);

figure('Units','centimeters','Position',[1 10 width height],'Color','w');

leftmargin = 1.15;
bottommargin = 0.72;
topmargin = 0.1;
gap = 0.1;
axheight = (height - gap*3 - topmargin - bottommargin)/2;
axwidth = width - leftmargin;
ax1 = axes('Units','centimeters','Position',[leftmargin bottommargin+gap*2+axheight axwidth axheight],'visible','off');

clims = @(x) [min(x) max(x)];

hold on;
plot(tp,p3+40,'-','LineWidth',1,'Color',[1 0.6 1]);
plot(tp,p2+20,'-','LineWidth',1,'Color',[1 0.4 0.4]);
plot(tp,p1,'b','LineWidth',1);

ylp = clims([p1 p3+40]); 
ylim(ylp);
xlim([-0.05 3.25]);

ax2 = sideaxes(ax1,'south','units','centimeters','gap',gap,'size',axheight,'orientation','north');

hold on;
plot(tr,r3+0.7,'-','LineWidth',1,'Color',[1 0.6 1]);
plot(tr,r2+0.35,'-','LineWidth',1,'Color',[1 0.4 0.4]);
plot(tr,r1,'b','LineWidth',1);

ylr =clims([r1;r3+0.7]); 
ylim(ylr);
linkaxes([ax1 ax2],'x');

sideaxes(ax1,'west','units','centimeters');
rangeline(ylp(1),ylp(2));
my = mean(ylp);
ticks([my-25 my+25],[0.1;0.2]);
line([my-25 my+25],[0.15;0.15],'Color','k','LineWidth',0.5);
labels(my,0.2,'50 kPa','orientation','vertical');
labels(my+10,0.75,'Pressure {\itp}','orientation','vertical');

xl = xlim(ax1);
sideaxes(ax1,'north','units','centimeters','gap',gap);
rangeline(xl(1),xl(2));
times = [0.1 0.5 1.5 2.5 2.9];
ticks(times);

sideaxes(ax2,'west','units','centimeters');
rangeline(ylr(1),ylr(2));
labels(mean(ylr)-0.5,0.75,'Resistance {\itR}','orientation','vertical');
labels(mean(ylr),0.2,'(a.u.)','orientation','vertical');

sideaxes(ax2,'south','units','centimeters','gap',gap);
rangeline(xl(1),xl(2));
ticks(0:1:3);
labels(0:1:3);
labels(1.5,0.2,'Time {\itt} (min)');

%%
if ~exist('../output', 'dir')
    mkdir('../output');
end
addpath('export_fig');
export_fig('../output/Fig_10_demo.pdf','-transparent');
rmpath('export_fig');
rmpath('common');