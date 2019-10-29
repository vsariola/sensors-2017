function SupplementaryVideo   
    close all;

    addpath('common');

    analogTokPa = @(x) (x/1024.0 - 0.1)*100.0/0.8 * 6.89475729;
    findavg = @(r,t,t1,t2) mean(r(t > t1 & t < t2));
    makerelative = @(x,yz,yo) (x - yz) / (yo - yz);
    neutralize = @(r,t,tz1,tz2,to1,to2) makerelative(r,findavg(r,t,tz1,tz2),findavg(r,t,to1,to2));
    clims = @(x) [min(x) max(x)];
    
    datas = load('../data/demo_resistance_pressure.mat');

    mfun = @(c) median(reshape(datas.data(:,c),datas.params.n,size(datas.data,1)/datas.params.n));
    
    
    tp = mfun(6)/60-0.25-0.005;
    p1 = analogTokPa(mfun(1));
    p2 = analogTokPa(mfun(2));
    p3 = analogTokPa(mfun(3));

    ind = tp > 0;
    tp = tp(ind);
    p1 = p1(ind);
    p2 = p2(ind);
    p3 = p3(ind);
    
    rcomp = 120;
    tores = @(x) rcomp * 1./(1./(0.5 - x) - 1); 
    processres = @(x,rs) tores(x) - rs;

    tr = datas.straindata(:,1)/60-0.2375;
    r1 = processres(datas.straindata(:,2),102);
    r2 = processres(datas.straindata(:,3),100);
    r3 = processres(datas.straindata(:,4),102);

    r1 = neutralize(r1,tr,-0.1,0.2,0.3,0.7);
    r2 = neutralize(r2,tr,-0.1,1.2,1.3,1.7);
    r3 = neutralize(r3,tr,-0.1,2.2,2.3,2.7);
            
    ind = tr > 0;
    tr = tr(ind);
    r1 = r1(ind);
    r2 = r2(ind);
    r3 = r3(ind);
    
    v = VideoReader('../data/gripper_18_5_2017_4271.mp4');
	fudge = 1.25;
    figure('Units','pixels','Position',[100 100 960/fudge 720/fudge]);
    ax1 = axes('Units','pixels','Position',[160 360 640 360]/fudge,'visible','off');
    leftmargin = 100;
    rightmargin = 100;
    bottommargin = 80;    
    gap = 10;
    axheight = (360 - gap*3 - bottommargin)/2-2;
    axwidth = 960 - leftmargin - rightmargin;
    
    axline = axes('Units','pixels','Position',[leftmargin bottommargin axwidth 360-bottommargin-3]/fudge,'visible','off');    
    
    ax2 = axes('Units','pixels','Position',[leftmargin bottommargin+gap*2+axheight axwidth axheight]/fudge,'visible','off');
    hold on;
    plot(tp,p3+40,'-','LineWidth',2,'Color',[1 0.6 1]);    
    plot(tp,p2+20,'-','LineWidth',2,'Color',[1 0.4 0.4]);
    plot(tp,p1,'-','LineWidth',2,'Color',[0.4 0.4 1]);
    hold off;
    ylp = clims([p1 p3+40]); 
    ylim(ylp);
    
    ax3 = sideaxes(ax2,'south','units','pixels','gap',gap/fudge,'size',axheight/fudge,'orientation','north');
    hold on;
	plot(tr,r3+0.7,'-','LineWidth',2,'Color',[1 0.6 1]);    
    plot(tr,r2+0.35,'-','LineWidth',2,'Color',[1 0.4 0.4]);
    plot(tr,r1,'-','LineWidth',2,'Color',[0.4 0.4 1]);
    hold off;
    ylr =clims([r1;r3+0.7]); 
    ylim(ylr);           
    
    sideaxes(ax2,'west');
    rangeline(ylp(1),ylp(2),'Color','w');
    my = mean(ylp);
    ticks([my-25 my+25],[0.1;0.2],'Color','w');
    line([my-25 my+25],[0.15;0.15],'Color','w','LineWidth',0.5);
    labels(my,0.2,'50 kPa','orientation','vertical','Color','w','FontSize',12);
    labels(my,0.75,'Pressure {\itp}','orientation','vertical','Color','w','FontSize',12);

    xl = xlim(ax2);
    sideaxes(ax2,'north','units','pixels','gap',gap/fudge);
    rangeline(-100,100,'Color','w');    

    sideaxes(ax3,'west','units','centimeters');
    rangeline(ylr(1),ylr(2),'Color','w');
    labels(mean(ylr),0.75,'Resistance {\itR}','orientation','vertical','Color','w','FontSize',12);
    labels(mean(ylr),0.2,'(a.u.)','orientation','vertical','Color','w','FontSize',12);

    sideaxes(ax3,'south','units','pixels','gap',gap/fudge,'link',false);
    rangeline(-100,100,'Color','w');        
    labels(2,30,'Time {\itt} (min)','Color','w','FontSize',12);
    
    
    ax4 = sideaxes(ax3,'south','units','pixels','gap',gap/fudge,'size',bottommargin/fudge);
    ticks(0:0.5:4,[0;gap/fudge],'Color','w');    
    labels(0:0.5:4,2*gap/fudge,[],'Color','w','Clipping','on','FontSize',12);
       
    if ~exist('output','dir')
        mkdir('output');
    end 
    
    vout = VideoWriter('output/output.avi');
    vout.FrameRate = v.FrameRate;
    
    set(gcf,'color','k');
    
    multiplier = 10;
    framenum = 0;
    open(vout);
    
    xlims = [-0.05 3.25];
    xlim(ax2,xlims);                
    xlim(ax3,xlims);
    xlim(ax4,xlims);
    xlim(axline,xlims);
    ylim(axline,[0 1]);
    
    while hasFrame(v)    
        video = readFrame(v);                
        framenum = framenum + 1;
        if (mod(framenum-1,multiplier) ~= 0)
            continue;
        end
                      
        curTime = (v.currentTime - 17.3) / 60;
        
        if (curTime < 0)
            continue;
        end
        
        axes(ax1);        
        
        imshow(video);
        text(1580,0,sprintf('%d X',multiplier),'FontSize',20,'HorizontalAlign','right','VerticalAlign','top','Color','w');
                        
        %xlim(ax2,[-0.05 3.25]-3.25+curTime);
        %xlim(ax3,[-0.05 3.25]-3.25+curTime);
        %xlim(ax4,[-0.05 3.25]-3.25+curTime);
                
        cla(axline);
        line(axline,[curTime curTime]',[0 1]','Color','w','LineWidth',0.5,'LineStyle','--');
        
        F = getframe(gcf);
        writeVideo(vout,F);                
    end    
    close(vout);
end
    