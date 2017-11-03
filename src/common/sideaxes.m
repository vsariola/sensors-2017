function ret = sideaxes(varargin)

    [ax,arg,~] = axescheck(varargin{:});

    if (isempty(ax))
        ax = gca;
    end
    fig = ancestor(ax,'figure');

    expectedSides = {'north','south','west','east'};
    expectedUnits = {'pixels','normalized','inches','centimeters','points','characters'};
    expectedOrientation = {'relative','west','east','south','north'};

    p = inputParser();
    p.KeepUnmatched = true;
    addRequired(p,'side',@(x) any(validatestring(x,expectedSides)));
    addParameter(p,'gap',0,@isnumeric);
    addParameter(p,'link',true);
    addParameter(p,'size',[],@(x) isempty(x) || isnumeric(x));
    addParameter(p,'units','centimeter',@(x) any(validatestring(x,expectedUnits)));
    addParameter(p,'orientation','relative',@(x) any(validatestring(x,expectedOrientation)));
    parse(p,arg{1},arg{2:end});

    mpn = getInUnits(ax,'Position','normalized');
    mpu = getInUnits(ax,'Position',p.Results.units);
    s = mpn(3:4) ./ mpu(3:4);
    size = p.Results.size;
    
    if strcmp(p.Results.side,'west')
        if (isempty(size))
            size = mpu(1)-p.Results.gap;
        end
        subpos = [(mpn(1)-s(1)*(p.Results.gap+size)) mpn(2) size*s(1) mpn(4)];
    elseif strcmp(p.Results.side,'east')
        if (isempty(size))
            size = 1/s(1)-mpu(1)-mpu(3)-p.Results.gap;
        end
        subpos = [(mpn(1)+mpn(3)+s(1)*p.Results.gap) mpn(2) size*s(1) mpn(4)];
    elseif strcmp(p.Results.side,'north')
        if (isempty(size))
            size = 1/s(2)-mpu(2)-mpu(4)-p.Results.gap;
        end
        subpos = [mpn(1) (mpn(2)+mpn(4)+s(2)*p.Results.gap) mpn(3) size*s(2)];
    else        
        if (isempty(size))
            size = mpu(2)-p.Results.gap;
        end
        subpos = [mpn(1) (mpn(2)-s(2)*(p.Results.gap+size)) mpn(3) size*s(2)];
    end
    
    d = [fieldnames(p.Unmatched) struct2cell(p.Unmatched)]';
    d = reshape(d,1,numel(d));
    ret = axes(fig,'Position',subpos,'units','normalized','visible','off',d{:});    
    ret.UserData = p.Results.side;        
    
    orientation = p.Results.orientation;
    if strcmp(orientation,'relative')
        orientation = p.Results.side;
    end
        
    if strcmp(orientation,'west')
        ret.View = ax.View - [90 0];                     
    elseif strcmp(orientation,'east')
        ret.View = ax.View - [90 0];              
        set(ret,'ydir','reverse');
    elseif strcmp(orientation,'south')    
        set(ret,'ydir','reverse')            
    end           
    
    sides = {'north','west','south','east'};        
    IndexOrientation = strfind(sides, orientation);        
    indOrient = find(not(cellfun('isempty', IndexOrientation)));                
    IndexSide = strfind(sides, p.Results.side);        
    indSide = find(not(cellfun('isempty', IndexSide)));
    r2 = mod(indOrient-indSide,2);
        
    if abs(r2 - 1) == 0 
        ret.XLim = [0 size];
    else
        ret.YLim = [0 size];
    end
    
    epsilon = 1e-8;
    callback();
    
    if p.Results.link
        addlistener(ax,{'XLim','YLim'},'PostSet',@callback);        
    end
    
    function callback(~,~)               
        r1 = mod(ax.View(1)-(indSide-1)*90,180);        
        if any(abs(r1 - [0 180]) < epsilon)
            if abs(r2 - 1) == 0                
                ret.YLim = ax.XLim;
            else
                ret.XLim = ax.XLim;
            end
        elseif any(abs(r1 - [90 270]) < epsilon)
            if abs(r2 - 1) == 0
                ret.YLim = ax.YLim;
            else
                ret.XLim = ax.YLim;
            end
        end     
    end
    
    function ret = getInUnits(ax,property,unitType)
        oldUnits = get(ax,'Units');  %# Get the current units for hObject
        set(ax,'Units',unitType);    %# Set the units to unitType
        ret = get(ax,property);    %# Get the propName property of hObject
        set(ax,'Units',oldUnits);    %# Restore the previous units
    end

end
