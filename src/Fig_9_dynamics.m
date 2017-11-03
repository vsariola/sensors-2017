function Fig_9_dynamics
    width = 8.89*2+0.51;
    height = 6.68;
    myxlims = [-0.05 3.2];
    
    leftmargin = 1.22;
    bottommargin = 1.1;
    gap = 0.1;

    times = [1.72 1.92];
    
    lc = 'k';
    
    close all;

    addpath('common');

    d = load('../data/dynamics.mat');
    tp = d.tp;
    p = d.p;
    tr = d.tr;
    r = d.r;
    tk = d.tk;
    k = d.k;
  
   
    figure('Units','centimeters','Position',[1 5 width height],'Color','w');

    mainpos = [leftmargin bottommargin width-leftmargin height-bottommargin];
    axheight = (mainpos(4)-4*gap)/3-0.02;
    axwidth = (mainpos(3)-1*gap)/2-0.02;
   
    rx = axes('Units','centimeters','Position',[mainpos(1) 0 axwidth mainpos(2)],'Color','none','box','off','Visible','off');
    rangeline(myxlims(1),myxlims(2));
    ylim([-mainpos(2) 0]);
    
    linepos = [mainpos(1) mainpos(2) axwidth mainpos(4)-0.02];
    shotax = axes('Units','centimeters','Position',linepos,'Color','none','box','off','visible','off','xtick',[],'ytick',[]);    
    line([times;times],[zeros(size(times));ones(size(times))],'LineStyle','-','Color','w','LineWidth',0.5);
    line(times',ones(size(times))','LineStyle','-','Color','w','LineWidth',0.5);
    line([times;times],[zeros(size(times));ones(size(times))],'LineStyle','--','Color',lc,'LineWidth',0.5);
    line(times',ones(size(times))','LineStyle','--','Color',lc,'LineWidth',0.5);

    ax1pos = [mainpos(1) mainpos(2)+gap*3+axheight*2 axwidth axheight];
    ax1 = axes('Units','centimeters','Position',ax1pos);
    ran = myplot(tp,p);
    xlim(myxlims);
    linkaxes([ax1 rx],'x');
     linkaxes([ax1 shotax],'x');
    sideaxes(ax1,'west');
    ticks([10 30 50]);
    labels([10 30 50],0.2,@(x) sprintf('%.0f',x),'FontSize',10);
    rangeline(ran(1),ran(2));
    labels(mean(ran),0.75,'{\itp} (kPa)','orientation','vertical');
    
    ax2 = sideaxes(ax1,'south','gap',gap,'size',axheight,'orientation','north');
    ran2 = myplot(tr,r);
    linkaxes([ax1 ax2],'x');
    sideaxes(ax2,'west');
    rangeline(ran2(1),ran2(2));
    tickx = 18:2:20;
    ticks(tickx);
    labels(tickx,[],[],'FontSize',10);
    labels(mean(ran2),0.75,'{\itR} (\Omega)','orientation','vertical');

    ax3 = sideaxes(ax2,'south','gap',gap,'size',axheight,'orientation','north');
    ran3 = myplot(tk,k);
    linkaxes([ax1 ax3],'x');
    sideaxes(ax3,'west');
    rangeline(ran3(1),ran3(2));
    ticks(10:10:30);
    labels(10:10:30,[],[],'FontSize',10);
    labels(mean(ran3),0.75,'{\it\kappa} (m^{-1})','orientation','vertical');
   
    ax4 = sideaxes(ax1,'east','gap',gap,'size',axwidth,'orientation','north');
    myplot(tp,p);
    xlim(times);

    sideaxes(ax2,'east','gap',gap,'size',axwidth,'orientation','north');
    myplot(tr,r);
    xlim(times);
    
    ax6 = sideaxes(ax3,'east','gap',gap,'size',axwidth,'orientation','north');
    myplot(tk,k);
    xlim(times);

    linepos2 = linepos + [axwidth+gap 0 0 0];
    shotax2 = axes('Units','centimeters','Position',linepos2,'Color','none','box','off','visible','off','xtick',[],'ytick',[]);    
    line([times;times],[zeros(size(times));ones(size(times))],'LineWidth',0.5,'LineStyle','-','Color','w');
    line(times',ones(size(times))','LineWidth',0.5,'LineStyle','-','Color','w');
    line([times;times],[zeros(size(times));ones(size(times))],'LineWidth',0.5,'LineStyle','--','Color',lc);
    line(times',ones(size(times))','LineWidth',0.5,'LineStyle','--','Color',lc);
    linkaxes([ax4 shotax2],'x');
  
    sideaxes(ax3,'south','gap',gap);
    ticks(0:1:3);
    labels(0:1:3);
    labels(myxlims(2),0.6,'Time {\itt} (min)');
    
    sideaxes(ax6,'south','gap',gap);
    ticks(1.75:0.05:1.9);
    labels(1.75:0.05:1.9);
    rangeline(times(1),times(2));

    doexport();
    
    rmpath('common');
end

function range = myplot(x,y)
    plot(x,y,'b-','LineWidth',1);
    set(gca,'Color','none');
    set(gca,'Visible','off');
    range = [min(y) max(y)];
    ylim(range);
end

function doexport()
    if ~exist('../output', 'dir')
        mkdir('../output');
    end
    addpath('export_fig');
    export_fig('../output/Fig_9_dynamics.png','-r600','-transparent');
    rmpath('export_fig');
end