function Fig_4_curvature_vs_pressure

    addpath('common');

    width = 4.7*1.5; % cm
    height = 4.7; % cm

    close all;
    
    clim = @(lmin,lmax) [lmin-0.05*(lmax-lmin) lmax+0.05*(lmax-lmin)];

    d = load('../data/silver_curvature.mat');
    results = d.results;        
    scale = d.scale;                   
        
    datas = load('../data/silver_resistance_pressure.mat');            
    indsmat = repmat(1:(datas.params.m*2),datas.params.n,1);
    inds = reshape(indsmat,1,numel(indsmat));
    inds = repmat(inds,1,datas.params.cycles);                   
    pdata = datas.data(1:(end-datas.params.n),3);   
    
    pdata = (pdata/1024.0 - 0.1)*100.0/0.8 * 6.89475729;  
    
    [p,plow,phigh] = bindata(pdata,inds');                           
    
    m2 = (datas.params.m*2);    
    k = m2 * datas.params.cycles;    
       
    cinds = mod((1:datas.params.photofreq:k)-1,m2)+1;
    cdata = results(1:(end-1),4:5);         
    cdata = cdata(:,2) ./ cdata(:,1) / scale * pi / 180 * 100;    
    
    [c,clow,chigh,cid] = bindata(cdata,cinds);       
                           
    pmatch = p(cid);    
    fitresult = fit(c,pmatch,'exp2');     
    
    figure('Units','centimeters','Position',[1 10 width height]);
    ax1 = axes('Position',[0.18 0.15 0.82 0.85]);
           
    halfind = floor(numel(c)/2)+1;
    hold on;
    yy = linspace(c(1),c(halfind));       
    
    plot(fitresult(yy),yy,'-','LineWidth',1,'Color',[1 0.4 0.4]);    
    
    logid = zeros(1,numel(p));
    logid(cid) = 1;   
    logid = ~logid;
    cint = interp1([cid;numel(p)+1],[c;c(1)],find(logid))';
    
    line([p(logid) phigh(logid)]',[cint cint]','Color',[0.5 0.5 0.5]);
    line([p(logid) plow(logid)]',[cint cint]','Color',[0.5 0.5 0.5]);    
    plot(p(logid),cint,'w.','MarkerSize',9);
    plot(p(logid),cint,'.','MarkerSize',7,'Color',[0.5 0.5 0.5]);

    line([pmatch phigh(cid)]',[c c]','Color','b');
    line([pmatch plow(cid)]',[c c]','Color','b');    
    line([pmatch pmatch]',[clow c]','Color','b');
    line([pmatch pmatch]',[chigh c]','Color','b');    
    plot(pmatch,c,'w.','MarkerSize',9);
    plot(pmatch,c,'b.','MarkerSize',7);
           
    minx = min(p);
    maxx = max(p);
    miny = min(c);
    maxy = max(c);    
        
    hold off;   
    
    ylim(clim(miny-0.09,maxy-0.03)); 
    set(ax1,'visible','off');
    xlim(clim(minx,maxx-0.2));    

    sideaxes(ax1,'west');
    rangeline(miny,maxy);
    yticks = 10:5:25;
    ticks(yticks,0.1);
    fun = @(x) sprintf('%.0f',x);
    labels(yticks,0.2,fun);
    labels([miny maxy],0.2,fun);
    labels((miny+maxy)/2,0.8,'Curvature {\it\kappa} (m^{-1})','orientation','vertical');

    sideaxes(ax1,'south');
    rangeline(minx,maxx);
    xticks = 20:20:60;
    ticks(xticks,0.1);
    labels(xticks,0.2,fun);
    labels(minx,0.2,fun);
    labels(30,0.2,'{\itp} (kPa)');    
    
    set(gcf,'color','w'); % white background
    
    addpath('export_fig');
    if ~exist('../output', 'dir')
        mkdir('../output');
    end
    export_fig('../output/Fig_4_curvature_vs_pressure.pdf','-transparent');
    
    rmpath('export_fig');
    rmpath('common');
    
    
    function [med,low,high,bid] = bindata(x,id)                
        [stats,bidstr] = grpstats(x,id, {@(y) prctile(y, [25 50 75]'),'gname'});        
        med = stats(:,2);
        low = stats(:,1);
        high = stats(:,3);
        bid = cellfun(@str2num,bidstr);
        [bid,sind] = sort(bid);
        med = med(sind);
        low = low(sind);
        high = high(sind);
    end
end