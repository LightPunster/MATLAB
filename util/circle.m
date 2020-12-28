function circle(x,y,r,varargin)
    if nargin==3
        inc = pi/50;
    else
        inc = varargin{1};
    end

    %Make sure that other plots are not overwritten
    precallState = ishold;
    if ~precallState
        hold on
    end
    
    th = 0:inc:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit);
    
    %Turn hold back off if it was off before call
    if ~precallState
        hold off
    end
end