function Fig_3_silver_resistance_vs_curvature

    addpath('common');

    width = 8.89; % cm
    height = width/1.333; % cm

    close all;
    
    clim = @(lmin,lmax) [lmin-0.05*(lmax-lmin) lmax+0.05*(lmax-lmin)];

    d = load('../data/silver_curvature.mat');
    results = d.results;        
    scale = d.scale;                   
        
    datas = load('../data/silver_resistance_pressure.mat');            
    indsmat = repmat(1:(datas.params.m*2),datas.params.n,1);
    inds = reshape(indsmat,1,numel(indsmat));
    inds = repmat(inds,1,datas.params.cycles);               
    rdata = datas.data(1:(end-datas.params.n),2);   
    pdata = datas.data(1:(end-datas.params.n),3);   
    
    pdata = (pdata/1024.0 - 0.1)*100.0/0.8 * 6.89475729;  
    
    p = bindata(pdata,inds');                       
    [r,rlow,rhigh] = bindata(rdata,inds');           
    
    m2 = (datas.params.m*2);    
    k = m2 * datas.params.cycles;    
       
    cinds = mod((1:datas.params.photofreq:k)-1,m2)+1;
    cdata = results(1:(end-1),4:5);         
    cdata = cdata(:,2) ./ cdata(:,1) / scale * pi / 180 * 100;           
    
    rind = zeros(datas.params.n,datas.params.photofreq);
    rind(:,1) = 1;
    rind = reshape(rind,1,numel(rind));
    rind = repmat(rind,1,k/datas.params.photofreq);
    rfit = rdata(logical(rind));           
    cfit = repmat(cdata',datas.params.n,1);
    cfit = reshape(cfit,1,numel(cfit));    
    fitlm(rfit,cfit);
    
    [c,clow,chigh,cid] = bindata(cdata,cinds);       
                       
    pmatch = p(cid);
    rmatch = r(cid);
    fitresult = fit(c,pmatch,'exp2');     

    figure('Units','centimeters','Position',[1 10 width height]);
    ax1 = axes('Position',[0.155 0.175 0.845 0.825]);
           
    halfind = floor(numel(c)/2)+1;
    xu = c(1:halfind);
    yu = rmatch(1:halfind);
    xd = [c(halfind:end);c(1)];
    yd = [rmatch(halfind:end);rmatch(1)];           
        
    hold on; 
    xx = linspace(xu(1),xu(end));    
    
    pol = polyfit(cfit',rfit,1);    
    
    hl =  plot(xx,polyval(pol,xx),'--','LineWidth',1,'Color','k','LineWidth',0.5);        
    
    spu = spaps(xu,yu,5e-3);        
    y1 = spval(spu,xx);
    plot(xx,y1,'-','LineWidth',1,'Color',[1 0.4 0.4]);
    hold on;    
    spd = spaps(xd,yd,5e-3);        
    y2 = spval(spd,xx);
    plot(xx,y2,'-','LineWidth',1,'Color',[1 0.4 0.4]);                      
    
    upper = spval(spd,xx);
    lower = spval(spu,xx);
    diff = upper - lower;
    [dd,ii] = max(diff);
    xxopt = xx(ii);
    
    yh = spval(spd,xxopt);
    yl = spval(spu,xxopt);
    plot([xxopt xxopt],[yh yl],'.','Color','w','MarkerSize',9);
    plot([xxopt xxopt],[yh yl],'.','Color','k','MarkerSize',7);
    line([18 18;xxopt xxopt],[yh yh;yl yl]','LineStyle','-','Color','k','LineWidth',0.5);
    line([18.3;18.3],[yh;yl],'LineStyle','-','Color','k','LineWidth',0.5);    
    hystpercent = dd * 100 / (max(y2) - min(y1));
    fprintf('Hysteresis: %.0f%%\n',hystpercent);
    labels(18,(yh+yl)/2,sprintf('%.0f %% full range',hystpercent),'Orientation','vertical','Side','west','FontSize',8);
    
    teksti = sprintf('{\\itR} = %.2g {\\it\\kappa} + %.3g',pol(1),pol(2));
    legend(hl,{teksti},'Position',[0.48 0.25 0.1 0.1],'FontName','Times New Roman','FontSize',8);
    legend boxoff;
    
    logid = zeros(1,numel(r));
    logid(cid) = 1;   
    logid = ~logid;
    cint = interp1([cid;numel(r)+1],[c;c(1)],find(logid))';
    
    line([cint cint]',[r(logid) rhigh(logid)]','Color','w','LineWidth',1.3);
    line([cint cint]',[r(logid) rlow(logid)]','Color','w','LineWidth',1.3);    
    line([cint cint]',[r(logid) rhigh(logid)]','Color',[0.5 0.5 0.5]);
    line([cint cint]',[r(logid) rlow(logid)]','Color',[0.5 0.5 0.5]);    
    plot(cint,r(logid),'w.','MarkerSize',9);
    plot(cint,r(logid),'.','MarkerSize',7,'Color',[0.5 0.5 0.5]);

    line([c c]',[rmatch rhigh(cid)]','Color','w','LineWidth',1.3);
    line([c c]',[rmatch rlow(cid)]','Color','w','LineWidth',1.3);    
    line([clow c]',[rmatch rmatch]','Color','w','LineWidth',1.3);
    line([chigh c]',[rmatch rmatch]','Color','w','LineWidth',1.3);   
    
    line([c c]',[rmatch rhigh(cid)]','Color','b');
    line([c c]',[rmatch rlow(cid)]','Color','b');    
    line([clow c]',[rmatch rmatch]','Color','b');
    line([chigh c]',[rmatch rmatch]','Color','b');    
    plot(c,rmatch,'w.','MarkerSize',9);
    plot(c,rmatch,'b.','MarkerSize',7);
           
    minx = min(c);
    maxx = max(c);
    miny = min(r);
    maxy = max(r);    
    
    hold off;   
    
    ylim(clim(miny-0.09,maxy-0.03)); 
    set(ax1,'visible','off');
    xlim(clim(minx,maxx-0.2));    

    sideaxes(ax1,'west');
    rangeline(miny,maxy);
    yticks = 16:0.5:17;
    ticks(yticks,0.1);
    fun = @(x) sprintf('%g',x);
    fun2 = @(x) sprintf('%.1f',x);
    labels(yticks,0.2,fun);
    labels([miny maxy],0.2,fun2);
    labels((miny+maxy)/2,0.9,'Resistance {\itR} (\Omega)','orientation','vertical');

    sideaxes(ax1,'south');
    rangeline(minx,maxx);
    xticks = 10:5:25;
    ticks(xticks,0.1);
    fun = @(x) {sprintf('%g',x);sprintf('%.0f',fitresult(x))};
    fun2 = @(x,d) {sprintf(sprintf('%%.%df',d),x);sprintf('%.0f',fitresult(x))};
    labels(xticks,0.2,fun);
    labels(maxx,0.2,@(x) fun2(x,0));
    labels(minx,0.2,@(x) fun2(minx,0));
    labels(3.5,0.08,{'{\it\kappa} (m^{-1})';'{\itp} (kPa)'});
    
    set(gcf,'color','w'); % white background

    %%
    addpath('export_fig');
    if ~exist('../output', 'dir')
        mkdir('../output');
    end
    export_fig('../output/Fig_3_silver_curvature_vs_resistance.pdf','-transparent');
           
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